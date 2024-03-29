# Databroker.global Audit

![databroker](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/databroker-global-audit/preview.png?fw)

This audit was performed on the [DatabrokerGlobal/Polygon-migration](https://github.com/databrokerglobal/Polygon-migration/tree/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9) GitHub repository. The repository version used for this audit was commit `e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9`.

The goal of this audit is to review Databroker's `DatabrokerDeals.sol` smart contract and find and demonstrate potential security issues within the solidity contract. This report will also focus on current Solidity & security best practices.

### Documentation & Whitepaper

The contents of this audit are based on the whitepaper provided by Databroker.global within their [GitHub](https://github.com/databrokerglobal/Polygon-migration/issues/1). In order to provide a quality report of the security and efficiency of their smart contract, I have studied their whitepaper extensively to get a feel for how their system is supposed to function.

## Severity Level Reference

| Severity Level                                                                                     | Description                                                                                                                                                               |
| -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![CRITICAL](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/critical.png) | Findings marked with a critical severity tag must be fixed as soon as possible. These issues may break the contract altogether if not resolved.                           |
| ![HIGH](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/high.png)         | Findings marked with a high severity tag should be fixed as soon as possible, because it is likely they will cause problems in production if left unresolved.             |
| ![MEDIUM](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/medium.png)     | Findings marked with a medium severity tag should be fixed soon, but it is not extremely urgent. These issues have the potential to cause problems in production.         |
| ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)           | Findings marked with a low severity tag can remain unfixed. These are unlikely to cause any problems in production, but resolving them could improve contract efficiency. |

## Security Issues

-   **Payout is Vulnerable To Reentrancy** [ [SWC-107](https://swcregistry.io/docs/SWC-107) ] [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L239-L240) ]

    ![CRITICAL](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/critical.png)

    Although `payout(...)` requires the role `ADMIN_ROLE` in order to be called, it is vulnerable to reentrancy when called because a [state change](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L239-L240) is made after [external calls](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L221-L237) are made. This allows this `payout(...)` function to be called multiple times before the deal is marked as completed.

    In order to properly fix this, the state change should be moved above the external calls. Should the require statements fail after these state changes, they will be reverted.

    Fixed in [827b1d5a87d311197ea872da50f4230ed1811f17](https://github.com/databrokerglobal/Polygon-migration/tree/827b1d5a87d311197ea872da50f4230ed1811f17).

    ```solidity
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
    deal.payoutCompleted = true;
    ```

    Becomes:

    ```solidity
    _pendingDeals.remove(dealIndex);
    deal.payoutCompleted = true;

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
    ```

-   **settleDeclinedDeal is Vulnerable To Reentrancy** [ [SWC-107](https://swcregistry.io/docs/SWC-107) ] [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L367-L368) ]

    ![CRITICAL](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/critical.png)

    Although `settleDeclinedDeal(...)` requires the role `ADMIN_ROLE`, it is vulnerable to reentrancy when called because a [state change](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L367-L368) is made after [external calls](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L359-L365) are made. This allows this `settleDeclinedDeal(...)` function to be called multiple times before the deal is marked as completed.

    In order to properly fix this, the state change should be moved above the external calls. Should the require statements fail after these state changes, they will be reverted.

    Fixed in [827b1d5a87d311197ea872da50f4230ed1811f17](https://github.com/databrokerglobal/Polygon-migration/tree/827b1d5a87d311197ea872da50f4230ed1811f17).

    ```solidity
    _swapTokens(
      amountsIn[0],
      buyerAmountOutMin,
      DTXToUSDTPath,
      _payoutWalletAddress,
      block.timestamp + _uinswapDeadline
    );

    deal.payoutCompleted = true;
    _pendingDeals.remove(dealIndex);
    ```

    Becomes:

    ```solidity
    deal.payoutCompleted = true;
    _pendingDeals.remove(dealIndex);

    _swapTokens(
      amountsIn[0],
      buyerAmountOutMin,
      DTXToUSDTPath,
      _payoutWalletAddress,
      block.timestamp + _uinswapDeadline
    );
    ```

-   **Deals Auto-flagged As Accepted** [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L169) ]

    ![MEDIUM](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/medium.png)

    When calling `createDeal(...)`, a new `Deal` object is created with the `accepted` bool set to true. This should automatically be set to false, since the buyer has not accepted the deal yet. Although there is a timelock implemented, it is bad practice to mark this deal as accepted before the buyer has called `acceptDeal()`. If the timelock were to expire before the buyer had the opportunity to `declineDeal()`, the seller would be able to request a payout without the proper flow being handled.

-   **Timestamp Dependence** [ [SWC-116](https://swcregistry.io/docs/SWC-116) ] [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L152) ]

    ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)

    Timestamps can be manipulated by the miner. It is generally safe to use `block.timestamp`, since [Geth](https://github.com/ethereum/go-ethereum/blob/4e474c74dc2ac1d26b339c32064d0bac98775e77/consensus/ethash/consensus.go#L45) and [Parity](https://github.com/paritytech/parity-ethereum/blob/73db5dda8c0109bb6bc1392624875078f973be14/ethcore/src/verification/verification.rs#L296-L307) reject timestamps that are more than 15 seconds in the future. Since Databroker uses a 30 day timelock, this shouldn't be a problem, but should be kept in mind.

-   **Floating Pragma** [ [SWC-103](https://swcregistry.io/docs/SWC-103) ] [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L1) ]

    ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)

    Contracts should be deployed using the exact compiler version that they have been tested the most with in order to prevent being deployed with a compiler version that may have undiscovered bugs or vulnerabilities. This is best practice when deploying contracts.

-   **Check Deal platformAddress** [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L131-L185) ]

    ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)

    When calling `createDeal` it is best practice to ensure that `platformAddress` is not `0x0` or `address.this()`. Adding a modifier that requires these two conditions would prevent token loss.

    Partially addressed in [827b1d5a87d311197ea872da50f4230ed1811f17](https://github.com/databrokerglobal/Polygon-migration/tree/827b1d5a87d311197ea872da50f4230ed1811f17). Still does not account for `address(this)`.

    ```solidity
    modifier validDestination( address platformAddress ) {
        require(platformAddress != address(0x0));
        require(platformAddress != address(this) );
        _;
    }
    ```

## Performance & Best Practice Issues

-   **Contract Size** [ [EIP-170](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-170.md) ]

    The raw contract code exceeds 24576 bytes, and may not deploy on mainnet correctly if not optimized. It may need to be optimized in order to deploy it.

-   **Computed Constant** [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L49-L50) ]

    It is typically good practice to write the value of predefined constants if you know them before compiling. Using functions such as `keccak256()` when you can compute the hash beforehand is excessive and will waste gas.

    ```solidity
    bytes32 private constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    ```

    ```solidity
    bytes32 private constant OWNER_ROLE = "b19546dff01e856fb3f010c267a7b1c60363cf8a4664e21cc89c26224620214e";
    bytes32 private constant ADMIN_ROLE = "a49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775";
    ```

-   **Seller Can Also Be The Buyer** [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L131-L185) ]

    Assuming you do not want users to be able to create deals with themselves, there should be a require statement after `line 142` that requires `buyerId` and `sellerId` to be different from each other. This shouldn't cause problems with the contract itself, but would reduce gas consumption.

-   **Documentation Issues**

    Proper [NatSpec](https://docs.soliditylang.org/en/develop/natspec-format.html) documentation missing from all functions within `DatabrokerDeals.sol`. Consider adding additional documentation, including inline documentation for ease of readability for consumers.

-   **Variable Issues**

    The variable `_uinswapDeadline` is misspelled and should be corrected to `_uniswapDeadline` in order to maintain professionalism and keep the contract readable and coherent for consumers.``

    Fixed in [827b1d5a87d311197ea872da50f4230ed1811f17](https://github.com/databrokerglobal/Polygon-migration/tree/827b1d5a87d311197ea872da50f4230ed1811f17).

-   **Contract Readability & Consistency**

    This contract uses many different coding styles that should be made uniform for ease of readabity for the consumer. For example, this contract has some functions structured as

    ```solidity
    function payout(uint256 dealIndex) public whenNotPaused hasAdminRole {
      ...
    }
    ```

    while others may be

    ```solidity
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
      ...
    }
    ```

    or

    ```solidity
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
      ...
    }
    ```

    These coding styles must be made uniform in order to allow for users to read and interpret your code with ease.

## Conclusion

A total of 12 issues & recommendations were found within `DatabrokerDeals.sol`, two of which were of critical severity and one of which was of medium severity. The remaining nine issues were either of low severity or were recommendations in order to adhere to solidity best practice.

_Note that as of the date of publishing, the contents of this document reflect my current understanding of known security patterns regarding smart contract security. The findings of this audit should not be considered to be exhaustive, and there may still be issues within the contract itself. This audit is not a guarantee of security. I take no responsibility for future contract security, and only act as a third-party auditor._

---

### Resources & Citations

-   [Consensys Best Practices](https://consensys.github.io/smart-contract-best-practices/)
-   [SWC Registry](https://swcregistry.io)
-   [Ethereum Improvement Proposals](https://eips.ethereum.org)
-   [OpenZeppelin Documentation](https://docs.openzeppelin.com/contracts/4.x/)
