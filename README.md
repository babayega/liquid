# Liquid - Liquidity Deployer

Liquid is a protocol that accets stablecoins and deploys it into different DeFi protocols as liquidity. The funds are liquid, hence can be withdrawn at any point as there is no locking.

The protocol has a Treasury where all the idle assets are stored. Adapters are contracts which are able to communicate with the
external DeFi protocols. Treasury is responsible for delegating the funds to the adapters, which then deploy it to various DeFi
protocols.

For eg. there is an AAVE adapter already in the adapters folder which implements the IAdapter interface. Any new adapter needs to implement this interface in order to be registered by the Treasury.


##### Key features of the Liquid Protocol include:
  - Deploy liquidity to various DeFi protocols
Users can deploy their liquidity into many different DeFi protocols using the Treasury contract. All the positions are maintained in one single contract.
  - Remove liquidity without any hassle
Users can remove their liquidity with just one function call, and receive the funds back in the contract from where they can withdraw or deploy to any other protocol.
  - Add more DeFi protocols through the Adapter interface
The adapters are made in such a way that any user can just create a new adapter by implementing the IAdapter interface and register it into the Treasury. This enables the user to expand the functionality of this protocol and manage liquidity accordingly.


##### Block Diagram
```
                   |
                   | Accept Stablecoins
                   |
                   v
          +-------------------+
          |                   |
          |     Treasury      |
          |     Contract      |
          |                   |
          +--------+----------+
                   |
                   | Deposit Stablecoins (USDC, DAI)
                   |
          +-------------------+
          |                   |
          |                   |
          |                   |
          v                   v
 +--------+----------+  +--------+----------+
 |                   |  |                   |
 |      AAVE         |  |     UNISWAP       |
 |                   |  |                   |
 +--------+----------+  +--------+----------+
```


## Local development and testing

### Get started
Clone this repository and install NodeJS dependencies:
```
git clone git@github.com:babayega/liquid.git
npm i
```

### Local development
Start a local node in the terminal
```
npx hardhat node --no-deploy --fork https://rpc.ankr.com/polygon_mumbai
```

Deploy the contracts
```
npx hardhat deploy --network localhost
```
