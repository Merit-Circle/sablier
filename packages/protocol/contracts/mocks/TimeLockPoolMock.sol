pragma solidity =0.5.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";


contract TimeLockPoolMock is ERC20 {
    using SafeERC20 for IERC20;

    IERC20 public depositToken;

    mapping(address => Deposit[]) public depositsOf;

    struct Deposit {
        uint256 amount;
        uint64 start;
        uint64 end;
    }

    constructor(
        address _depositToken
    ) public {
        require(_depositToken != address(0), "BasePool.constructor: Deposit token must be set");
        depositToken = IERC20(_depositToken);
    }

    function deposit(uint256 _amount, uint256 _duration, address _receiver) external {
        require(_amount > 0, "TimeLockPool.deposit: cannot deposit 0");

        depositToken.safeTransferFrom(msg.sender, address(this), _amount);

        depositsOf[_receiver].push(Deposit({
            amount: _amount,
            start: uint64(block.timestamp),
            end: uint64(block.timestamp) + uint64(_duration)
        }));

        uint256 mintAmount = _amount;

        _mint(_receiver, mintAmount);
    }
}
