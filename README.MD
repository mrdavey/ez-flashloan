# EZ-Flashloan
A barebones solidity template for Aave's flashloans

## Prerequisite
 - Basic knowledge of Solidity
 - Basic knowledge of Truffle
 - Basic knowledge of Javascript
 - An [Infura](https://infura.io/) account and API key

## Flashing
1. In `Flashloan.sol`, code your logic into the `executeOperation()` function
2. When ready, call `flashloan()` on your contract
3. Remember that your contract needs to have enough funds of whatever asset you are borrowing to payback the flashloan fee.
4. If not deploying on mainnet, then change the `addressProvider` in `./aave/FlashLoanReceiverBase.sol` to the relevant address

## Set up
1. Clone this repo and:
    ```
    npm install
    ```
2. (Install and) Run [Ganache](https://www.trufflesuite.com/ganache), preferably the CLI version
3. In `truffle-config.js`, ensure the details for the development network match up with your running Ganache instance
4. To minimise set up steps with Aave's lending pools, use Ganache's fork feature. This will 'fork' mainnet into your Ganache instance.
    Open terminal and run:
    ```
    ganache-cli --fork https://mainnet.infura.io/v3/YOUR_INFURA_KEY
    ``` 
5. In a new terminal window in your repo directory, run:
    ```
    truffle console
    ```
6. Migrate your Flashloan contract to your instance of Ganache with:
    ```
    migrate --reset
    ```
7. Your contract is now deployed on your local Ganache, which is mirroring mainnet. Call your contract's flashloan function within the _truffle console_ with:
    ```
    let f = await Flashloan.deployed()
    await f.flashloan()
    ```
    Be patient as your ganache instance works its magic.

8. If your implementation is correct, then the transaction will succeed. If it fails/reverts, a reason will be given.
    - if you didn't make any changes to this template and just deployed it, then the call to `f.flashloan()` will fail as the contract is not funded with any DAI, so cannot make the flashloan repayment (which includes the amount borrowed + a fee). Solve this by using an address already funded with DAI, or send yourself some DAI to begin with.

## Making it mainnet ready
My recommendations would be:
 - Add a modifier so only you can call your flashloan contract
 - If doing arbitrage and taking profits, hardcode your profit taking address
 - Implement a function to recover any ETH funds that are accidentally sent to this address

## Deploying to mainnet
1. Rename `env` file to `.env` and include your infura key and deployment wallet private key (don't commit this file to Git!)
2. In `truffle-config.js`, uncomment the `mainnet` section under networks.
3. Deploy to mainnet with `truffle migrate --network mainnet`

## Verify, don't trust
 - [Aave's official documentation](https://developers.aave.com/#implementing-a-flashloanreceiver-contract): This template is a bit different to their example as everything happens within this one contract, including the calling of `flashloan()`

 - [Aave's contract addresses](https://developers.aave.com/#the-lendingpooladdressesprovider)

 - All imported contracts will have a link to the 'official' contract at the top. 
