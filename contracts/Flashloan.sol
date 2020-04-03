pragma solidity ^0.5.15;

import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";

contract Flashloan is FlashLoanReceiverBase {

    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        //
        // do your thing here
        //

        // Time to transfer the funds back
        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    function flashloan() public onlyOwner {
        bytes memory data = "";
        uint amount = 1 ether;
        address asset = address(0x6B175474E89094C44Da98b954EedeAC495271d0F); // mainnet DAI, for more asset addresses, see: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), asset, amount, data);
    }
}
