pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EthStaking is Ownable {
    IERC20 public rewardToken;
    uint256 public rewardRate; // 每秒奖励数量
    uint256 public lastRewardTimestamp;

    struct Staker {
        uint256 stakedAmount;
        uint256 rewardDebt;
        uint256 stakedTimestamp;
    }

    mapping(address => Staker) public stakers;

    constructor(IERC20 _rewardToken, uint256 _rewardRate) {
        rewardToken = _rewardToken;
        rewardRate = _rewardRate;
        lastRewardTimestamp = block.timestamp;
    }

    function stake() external payable {
        require(msg.value > 0, "Staking amount should be greater than 0");
        _updateRewards(msg.sender);
        stakers[msg.sender].stakedAmount += msg.value;
        stakers[msg.sender].stakedTimestamp = block.timestamp;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdraw amount should be greater than 0");
        require(amount <= stakers[msg.sender].stakedAmount, "Not enough staked ETH to withdraw");
        _updateRewards(msg.sender);
        stakers[msg.sender].stakedAmount -= amount;
        payable(msg.sender).transfer(amount);
    }

    function claimRewards() external {
        _updateRewards(msg.sender);
        uint256 pendingRewards = stakers[msg.sender].rewardDebt;
        stakers[msg.sender].rewardDebt = 0;
        rewardToken.transfer(msg.sender, pendingRewards);
    }

    function addRewardToken(uint256 amount) external {
        rewardToken.transferFrom(msg.sender, address(this), amount);
    }

    function _updateRewards(address stakerAddress) internal {
        uint256 elapsedTime = block.timestamp - stakers[stakerAddress].stakedTimestamp;
        uint256 pendingReward = elapsedTime * rewardRate;
        uint256 stakerShare = (stakers[stakerAddress].stakedAmount * pendingReward) / address(this).balance;
        stakers[stakerAddress].rewardDebt += stakerShare;
    }
}