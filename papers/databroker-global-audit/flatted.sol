pragma solidity ^0.8.6;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// https://docs.openzeppelin.com/contracts/4.x/api/proxy#transparent-vs-uups
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DatabrokerDeals is
  Initializable,
  UUPSUpgradeable,
  AccessControlUpgradeable,
  PausableUpgradeable
{
  using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
  using CountersUpgradeable for CountersUpgradeable.Counter;

  struct Deal {
    string did;
    address buyerId;
    address sellerId;
    bytes32 dataUrl;
    uint256 dealIndex;
    uint256 amountInDTX;
    uint256 amountInUSDT;
    uint256 validFrom;
    uint256 validUntil;
    uint256 platformPercentage;
    uint256 stakingPercentage;
    address platformAddress;
    bool accepted;
    bool payoutCompleted;
  }

  IERC20 private _usdtToken;
  IERC20 private _dtxToken;
  IUniswapV2Router01 private _uniswap;
  CountersUpgradeable.Counter private _dealIndex;
  EnumerableSetUpgradeable.UintSet private _pendingDeals;

  uint128 private _uinswapDeadline;
  uint128 private _slippagePercentage;
  address private _dtxStakingAddress;
  address private _payoutWalletAddress;
  bytes32 private constant OWNER_ROLE = keccak256("OWNER_ROLE");
  bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

  mapping(string => uint256[]) private _didToDealIndexes;
  mapping(address => uint256[]) private _userToDealIndexes;
  mapping(uint256 => Deal) private _dealIndexToDeal;

  modifier isDealIndexValid(uint256 dealIndex) {
    require(
      dealIndex <= _dealIndex.current(),
      "DatabrokerDeals: Invalid deal index"
    );
    _;
  }
  modifier hasOwnerRole() {
    require(hasRole(OWNER_ROLE, msg.sender), "Caller is not an owner");
    _;
  }
  modifier hasAdminRole() {
    require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");
    _;
  }
  modifier isPendingDealsEmpty() {
    require(
      _pendingDeals.length() == 0,
      "DatabrokerDeals: Payout is still pending for some deals"
    );
    _;
  }

  event DealCreated(uint256 dealIndex, string did);
  event Payout(
    uint256 dealIndex,
    uint256 sellerAmount,
    uint256 stakingCommission,
    uint256 platformCommission
  );
  event SettleDeal(uint256 dealIndex, uint256 buyerAmount);
  event SwapTokens(
    address fromToken,
    address toToken,
    uint256 amountIn,
    uint256 amountOut,
    address receiverAddress
  );

  function initialize(
    address usdtToken,
    address dtxToken,
    address uniswap,
    address payoutWalletAddress,
    address dtxStakingAddress,
    address admin,
    uint128 uinswapDeadline,
    uint128 slippagePercentage
  ) public initializer {
    AccessControlUpgradeable.__AccessControl_init();
    PausableUpgradeable.__Pausable_init();

    _usdtToken = IERC20(usdtToken);
    _dtxToken = IERC20(dtxToken);
    _uniswap = IUniswapV2Router01(uniswap);
    _payoutWalletAddress = payoutWalletAddress;
    _dtxStakingAddress = dtxStakingAddress;
    _uinswapDeadline = uinswapDeadline;
    _slippagePercentage = slippagePercentage;

    _setupRole(OWNER_ROLE, msg.sender);
    _setupRole(ADMIN_ROLE, msg.sender);
    _setupRole(ADMIN_ROLE, admin);
  }

  function _authorizeUpgrade(address) internal override hasAdminRole {}

  function pauseContract() public hasAdminRole {
    _pause();
  }

  function unPauseContract() public hasAdminRole {
    _unpause();
  }

  function createDeal(
    string memory did,
    address buyerId,
    address sellerId,
    bytes32 dataUrl,
    uint256 amountInUSDT,
    uint256 amountOutMin,
    uint256 platformPercentage,
    uint256 stakingPercentage,
    uint256 lockPeriod,
    address platformAddress
  ) public whenNotPaused hasAdminRole {
    address[] memory USDTToDTXPath = new address[](2);
    USDTToDTXPath[0] = address(_usdtToken);
    USDTToDTXPath[1] = address(_dtxToken);

    uint256 amountInDTX = _swapTokens(
      amountInUSDT,
      amountOutMin,
      USDTToDTXPath,
      address(this),
      block.timestamp + _uinswapDeadline
    );
    uint256 dealIndex = _dealIndex.current();

    Deal memory newDeal = Deal(
      did,
      buyerId,
      sellerId,
      dataUrl,
      dealIndex,
      amountInDTX,
      amountInUSDT,
      block.timestamp,
      block.timestamp + lockPeriod,
      platformPercentage,
      stakingPercentage,
      platformAddress,
      true,
      false
    );

    _didToDealIndexes[did].push(dealIndex);
    _dealIndexToDeal[dealIndex] = newDeal;
    _pendingDeals.add(dealIndex);

    _userToDealIndexes[sellerId].push(dealIndex);
    if (sellerId != buyerId) { // TODO: create deal where seller is same as buyer? fuzz this.
      _userToDealIndexes[buyerId].push(dealIndex);
    }

    emit DealCreated(dealIndex, did);

    _dealIndex.increment();
  }

  function payout(uint256 dealIndex) public whenNotPaused hasAdminRole {
    Deal storage deal = _dealIndexToDeal[dealIndex];

    require(!deal.payoutCompleted, "DatabrokerDeals: Payout already processed");
    require(deal.accepted, "DatabrokerDeals: Deal was declined by buyer");
    require(
      deal.validUntil <= block.timestamp,
      "DatabrokerDeals: Deal is locked for payout"
    );

    address[] memory DTXToUSDTPath = new address[](2);
    DTXToUSDTPath[0] = address(_dtxToken);
    DTXToUSDTPath[1] = address(_usdtToken);

    (
      uint256 sellerAmountInDTX,
      uint256 databrokerCommission,
      uint256 stakingCommission
    ) = calculateTransferAmount(dealIndex, DTXToUSDTPath);

    require(
      _dtxToken.balanceOf(address(this)) >=
        (sellerAmountInDTX + databrokerCommission + stakingCommission),
      "DatabrokerDeals: Insufficient DTX balance of contract"
    );

    uint256[] memory sellerAmounts = _uniswap.getAmountsOut(
      sellerAmountInDTX,
      DTXToUSDTPath
    );
    uint256 sellerAmountOutMin = sellerAmounts[1] -
      ((sellerAmounts[1] * _slippagePercentage) / 10000);

    // Seller's USDT to payout wallet address
    _swapTokens(
      sellerAmountInDTX,
      sellerAmountOutMin,
      DTXToUSDTPath,
      _payoutWalletAddress,
      block.timestamp + _uinswapDeadline
    );

    require(
      _dtxToken.transfer(_dtxStakingAddress, stakingCommission),
      "DTX transfer failed for _dtxStakingAddress"
    );

    require(
      _dtxToken.transfer(deal.platformAddress, databrokerCommission),
      "DTX transfer failed for platformAddress"
    );

    _pendingDeals.remove(dealIndex);
    deal.payoutCompleted = true; //possible reentrancy?

    emit Payout(
      dealIndex,
      sellerAmounts[1],
      stakingCommission,
      databrokerCommission
    );
  }

  function calculateTransferAmount(
    uint256 dealIndex,
    address[] memory DTXToUSDTPath
  )
    public
    view
    isDealIndexValid(dealIndex)
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    Deal memory deal = _dealIndexToDeal[dealIndex];

    uint256 platformShareInDTX = (deal.amountInDTX *
      (deal.platformPercentage)) / (100);
    uint256 sellerShareInDTX = deal.amountInDTX - platformShareInDTX;

    uint256 platformShareInUSDT = (deal.amountInUSDT *
      (deal.platformPercentage)) / (100);
    uint256 sellerShareInUSDT = deal.amountInUSDT - platformShareInUSDT;

    uint256[] memory sellerSwapAmounts = _uniswap.getAmountsIn(
      sellerShareInUSDT,
      DTXToUSDTPath
    );

    // Adjust the DTX tokens that needs to be converted for seller, also adjust the platform commission accordingly
    uint256 sellerTransferAmountInDTX;
    uint256 platformCommission = 0;
    if (sellerSwapAmounts[0] > sellerShareInDTX) {
      uint256 extraDTXToBeAdded = sellerSwapAmounts[0] - (sellerShareInDTX);
      sellerTransferAmountInDTX = sellerShareInDTX + (extraDTXToBeAdded);

      if (platformShareInDTX > extraDTXToBeAdded) {
        platformCommission = platformShareInDTX - (extraDTXToBeAdded);
      } else {
        platformCommission = 0;
      }
    } else {
      uint256 extraDTXToBeRemoved = sellerShareInDTX - (sellerSwapAmounts[0]);
      sellerTransferAmountInDTX = sellerShareInDTX - extraDTXToBeRemoved;
      platformCommission = platformShareInDTX + extraDTXToBeRemoved;
    }

    uint256 stakingCommission = (platformCommission * deal.stakingPercentage) /
      100;
    uint256 databrokerCommission = platformCommission - stakingCommission;

    return (sellerTransferAmountInDTX, databrokerCommission, stakingCommission);
  }

  function declineDeal(uint256 dealIndex) public whenNotPaused hasAdminRole {
    Deal storage deal = _dealIndexToDeal[dealIndex];

    require(deal.accepted, "DatabrokerDeals: Deal was already declined");
    require(
      deal.validUntil > block.timestamp,
      "DatabrokerDeals: Time duration for declining the deal is over"
    );

    deal.accepted = false;
  }

  function acceptDeal(uint256 dealIndex) public whenNotPaused hasAdminRole {
    Deal storage deal = _dealIndexToDeal[dealIndex];

    require(!deal.accepted, "DatabrokerDeals: Deal was already accepted");
    require(
      deal.validUntil > block.timestamp,
      "DatabrokerDeals: Time duration for accepting the deal is over"
    );

    deal.accepted = true;
  }

  function settleDeclinedDeal(uint256 dealIndex)
    public
    whenNotPaused
    hasAdminRole
  {
    Deal storage deal = _dealIndexToDeal[dealIndex];

    require(!deal.payoutCompleted, "DatabrokerDeals: Payout already processed");
    require(!deal.accepted, "DatabrokerDeals: Deal is not declined by buyer");
    require(
      deal.validUntil <= block.timestamp,
      "DatabrokerDeals: Deal is locked for payout"
    );

    address[] memory DTXToUSDTPath = new address[](2);
    DTXToUSDTPath[0] = address(_dtxToken);
    DTXToUSDTPath[1] = address(_usdtToken);

    uint256[] memory amountsIn = _uniswap.getAmountsIn(
      deal.amountInUSDT,
      DTXToUSDTPath
    );
    uint256 buyerAmountOutMin = amountsIn[1] -
      (amountsIn[1] * _slippagePercentage) /
      10000;

    require(
      _dtxToken.balanceOf(address(this)) >= amountsIn[0],
      "DatabrokerDeals: Insufficient DTX balance of contract"
    );

    // Buyer's USDT to payout wallet address
    _swapTokens(
      amountsIn[0],
      buyerAmountOutMin,
      DTXToUSDTPath,
      _payoutWalletAddress,
      block.timestamp + _uinswapDeadline
    );

    deal.payoutCompleted = true;
    _pendingDeals.remove(dealIndex);

    emit SettleDeal(dealIndex, amountsIn[1]);
  }

  function _swapTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] memory path,
    address receiverAddress,
    uint256 deadline
  ) internal returns (uint256) {
    // Give approval for the uniswap to swap the USDT token from this contract address
    IERC20(path[0]).approve(address(_uniswap), amountIn);

    uint256[] memory amounts = _uniswap.swapExactTokensForTokens(
      amountIn,
      amountOutMin,
      path,
      receiverAddress,
      deadline
    );

    emit SwapTokens(path[0], path[1], amountIn, amounts[1], receiverAddress);

    return amounts[1];
  }

  function getDealByIndex(uint256 dealIndex)
    public
    view
    returns (Deal memory deal)
  {
    deal = _dealIndexToDeal[dealIndex];
  }

  function getDealIndexesForDid(string memory did)
    public
    view
    returns (uint256[] memory dealIndexes)
  {
    dealIndexes = _didToDealIndexes[did];
  }

  function getDealIndexesForUser(address user)
    public
    view
    returns (uint256[] memory dealIndexes)
  {
    dealIndexes = _userToDealIndexes[user];
  }

  function getLatestDealIndex() public view returns (uint256) {
    return _dealIndex.current() - 1;
  }

  function updateDtxInstance(address newDTXAddress) public hasAdminRole {
    _dtxToken = IERC20(newDTXAddress);
  }

  function updateUsdtInstance(address newUSDTAddress) public hasAdminRole {
    _usdtToken = IERC20(newUSDTAddress);
  }

  function updateUniswapDeadline(uint128 deadline) public hasAdminRole {
    _uinswapDeadline = deadline;
  }

  function updateSlippagePercentage(uint128 slippagePercentage)
    public
    hasAdminRole
  {
    _slippagePercentage = slippagePercentage;
  }

  function getUniswapDeadline() public view returns (uint128) {
    return _uinswapDeadline;
  }

  function getSlippagePercentage() public view returns (uint128) {
    return _slippagePercentage;
  }

  function withdrawAllUsdt() public hasOwnerRole isPendingDealsEmpty {
    _usdtToken.transfer(msg.sender, _usdtToken.balanceOf(address(this)));
  }

  function withdrawAllDtx() public hasOwnerRole isPendingDealsEmpty {
    require(
      _dtxToken.transfer(msg.sender, _dtxToken.balanceOf(address(this))),
      "DTX transfer failed"
    );
  }

  // Unit test functions
  // Uncomment to run the tests
  // function burnUSDT(uint256 amount) public {
  //   _usdtToken.transfer(0x71CB05EE1b1F506fF321Da3dac38f25c0c9ce6E1, amount);
  // }

  // function burnDTX(uint256 amount) public {
  //   _dtxToken.transfer(0x71CB05EE1b1F506fF321Da3dac38f25c0c9ce6E1, amount);
  // }
}