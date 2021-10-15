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

  ![CRITICAL](https://docs.google.com/drawings/u/1/d/s2A5dPyYYIXwJ5wiEwp8ZnA/image?w=90&h=25&rev=1&drawingRevisionAccessToken=7H_rczXZngANng&ac=1&parent=1saSVpT2Ixd58q-DZlTtzfkNizuTTE4yVoGuWz_AatZM)

  Issues marked with a critical severity tag must be fixed as soon as possible. These issues may break the contract altogether if not resolved.

  ![HIGH](https://docs.google.com/drawings/u/1/d/srm9H82jO6eLz-fpDkkQ0cQ/image?w=89&h=25&rev=1&drawingRevisionAccessToken=yfeRMAXlt_upVA&ac=1&parent=1saSVpT2Ixd58q-DZlTtzfkNizuTTE4yVoGuWz_AatZM)

  Issues marked with a high severity tag should be fixed as soon as possible, because it is likely they will cause problems in production if left unresolved.
  
  ![MEDIUM](https://docs.google.com/drawings/u/1/d/sEmSjs6cE220FaTcacbrXDw/image?w=90&h=25&rev=1&drawingRevisionAccessToken=RkVJ-7o2vH0yWw&ac=1&parent=1saSVpT2Ixd58q-DZlTtzfkNizuTTE4yVoGuWz_AatZM)

  Issues marked with a medium severity tag should be fixed soon, but it is not extremely urgent. These issues have the potential to cause problems in production.

  ![LOW](https://docs.google.com/drawings/u/1/d/s0QKztd2tlTd_k8qM4aEjcQ/image?w=90&h=25&rev=1&drawingRevisionAccessToken=f3JNpSAGakWFtw&ac=1&parent=1saSVpT2Ixd58q-DZlTtzfkNizuTTE4yVoGuWz_AatZM)

  Issues marked with a low severity tag can remain unfixed but should be fixed sometime in the future. These are unlikely to cause any problems in production, but resolving them could improve contract efficiency.
  

# 0x02. Security Issues

  * Issue One