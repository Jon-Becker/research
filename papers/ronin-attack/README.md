# Ronin Network Drained for $625M

  ##### March 29, 2022&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev) 
  
  ![Preview](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/ronin-attack/preview.png?fw)

  Axie Infinity's Ronin Network fell victim to a $625M exploit on 03/23/2022. This paper takes a look at how this attack happened, and how it can be prevented in the future.

  In this write-up, I'll take a look at the <a href="https://etherscan.io/address/0x098b716b8aaf21512996dc57eb0615e2383e2f96">attacker</a>'s account used in this attack, and try to break down how this attack happened.

  # 0x01. Attack Overview

  On 03/29/2022, the Ronin Network <a href="https://roninblockchain.substack.com/p/community-alert-ronin-validators?s=w">announced</a> that it fell victim to an attack which cost a total of 173,600 Ethereum and 25.5M USDC.

  The attacker drained the wallets in two transactions (<a href="https://etherscan.io/tx/0xc28fad5e8d5e0ce6a2eaf67b6687be5d58113e16be590824d6cfa1a94467d0b7">1</a>, <a href="https://etherscan.io/tx/0xed2c72ef1a552ddaec6dd1f5cddf0b59a8f37f82bdda5257d9c7c37db7bb9b08">2</a>). Since both transactions use the same `withdrawERC20For(...)`<sub>[<a href="https://etherscan.io/address/0x8407dc57739bcda7aa53ca6f12f82f9d51c2f21e#code">Source</a>]</sub> function, i'm only going to look at <a href="https://etherscan.io/tx/0xc28fad5e8d5e0ce6a2eaf67b6687be5d58113e16be590824d6cfa1a94467d0b7">0xc28fad5e8d5e0c</a>.

  The attacker's transaction called `withdrawERC20For(...)`, with arguments:

  | Parameter Name      | Type      | Data                                         |
  |---------------------|-----------|----------------------------------------------|
  | `_withdrawalId`     | `uint256` | `2000000`                                    |
  | `_user`             | `address` | `0x098B716B8Aaf21512996dC57EB0615e2383E2f96` |
  | `_token`            | `address` | `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` |
  | `_amount`           | `uint256` | `173600000000000000000000`                   |
  | `_signatures`       | `bytes`   | `0x01175db2b62ed80a0973b4ea3581b...8ecb991c` |
  
  The `_signatures` that this transaction contains leads me to believe that this attack was a type of <a href="https://www.trendmicro.com/vinfo/us/security/news/cyber-attacks/spear-phishing-101-what-is-spear-phishing">spearphishing</a> attack, in which individual validators of the Ronin network were targetted. Since there are 9 validators for this network, the attacker needed to obtain 5 of them to proceed with the attack.

  The first signature was reportedly obtained through a backdoor within the Ronin gas-free RPC node, according to the [official statement](https://roninblockchain.substack.com/p/community-alert-ronin-validators?s=w). Through an exploit in Sky Mavis' system, the attacker also obtained four *additional* signatures because the Ronin Network did not revoke Sky Mavis' access to sign transactions on behalf of Axie DAO.

  ![EVM Trace](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/ronin-attack/1.png)

  From this <a href="https://ethtx.info/mainnet/0xc28fad5e8d5e0ce6a2eaf67b6687be5d58113e16be590824d6cfa1a94467d0b7/">transaction trace</a>, we can see that the attacker did in fact provide 5 valid signatures, obtained through these backdoors.

  Since ` MainchainValidator.checkThreshold() ` passed, this transaction was executed and 173,600 ETH was transferred to the attacker.

  # 0x02. Prevention

  This attack outlines a complete security failure on behalf of the Ronin Network. With $625M at stake, a security team should be checking and double checking for possible attack vectors at all times. Forgetting to remove access to signatures is inexcusable.

  This attack was enabled by the single fact that the Axie DAO did not remove Sky Mavis' access to sign on their behalf. This essentially voided all decentralization of the DAO, since one backdoor on the Sky Mavis system allowed this to happen. Instead of being a multi-signature transaction, it really only required one.

  When dealing with multi-signature transactions, it's important to keep each private key distributed and secure. Ideally, keys should be stored offline, and should never be stored on devices connected to the internet. They should also never be granted to anyone else, which would kill the point of a multi-sig transaction.

  # 0x03. Resources & Citations

  - Article image [https://roninwallet.io/](https://roninwallet.io/wp-content/uploads/2021/06/roninpreview-scaled.jpeg)
  - Ronin Announcement [https://roninblockchain.substack.com/](https://roninblockchain.substack.com/p/community-alert-ronin-validators?s=w)