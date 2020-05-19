# EZ-Flashloan
## This repo has been deprecated, in favor of the official [Flash Loans Truffle Box](https://github.com/aave/flashloan-box)

---

A barebones solidity (^0.5.15) template for Aave's flashloans

### Join our #development channel on the [Aave Discord](https://discord.gg/fVaDMqT)

## Prerequisite
 - Basic knowledge of Solidity
 - Basic knowledge of Truffle
 - Basic knowledge of Javascript
 - An [Infura](https://infura.io/) account and API key

## Flashing
1. In `Flashloan.sol`, code your logic into the `executeOperation()` function
2. When ready, call `flashloan()` on your contract
3. Important: your contract **must** have enough funds of whatever asset you are borrowing to payback the flashloan fee.
4. If not deploying on mainnet, then change the `addressProvider` in `./aave/FlashLoanReceiverBase.sol` to the relevant address

## Set up for 'simple' flash lending
If you do not need to work across protocols, such as simple flash loan testing, then the following instructions apply.

1. Clone this repo and in the cloned repo directory, install the necessary dependencies :
    ```
    npm install
    ```
2. In `truffle-config.js`, add the details of the [network you wish to use](https://www.trufflesuite.com/docs/truffle/reference/configuration), e.g. Ropsten. 
 - Important: make sure you are using an ethereum account that has enough ETH and token assets to pay back the loan. This is your `deployment account`
 - Rename `env` file to `.env` and include your infura key and `deployment account`'s private key (don't commit this file to Git!)
3. In `Flashloan.sol`, line 31, change the asset address to the [relevant asset address](https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances) for the network you chose.
4. In `./aave/FlashLoanReceiverBase.sol`, change the `addressProvider` to the [relevant LendingPoolAddressesProvider](https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances) for the network you chose.
5. In a terminal window in your repo directory, replace `NAME_OF_YOUR_NETWORK` with the network name from step 2 and run:
    ```
    truffle console --network NAME_OF_YOUR_NETWORK
    ```
6. You are now connected to the network you chose. In the same terminal window:
    ```
    migrate --reset
    ```
7. Your contract is now deployed on the network you chose. Call your contract's flashloan function within the _truffle console_ with:
    ```
    let f = await Flashloan.deployed()
    await f.flashloan()
    ```
    Be patient as your transaction gets processed and mined.

8. If your implementation is correct, then the transaction will succeed. If it fails/reverts, a reason will be given.
    - if you didn't make any changes to this template and just deployed it, then the call to `f.flashloan()` will fail as the **contract** is not funded with any DAI, so cannot make the flashloan repayment (which includes the amount borrowed + a fee). Solve this by getting DAI (or the relevant asset) and transferring it to your **contract**.

## Set up for cross protocol flash lending
If you are working across protocols, such as using the flash loaned amount on another #DeFi protocol, sometimes it is easier to fork mainnet and use each protocol's production contracts and production ERC20 tokens.

1. Clone this repo and in the cloned repo directory, install the necessary dependencies :
    ```
    npm install
    ```
2. (Install and) Run [Ganache](https://www.trufflesuite.com/ganache), preferably the [CLI version](https://github.com/trufflesuite/ganache-cli)
3. In `truffle-config.js`, ensure the details for the development network match up with your running Ganache instance
4. To minimise set up steps with Aave's lending pools, use Ganache's fork feature. This will 'fork' mainnet into your Ganache instance.
    Open terminal, replace `YOUR_INFURA_KEY` in the following and run:
    ```
    ganache-cli --fork https://mainnet.infura.io/v3/YOUR_INFURA_KEY -i 1
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
    - if you didn't make any changes to this template and just deployed it, then the call to `f.flashloan()` will fail as the **contract** is not funded with any DAI, so cannot make the flashloan repayment (which includes the amount borrowed + a fee). Solve this by getting DAI (or the relevant asset) and transferring it to your **contract**.


## Known issues
 - If you are using Ganache to fork a network, then you may have issues with the blockchain archive state every 30 minutes. This is due to your node provider (i.e. Infura) only allowing free users access to 30 minutes of archive state. To solve this, upgrade to a paid plan, or simply restart your ganache instance and redploy your contracts.


## Debugging transactions
### Truffle Debugger
1. Get the transaction hash of a recent transaction from the Ganache-cli terminal window. E.g. `0xfda3855a8bc93e66aaac14c50baccfd83e9665f13a7b4cc57b4bc0f010831720` (the transaction hash must be valid for the network you are currently using)
2. In the `truffle console` window, replace `INSERT_THE_TRANSACTION_HASH` with your transaction hash:
    ```
    debug INSERT_THE_TRANSACTION_HASH
    ```
3. When the debugger has started, the available commands are shown. The important commands to remember are `n` for next step and `v` to print the current variables and values.
    - In the terminal window, press the `n` key to navigate to the next step that the compiler executed.
    - If you are within a function and want to check the values used, press `v`.
    - To quit the debugger, press `q` or `CTRL+C`.

    #### Unable to debug executeOperation()
    The Truffle debugger does not work too well with proxy / complex calls. You may find that the Truffle debugger returns an error such as:
    ```
    TypeError: Cannot read property 'version' of undefined
    at ...
    ```
    - In this case you can try calling your `executeOperation()` function directly, instead of having Aave's `LendingPool` contract invoke the function. This will allow you to debug the function directly, however you will need to supply the relevant parameters (e.g. `_amount`, `_fee`, `_reserve`, etc).
    - Alternatively, see the below 'Testnet Debugging' section

### Testnet Debugging
If your contracts are deployed to a testnet (or even mainnet), you can use a service such as [Tenderly](https://tenderly.co/) to debug your transactions. You will get access to all the debugging features of Truffle Debugger + many more.

## Making it mainnet ready
Before deploying to mainnet:
 - If doing arbitrage and taking profits, hardcode your profit taking address or set it as a variable in the contract

## Deploying to mainnet
1. Rename `env` file to `.env` and include your infura key and deployment wallet private key (don't commit this file to Git!)
2. In `truffle-config.js`, uncomment the `mainnet` section under networks.
3. Deploy to mainnet with `truffle migrate --network mainnet`

## More information
 - [Official documentation](https://docs.aave.com/developers/tutorials/performing-a-flash-loan): For more details on performing a flash loan.
 - [Contract addresses](https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances): For a list of all the asset and contract address on mainnet and the testnets.
