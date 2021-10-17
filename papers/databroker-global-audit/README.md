# Databroker.global Audit

  ##### October 15, 2021&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  
  ![databroker](https://www.databroker.global/images/Databroker_social-share.jpg?fw)

  This audit was performed on the [DatabrokerGlobal/Polygon-migration](https://github.com/databrokerglobal/Polygon-migration/tree/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9) GitHub repository. The repository version used for this audit was commit ``e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9``.

  The goal of this audit is to review Databroker's ``DatabrokerDeals.sol`` smart contract and find and demonstrate potential security issues within the solidity contract. This report will also focus on current Solidity & security best practices.

### Disclaimer

  As of October 15, 2021, this smart contract has been audited to the best of my abilities keeping security patterns & best practices in mind. The findings of this audit are not guaranteed to be exhaustive, and there may still be issues within the contract itself. I take no responsibility for Databroker's contract security, and only act as a third-party auditer.

### Documentation & Whitepaper

  The contents of this audit are based on the whitepaper provided by Databroker.global within their [GitHub](https://github.com/databrokerglobal/Polygon-migration/issues/1). In order to provide a quality report of the security and efficiency of their smart contract, I have studied their whitepaper extensively to get a feel for how their system is supposed to function.

# 0x01. Severity Level Reference

  ![CRITICAL](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/critical.png)


  ![HIGH](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/high.png)

  Issues marked with a high severity tag should be fixed as soon as possible, because it is likely they will cause problems in production if left unresolved.
  
  ![MEDIUM](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/medium.png)

  Issues marked with a medium severity tag should be fixed soon, but it is not extremely urgent. These issues have the potential to cause problems in production.

  ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)

  Issues marked with a low severity tag can remain unfixed. These are unlikely to cause any problems in production, but resolving them could improve contract efficiency.
  

# 0x02. Security Issues

  - **Deals Auto-flagged as Accepted.** [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L169) ]
    
    ![MEDIUM](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/medium.png) 
    
    When calling ``createDeal(...)``, a new ``Deal`` object is created with the ``accepted`` bool set to true. This should automatically be set to false, since the buyer has not accepted the deal yet. Although there is a timelock implemented, it is bad practice to mark this deal as accepted before the buyer has called ``acceptDeal()``. If the timelock were to expire before the buyer had the opportunity to ``declineDeal()``, the seller would be able to request a payout without the proper flow being handled.

  - **Timestamp Dependence** [ [SWC-116](https://swcregistry.io/docs/SWC-116) ] [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L152) ]
    
    ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png) 
    
    Timestamps can be manipulated by the miner. It is generally safe to use ``block.timestamp``, since [Geth](https://github.com/ethereum/go-ethereum/blob/4e474c74dc2ac1d26b339c32064d0bac98775e77/consensus/ethash/consensus.go#L45) and [Parity](https://github.com/paritytech/parity-ethereum/blob/73db5dda8c0109bb6bc1392624875078f973be14/ethcore/src/verification/verification.rs#L296-L307) reject timestamps that are more than 15 seconds in the future. Since Databroker uses a 30 day timelock, this shouldn't be a problem, but should be kept in mind.
    

  - **Floating Pragma** [ [SWC-103](https://swcregistry.io/docs/SWC-103) ] [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L1) ]
  
    ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png) 
    
    Contracts should be deployed using the exact compiler version that they have been tested the most with in order to prevent being deployed with a compiler version that may have undiscovered bugs or vulneravilities. This is best practice when deploying contracts.
  
  - **Check Deal platformAddress** [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L131-L185) ]
  
    ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png) 
    
    When calling ``createDeal``it is best practice to ensure that ``platformAddress`` is not ``0x0`` or ``address.this()``. Adding a modifier that requires these two conditions would prevent token loss.

    ```
    modifier validDestination( address platformAddress ) {
        require(platformAddress != address(0x0));
        require(platformAddress != address(this) );
        _;
    }
    ```

# 0x03. Performance Issues

  - **Contract Size** [ [EIP-170](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-170.md) ]

    The raw contract code exceeds 24576 bytes, and may not deploy on mainnet correctly if not optimized. It may need to be optimized in order to deploy it.

  - **Computed Constant** [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L49-L50) ]

    It is typically good practice to write the value of predefined constants if you know them before compiling. Using functions such as ``keccak256()`` when you can compute the hash beforehand is excessive and will waste gas.
    ```
    bytes32 private constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    ```
    ```
    bytes32 private constant OWNER_ROLE = "b19546dff01e856fb3f010c267a7b1c60363cf8a4664e21cc89c26224620214e";
    bytes32 private constant ADMIN_ROLE = "a49807205ce4d355092ef5a8a18f56e8913cf4a201fbe287825b095693c21775";
    ```

  - **BuyerID and SellerID Can be The Same** [ [Code Reference](https://github.com/databrokerglobal/Polygon-migration/blob/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9/hardhat-mainnet/contracts/DatabrokerDeals.sol#L131-L185) ]

    Assuming you do not want users to be able to create deals with themselves, there should be a require statement after ``line 142`` that requires ``buyerId`` and ``sellerId`` to be different from eachother. This shouldn't cause problems with the contract itself, but would reduce gas consumption.