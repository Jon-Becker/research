
# Decentralized Insurance on Ethereum

  ##### February 15, 2022&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;By [Jonathan Becker](https://jbecker.dev)
  
  ![Insurance on EVM](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/.decentralized-insurance/preview.png?fw)

  One of the fundamental parts of any financial systems is the concept of insurance — the ability to purchase protection on your assets in case of eventual loss or damage. This research paper explores the possibility of a completely decentralized and automated insurance protocol on the Ethereum Virtual Machine.

  In order to make cryptocurrencies and Ethereum based chains mainstream, there needs to be some kind of risk management platform where users can protect themselves in case of loss. The cryptospace is a major target for hackers, so having insurance on your holdings is essential.

  # 0x01. Wireframing

  ![Wireframe](https://raw.githubusercontent.com/Jon-Becker/research/main/papers/.decentralized-insurance/1.png?fw)

  The basic wireframe for the insurance protocol involves two main parties; insurance buyers and sellers.

  - Insurance Buyers
    - May deposit an amount of wETH into the protocol in exchange for an amount of insurance tokens, ```$iVULN```. These tokens have an expiration date, 1 month for example.
  - Insurance Sellers
    - May deposit an amount of wETH into the protocol in exchange for an amount of insurer tokens, ```$dINS```. Token holders may collect yield based on pool profits from insurance buyers.

  In the case that an insurance buyer makes a claim on their ``$iVULN``:
  - An amount of insurance funds locked until claim resolved