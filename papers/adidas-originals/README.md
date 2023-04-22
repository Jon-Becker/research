# Adidas Originals Failed NFT Drop

  ##### December 18, 2021&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  
  ![BAYC x Adidas](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/adidas-originals/preview.png?fw)

  Adidas recently partnered with popular NFT brands gmoney, Bored Ape Yacht Club, and PUNKS Comics to release a collection of NFTs called ["Into The Metaverse"](https://etherscan.io/token/0x28472a58a490c5e09a238847f66a68a47cc76f0f#tokenInfo). For their mint, Adidas set a limit of two NFTs per address, yet someone managed to mint **330** tokens in one singular transaction.

  In this research paper I will take a look at [the transaction](https://etherscan.io/tx/0x6a3d8584a6272a1d73ff297592b401fe10d3a90fd385efff55f68f32f29ecf61) that was used to mint these tokens as well as the [Adidas' code](https://etherscan.io/address/0x28472a58a490c5e09a238847f66a68a47cc76f0f#code) that was exploited.

## Minting
  
  Within Adidas' smart contract code, we can find the ``purchase(){...}`` function which performs a check to see if the msg.sender has minted more than ``maxTxPublic`` tokens, 2 in this case. After making this check, ``_purchase(){...}`` is called, which performs some more simple checks before minting the token.

  ```
    function purchase(uint256 amount) external payable whenNotPaused {
        require(block.timestamp >= purchaseWindowOpens && block.timestamp <= purchaseWindowCloses, "Purchase: window closed");
        require(purchaseTxs[msg.sender] < maxTxPublic , "max tx amount exceeded");

        _purchase(amount);

    }
    function _purchase(uint256 amount) private {
        require(amount > 0 && amount <= maxPerTx, "Purchase: amount prohibited");
        require(totalSupply(0) + amount <= MAX_SUPPLY, "Purchase: Max supply reached");
        require(msg.value == amount * mintPrice, "Purchase: Incorrect payment");

        purchaseTxs[msg.sender] += 1;

        _mint(msg.sender, 0, amount, "");
        emit Purchased(0, msg.sender, amount);
    }
  ```

  From this section of code, we can see that there is no prevention from *contracts* minting tokens.

  This flaw in the minting system was taken advantage of by [notchefbob.eth](https://etherscan.io/address/0x82416784046af6e6cfc7fda2b362dc6223dd7b48), who created and deployed 165 contract addresses in a singular transaction, which then minted 2 NFTs each before transferring them out and self destructing.

  ![Transaction Stack Trace](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/adidas-originals/1.png)

  After paying for all 330 NFTs, including gas fees, this singular transaction cost an astounding ``93.39 Ethereum``. At a current floor price of ``0.851 Ethereum``, however, this user has unrealized gains of over ``190 Ethereum``.

## Fixing the Contract

  In order to prevent this sort of thing from happening in the future, NFT minting drops should have checks to ensure that the minting addresses are not contract addresses. There are a few methods to doing this, which I will explore below.

  - **Checking EXTCODESIZE** 

    Ethereum has a built-in OPCODE for checking the bytecode size of an external address called ``EXTCODESIZE``. While normal Ethereum addresses have bytecode sizes of ``0``, all contracts will have a non-zero value, as long as they are not in the constructor.

    - This alone cannot completely prevent contract interaction. Contracts that are still within their constructor will return a ``0`` value for their ``EXTCODESIZE``, and will appear like an address.
  
  - **Using tx.origin**

    You can also use the following statement to prevent contracts from interacting with your code.

    ```
    require(msg.sender == tx.origin)
    ```

    This can lead to some [security](https://docs.soliditylang.org/en/v0.4.24/security-considerations.html#tx-origin) issues, but will prevent contracts from interacting with your contract. While ``msg.sender`` refers to the immediate sender, ``tx.origin`` refers to the account that started the transaction. If these two variables do not match, then it is safe to assume that you're dealing with a contract.

  After implementing these changes, the resulting code becomes:
  ```
    modifier isNotContract (address _addr){
      uint len;
      assembly {
        len := extcodesize(_addr)
      }
      require(len == 0, "Purchase: Account is not an EOA");
      _;
    }

    function purchase(uint256 amount) external payable whenNotPaused isNotContract {
        require(block.timestamp >= purchaseWindowOpens && block.timestamp <= purchaseWindowCloses, "Purchase: window closed");
        require(msg.sender == tx.origin, "Purchase: Account is not an EOA");
        require(purchaseTxs[msg.sender] < maxTxPublic , "max tx amount exceeded");

        _purchase(amount);

    }
    function _purchase(uint256 amount) private {
        require(amount > 0 && amount <= maxPerTx, "Purchase: amount prohibited");
        require(totalSupply(0) + amount <= MAX_SUPPLY, "Purchase: Max supply reached");
        require(msg.value == amount * mintPrice, "Purchase: Incorrect payment");

        purchaseTxs[msg.sender] += 1;

        _mint(msg.sender, 0, amount, "");
        emit Purchased(0, msg.sender, amount);
    }
  ```

----

### Resources & Citations

  - Adidas Steps Into the Metaverse by Partnering With NFT Projects Bored Ape Yacht Club, Punks Comic [https://news.bitcoin.com](https://news.bitcoin.com/adidas-steps-into-the-metaverse-by-partnering-with-nft-projects-bored-ape-yacht-club-punks-comic/)
  - Solidity Documentation [https://docs.soliditylang.org/](https://docs.soliditylang.org/en/v0.4.24/security-considerations.html#tx-origin)
  - Various Ethereum Transactions [[notchefbob.eth](https://etherscan.io/address/0x82416784046af6e6cfc7fda2b362dc6223dd7b48), [mint transaction](https://etherscan.io/tx/0x6a3d8584a6272a1d73ff297592b401fe10d3a90fd385efff55f68f32f29ecf61), ["Adidas: Into The Metaverse"](https://etherscan.io/token/0x28472a58a490c5e09a238847f66a68a47cc76f0f#tokenInfo)]