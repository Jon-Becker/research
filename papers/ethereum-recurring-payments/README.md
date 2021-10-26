# Recurring Payments on Ethereum

  ##### October 25, 2021&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  
  ![ethereum poc](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/ethereum-recurring-payments/preview.png?fw)

  Recurring payments on the blockchain have been a topic of discussion for some time. First introduced in [EIP-1337](https://eips.ethereum.org/EIPS/eip-1337) in 2018, the proposal never really caught on. My approach to recurring payments on Ethereum takes a simpler approach than EIP-1337 did, which may help it have a larger impact on the community.

  The full source for this PoC can be found within the  [Jon-Becker/Ethereum-Recurring-Payments](https://github.com/Jon-Becker/ethereum-recurring-payments/tree/e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9) GitHub repository. The repository version I will reference in this write-up is ``e3cfa08c0298ba96e7d15c08f50b1f2982cfa0e9``.

# 0x01. Abstract
  The recurring payment implementation I will explore throughout this paper is an application of the [ERC-20](https://eips.ethereum.org/EIPS/eip-20) Token Standard's ``approve(...)`` function. An unlimited allowance (``2^256-1``) is approved to the subscription contract address, which periodically allows the ``_payee`` to call a timelocked proxy of ERC-20's ``transferFrom(...)`` method.
  

# 0x02. Detailed Analysis

### Consequences

#### Pros:

  - ``_spender`` must only call 2 transactions to create a subscription; ``approve(...)`` and ``createSubscription(...)``.The burden is on the payee to call the ``transferFrom(...)`` proxy, meaning they must pay the gas fees to process future payments.
  - Subscriptions can be cancelled at any time, by either the ``_spender`` or the ``_payee``.

#### Cons:

- This approach requires an unlimited<sup>*</sup> approval to the smart contract handling the recurring payments.
  - \* Technically, this approval can be any amount as long as the ``_spender`` approves at least enough to pay for a minimum of 2 transactions. Although unlimited approvals of ERC-20 tokens are against Solidity best practice, this PoC allows for recurring payments on Ethereum in a generally secure manner, where the only potential losses lie in the smart contract's integrity.
- We rely on ``block.timestamp`` for the timelock. This is generally not an issue, but should be noted.

### Specification
```

```

# 0x04. Conclusion

  This method of allowing smart-contracts to recursively call ``transferFrom(...)`` based on an timelocked proxy function enables subscriptions on the blockchain, one of the most important aspects when it comes to running a service or business. The approach this PoC takes is also trustless, and can be revoked any time by the owner, allowing for a truly decentralized form of recurring payments & subscriptions on Ethereum.

----

### 0x05. Resources & Citations

  - Fabian Vogelsteller, Vitalik Buterin, "EIP-20: Token Standard," Ethereum Improvement Proposals, no. 20, November 2015. [Online serial]. Available: https://eips.ethereum.org/EIPS/eip-20.
  - Kevin Owocki, Andrew Redden, Scott Burke, Kevin Seagraves, Luka Kacil, Štefan Šimec, Piotr Kosiński, ankit raj, John Griffin, Nathan Creswell, "EIP-1337: Subscriptions on the blockchain," Ethereum Improvement Proposals, no. 1337, August 2018. [Online serial]. Available: https://eips.ethereum.org/EIPS/eip-1337.