# Recurring Payments on Ethereum

![ethereum poc](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/ethereum-recurring-payments/preview.png?fw)

Recurring payments on the blockchain have been a topic of discussion for some time. First introduced in [EIP-1337](https://eips.ethereum.org/EIPS/eip-1337) in 2018, the proposal never really caught on. My approach to recurring payments on Ethereum takes a simpler approach than EIP-1337 did, which may help it have a larger impact on the community.

The full source for this PoC can be found within the [Jon-Becker/Ethereum-Recurring-Payments](https://github.com/Jon-Becker/ethereum-recurring-payments/tree/4aed03acb40f01628c7f57fcdd99c898b659a058) GitHub repository. The repository version I will reference in this write-up is `4aed03acb40f01628c7f57fcdd99c898b659a058`.

## Abstract

The recurring payment implementation I will explore throughout this paper is an application of the [ERC-20](https://eips.ethereum.org/EIPS/eip-20) Token Standard's `approve(...)` function. An unlimited allowance (`2^256-1`) is approved to the subscription contract address, which periodically allows the `_payee` to call a timelocked proxy of ERC-20's `transferFrom(...)` method.

## Detailed Analysis

### Consequences

#### Pros:

-   `_spender` must only call 2 transactions to create a subscription; `approve(...)` and `createSubscription(...)`.The burden is on the payee to call the `transferFrom(...)` proxy, meaning they must pay the gas fees to process future payments.
-   Subscriptions can be cancelled at any time, by either the `_spender` or the `_payee`.

#### Cons:

-   This approach requires an unlimited<sup>\*</sup> approval to the smart contract handling the recurring payments.
    -   \* Technically, this approval can be any amount as long as the `_spender` approves at least enough to pay for a minimum of 2 transactions. Although unlimited approvals of ERC-20 tokens are against Solidity best practice, this PoC allows for recurring payments on Ethereum in a generally secure manner, where the only potential losses lie in the smart contract's integrity.
-   We rely on `block.timestamp` for the timelock. This is generally not an issue, but should be noted.

### Specification

#### Methods

-   **getSubscription**

    Returns the Subscription of `_customer` to `_payee`.

    ```solidity
    function getSubscription(address _customer, address _payee) public view returns(Subscription memory)
    ```

-   **subscriptionTimeRemaining**

    Returns the time in seconds remaining until the subscription payment may be charged again.

    ```solidity
    function subscriptionTimeRemaining(address _customer, address _payee) public view returns(uint256)
    ```

-   **createSubscription**

    Creates a Subscription which allows `_payee` to charge the caller `_subscriptionCost` every `_subscriptionPeriod`, until the Subscription is cancelled.

    This may only be called by the customer, and will automatically charge them for the first billing period. Requires an approval to the subscription contract address of `_subscriptionCost * 2`.

    Emits a `Transfer`, `NewSubscription`, and `SubscriptionPaid` event.

    ```solidity
    function createSubscription(address _payee, uint256 _subscriptionCost, address _token, string memory _name, string memory _description, uint256 _subscriptionPeriod ) public virtual
    ```

-   **cancelSubscription**

    Cancels a subscription between `_customer` and `_payee` and disallows further `executePayment(...)` calls.

    This can be called by either party.

    ```solidity
    function cancelSubscription(address _customer, address _payee ) public virtual
    ```

-   **executePayment**

    Charges `_customer` for the subscription between `_customer` and the payee a total of `_subscriptionCost`, given that they have enough token balance and `_subscriptionPaid` is `false`.

    This must be called by the payee.

    ```solidity
    function executePayment(address _customer) public virtual
    ```

-   **\_subscriptionPaid**

    An internal function that returns `true` if the subscription between `_customer` and `_payee` has been paid for the current period, or `false` if otherwise.

    ```solidity
    function _subscriptionPaid(address _customer, address _payee) internal view returns(bool)
    ```

#### Events

-   **NewSubscription**

    MUST be called whenever a new subscription is created.

    ```solidity
    event NewSubscription(Customer, Payee, Allowance, TokenAddress, Name, Description, LastExecutionDate, SubscriptionPeriod);
    ```

-   **SubscriptionCancelled**

    MUST be called whenever a new subscription is cancelled.

    ```solidity
    event SubscriptionCancelled(Customer, Payee);
    ```

-   **SubscriptionPaid**

    MUST be called whenever a new subscription is paid.

    ```solidity
    event SubscriptionPaid(Customer, Payee, PaymentDate, PaymentAmount, NextPaymentDate);
    ```

## Conclusion

This method of allowing smart-contracts to recursively call `transferFrom(...)` based on an timelocked proxy function enables subscriptions on the blockchain, one of the most important aspects when it comes to running a service or business. The approach this PoC takes is also trustless, and can be revoked any time by the owner, allowing for a truly decentralized form of recurring payments & subscriptions on Ethereum.

---

### Resources & Citations

-   Fabian Vogelsteller, Vitalik Buterin, "EIP-20: Token Standard," Ethereum Improvement Proposals, no. 20, November 2015. [Online serial]. Available: https://eips.ethereum.org/EIPS/eip-20.
-   Kevin Owocki, Andrew Redden, Scott Burke, Kevin Seagraves, Luka Kacil, Štefan Šimec, Piotr Kosiński, ankit raj, John Griffin, Nathan Creswell, "EIP-1337: Subscriptions on the blockchain," Ethereum Improvement Proposals, no. 1337, August 2018. [Online serial]. Available: https://eips.ethereum.org/EIPS/eip-1337.
