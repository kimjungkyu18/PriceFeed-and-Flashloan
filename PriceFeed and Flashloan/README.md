# Pricefeed and Flashloan

This assessment was done using Solidity, Truffle, and tested on the Kovan testnet. 

## Setup

Register an Infura account at Infura.io and create a new project. Copy the Project ID value and the private key of your account to ```INFURA_API_KEY``` and ```DEPLOYMENT_ACCOUNT_KEY``` in the .env file. 

Install all dependencies

```
npm install
```

## Network deployment
Connect to the network you wish to deploy to. In this case, I tested all contracts with Kovan.
```
truffle console --network kovan
```
Compile and deploy contracts
```
migrate --reset
```
## Calling PriceFeed
Call the ```setAggregatorAddress()``` function with ```AGGREGATOR_ADDRESS``` set to the Chainlink aggregator address of the appropriate token conversion you want.
```
let p = await PriceFeed.deployed()
await p.setAggregatorAddress(AGGREGATOR_ADDRESS)
```
Then call get_prices() to receive live price information about the token pair
```
await p.get_prices()
```
## Calling Flashloan
Since there is no profitable logic in the flashloan contract, the contract itself must have funds of the same asset deposited already. In this case, DAI must be deposited. 
```
let f = await Flashloan.deployed()
await f.flashloan()
```
You can also interact with the PriceFeed contract and call its ```get_prices()``` function.
However PriceFeed must already be deployed and must already have its Chainlink aggregator address set. Furthermore you must set ```PRICE_FEED_ADDRESS``` to the address of the PriceFeed contract.
```
await f.setPriceFeedAddress(PRICE_FEED_ADDRESS)
await f.get_prices()
```
