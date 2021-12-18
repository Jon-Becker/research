# Adidas Originals Failed NFT Drop

  ##### December 18, 2021&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  
  ![BAYC x Adidas](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/adidas-originals/preview.png?fw)

  Adidas recently partnered with popular NFT brands gmoney, Bored Ape Yacht Club, and PUNKS Comics to release a collection of NFTs called ["Into The Metaverse"](https://etherscan.io/token/0x28472a58a490c5e09a238847f66a68a47cc76f0f#tokenInfo). For their mint, Adidas set a limit of two NFTs per address, yet someone managed to mint **330** tokens in one singular transaction.

  In this research paper I will take a look at [the transaction](https://etherscan.io/tx/0x6a3d8584a6272a1d73ff297592b401fe10d3a90fd385efff55f68f32f29ecf61) that was used to mint these tokens as well as the [Adidas' code](https://etherscan.io/address/0x28472a58a490c5e09a238847f66a68a47cc76f0f#code) that was exploited.

# 0x01. Minting
  
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

  After paying for all 330 NFTs, including gas fees, this singular transaction cost an astounding ``93.39 Ethereum``.

----

### 0x05. Resources & Citations

  - 