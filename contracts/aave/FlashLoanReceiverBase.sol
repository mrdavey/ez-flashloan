// Original: https://github.com/aave/aave-protocol/blob/master/contracts/flashloan/base/FlashLoanReceiverBase.sol

pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/SafeERC20.sol";
import "./IFlashLoanReceiver.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./EthAddressLib.sol";
import "../utils/Withdrawable.sol";

contract FlashLoanReceiverBase is IFlashLoanReceiver, Withdrawable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    ILendingPoolAddressesProvider public addressesProvider;

    constructor(address _addressProvider) public {
        addressesProvider = ILendingPoolAddressesProvider(_addressProvider);
    }

    function() external payable { }

    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {
        address payable core = addressesProvider.getLendingPoolCore();
        transferInternal(core, _reserve, _amount);
    }

    function transferInternal(address payable _destination, address _reserve, uint256 _amount) internal {
        if(_reserve == EthAddressLib.ethAddress()) {
            //solium-disable-next-line
            _destination.call.value(_amount)("");
            return;
        }
        IERC20(_reserve).transfer(_destination, _amount);
    }

    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {
        if(_reserve == EthAddressLib.ethAddress()) {
            return _target.balance;
        }
        return IERC20(_reserve).balanceOf(_target);
    }
}
