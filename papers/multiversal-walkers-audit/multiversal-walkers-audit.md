# Multiversal Walkers Audit

##### July 8, 2022&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)

![mv](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/multiversal-walkers-audit/preview.png?fw)

The Multiversal Walkers team asked me to audit their contracts in preparation for their mint. I reviewed their contracts and published this audit with my findings.

This audit was performed on the [CuzzoLabs/WalkersAudit](https://github.com/CuzzoLabs/WalkersAudit/tree/1cea55314174a2d0e91b2a76564150944ee22694) GitHub repository. The repository version used for this audit was commit `1cea55314174a2d0e91b2a76564150944ee22694`.

### Scope

The scope of this audit is limited to the following files:

-   [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol)
-   [FERC1155Distributor.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol)

### Documentation

The contents of this audit are based on the scope provided by the Multiversal Walkers team within their [GitHub](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/README.md#L3). In order to provide a quality report of the security and efficiency of their smart contract, I have studied their whitepaper extensively to get a feel for how their system is supposed to function.

## Severity Level Reference

| Severity Level                                                                                     | Description                                                                                                                                                               |
| -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![CRITICAL](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/critical.png) | Findings marked with a critical severity tag must be fixed as soon as possible. These issues may break the contract altogether if not resolved.                           |
| ![HIGH](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/high.png)         | Findings marked with a high severity tag should be fixed as soon as possible, because it is likely they will cause problems in production if left unresolved.             |
| ![MEDIUM](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/medium.png)     | Findings marked with a medium severity tag should be fixed soon, but it is not extremely urgent. These issues have the potential to cause problems in production.         |
| ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)           | Findings marked with a low severity tag can remain unfixed. These are unlikely to cause any problems in production, but resolving them could improve contract efficiency. |

## Table of Contents

| Severity                                                                                   | Finding Title          | Code Reference                                                                                                                                                                                                                                                                                                  |
| ------------------------------------------------------------------------------------------ | :--------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![HIGH](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/high.png) | Logic Inconsistency    | [FERC1155Distributor.sol L59](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol#L59) & [FERC1155Distributor.sol L83](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol#L83) |
| ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)   | Timestamp Dependence   | [FERC1155Distributor.sol L100](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol#L100)                                                                                                                                                        |
| ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)   | Documentation Issues   | [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol) & [FERC1155Distributor.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol)                                         |
| ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)   | Lack of Event Emission | [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol) & [FERC1155Distributor.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol)                                         |
| ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)   | Floating Pragma        | [Walkers.sol L2](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol#L2) & [FERC1155Distributor.sol L2](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol#L2)                             |

## Security Findings

-   ### <img src="https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/high.png" height="24px"> Logic Inconsistency

Within `Walkers.sol`, the minting functions `publicMint()` and `multilistMint()` do not have a check for whether or not the caller is an EOA. Both contracts and EOAs are allowed to mint Walkers. However, within `FERC1155Distributor.sol`, there is a check for whether or not the caller is an EOA.

A user could potentially mint Walkers using a contract (such as gnosis), and then be unable to claim their FERC1155 tokens using the contract. Either `publicMint()` or `multilistMint()` should be updated to block non EOA accounts from minting Walkers, or this check should be removed within `FERC1155Distributor.sol`.

-   ### <img src="https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png" height="24px"> Timestamp Dependence

Timestamps can be manipulated by the miner. It is generally safe to use `block.timestamp`, since [Geth](https://github.com/ethereum/go-ethereum/blob/4e474c74dc2ac1d26b339c32064d0bac98775e77/consensus/ethash/consensus.go#L45) and [Parity](https://github.com/paritytech/parity-ethereum/blob/73db5dda8c0109bb6bc1392624875078f973be14/ethcore/src/verification/verification.rs#L296-L307) reject timestamps that are more than 15 seconds in the future.

Since Multiversal Walkers uses a 7 day timelock for claiming free FERC tokens, this shouldn't be a problem. However, if a miner does change the timestamp to a future date which would affect the timelock, a user could potentially claim a token before the timelock is met.

_As of commit [a26b9988ea7c1a2b2c3f28260f2c1d886558f310](https://github.com/CuzzoLabs/WalkersAudit/tree/a26b9988ea7c1a2b2c3f28260f2c1d886558f310), this issue has been addressed. Multiversal Walkers has opted to block all EOA accounts across all contracts._

## Best-practice Findings

-   ### <img src="https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png" height="24px"> Documentation Issues

    Functions should be documented according to the [NatSpec Standard](https://docs.soliditylang.org/en/v0.8.10/natspec-format.html#tags). In both `Walkers.sol` and `FERC1155Distributor.sol`, many functions are missing complete NatSpec documentation, or documentation altogether.

    All functions should include the `@return` and `@param` tags, where appropriate according to NatSpec. For example, the following function is missing the `@param` tag in [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol#L98-L115):

    ```js
      /// @notice Function used to mint Walkers during the public mint.
      /// @dev No explicit check of `quantity` is required as signatures are created ahead of time.
      function publicMint(uint256 quantity, bytes calldata signature) external payable {
        ...
      }
    ```

    should become

    ```js
      /// @notice Function used to mint Walkers during the public mint.
      /// @dev No explicit check of `quantity` is required as signatures are created ahead of time.
      /// @param quantity The number of Walkers to mint.
      /// @param signature The signature, signed by _signer, used to validate the mint.
      function publicMint(uint256 quantity, bytes calldata signature) external payable {
        ...
      }
    ```

    \_As of commit [a26b9988ea7c1a2b2c3f28260f2c1d886558f310](https://github.com/CuzzoLabs/WalkersAudit/tree/a26b9988ea7c1a2b2c3f28260f2c1d886558f310), this issue has been addressed.

-   ### <img src="https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png" height="24px"> Lack of Event Emission

    The following functions do not emit events despite taking important action within the contract:

    -   `setPublicTokens()` in [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol#L157-L163)
    -   `setSaleState()` in [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol#L165-L172) & [FERC1155Distributor.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol#L149-L152)
    -   `setSigner()` in [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol#L174-L177) & [FERC1155Distributor.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol#L142-L145)
    -   `setBaseTokenURI()` in [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol#L179-L182)

    Consider adding event emissions after these sensitive contract events take place. This is best-practice, and allows for off-chain analysis and tracking of the contract’s activity.

    _As of commit [a26b9988ea7c1a2b2c3f28260f2c1d886558f310](https://github.com/CuzzoLabs/WalkersAudit/tree/a26b9988ea7c1a2b2c3f28260f2c1d886558f310), this issue has been addressed. Owner interactions that modify the contract state are now emitted as events._

-   ### <img src="https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png" height="24px"> Floating Pragma

    Contracts should be deployed using the exact compiler version that they have been tested the most with in order to prevent being deployed with a compiler version that may have undiscovered bugs or vulnerabilities. This is [best practice](https://swcregistry.io/docs/SWC-103) when deploying contracts.

    In this case, change `^0.8.10` to `0.8.10` in both `Walkers.sol` and `FERC1155Distributor.sol`.

    \_As of commit [a26b9988ea7c1a2b2c3f28260f2c1d886558f310](https://github.com/CuzzoLabs/WalkersAudit/tree/a26b9988ea7c1a2b2c3f28260f2c1d886558f310), this issue has been addressed.

## Conclusion

A total of five issues & recommendations were found within the contracts in scope, one of which was of high severity. The remaining four issues were either of low severity or were recommendations in order to adhere to solidity best practice.

_Note that as of the date of publishing, the contents of this document reflect my current understanding of known security patterns regarding smart contract security. The findings of this audit should not be considered to be exhaustive, and there may still be issues within the contract itself. This audit is not a guarantee of security. I take no responsibility for future contract security, and only act as a third-party auditor._

---

### Resources & Citations

-   [Consensys Best Practices](https://consensys.github.io/smart-contract-best-practices/)
-   [SWC Registry](https://swcregistry.io)
-   [Ethereum Improvement Proposals](https://eips.ethereum.org)
-   [OpenZeppelin Documentation](https://docs.openzeppelin.com/contracts/4.x/)
-   [NatSpec Documentation](https://docs.soliditylang.org/en/v0.8.10/natspec-format.html#tags)
