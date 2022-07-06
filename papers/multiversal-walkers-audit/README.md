# Multiversal Walkers Audit

  ##### July 8, 2021&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  
  ![mv](https://pbs.twimg.com/media/FWCk9NUXkAE6fuW?format=png&name=4096x4096)

  The Multiversal Walkers team asked me to review and audit their contracts in preparation for their mint. I reviewed their contracts and published this audit with my findings.

  This audit was performed on the [CuzzoLabs/WalkersAudit](https://github.com/CuzzoLabs/WalkersAudit/tree/1cea55314174a2d0e91b2a76564150944ee22694) GitHub repository. The repository version used for this audit was commit ``1cea55314174a2d0e91b2a76564150944ee22694``.

### Scope

  The scope of this audit is limited to the following files:
  - [Walkers.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/Walkers.sol)
  - [FERC1155Distributor.sol](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/src/FERC1155Distributor.sol)

### Documentation

  The contents of this audit are based on the scope provided by the Multiversal Walkers team within their [GitHub](https://github.com/CuzzoLabs/WalkersAudit/blob/1cea55314174a2d0e91b2a76564150944ee22694/README.md#L3). In order to provide a quality report of the security and efficiency of their smart contract, I have studied their whitepaper extensively to get a feel for how their system is supposed to function.

# 0x01. Severity Level Reference

  | Severity Level                                                                                     | Description                                                                                                                                                               |
  | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | ![CRITICAL](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/critical.png) | Findings marked with a critical severity tag must be fixed as soon as possible. These issues may break the contract altogether if not resolved.                           |
  | ![HIGH](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/high.png)         | Findings marked with a high severity tag should be fixed as soon as possible, because it is likely they will cause problems in production if left unresolved.             |
  | ![MEDIUM](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/medium.png)     | Findings marked with a medium severity tag should be fixed soon, but it is not extremely urgent. These issues have the potential to cause problems in production.         |
  | ![LOW](https://raw.githubusercontent.com/Jon-Becker/research/main/assets/images/low.png)           | Findings marked with a low severity tag can remain unfixed. These are unlikely to cause any problems in production, but resolving them could improve contract efficiency. |

# 0x02. Table of Contents

  | Severity Level | Finding Title | Code Reference |
  | :------------: | :------------ | :------------- |
  | CRITICAL      | CRITICAL      | CRITICAL      |
  

# 0x03. Security Issues

# 0x04. Best Practice Issues

# 0x05. Conclusion

  A total of 12 issues & recommendations were found within ``DatabrokerDeals.sol``, two of which were of critical severity and one of which was of medium severity. The remaining nine issues were either of low severity or were recommendations in order to adhere to solidity best practice.

  _Note that as of the date of publishing, the contents of this document reflect my current understanding of known security patterns regarding smart contract security. The findings of this audit should not be considered to be exhaustive, and there may still be issues within the contract itself. This audit is not a guarantee of security. I take no responsibility for future contract security, and only act as a third-party auditor._

----

### 0x06. Resources & Citations

  - [Consensys Best Practices](https://consensys.github.io/smart-contract-best-practices/)
  - [SWC Registry](https://swcregistry.io)
  - [Ethereum Improvement Proposals](https://eips.ethereum.org)
  - [OpenZeppelin Documentation](https://docs.openzeppelin.com/contracts/4.x/)