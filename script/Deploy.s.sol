// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ETHStaking.sol";
import "../src/Launch.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        Launch launch = new Launch();
        console.log("Launch address", address(launch));
        console.log("script address 1:", address(this));
        console.log("msg.sender 2:", msg.sender);
        launch.mint(msg.sender,1e18 * 10 ** 9); //10亿个
        EthStaking ethStaking = new EthStaking(launch, 794e18 / 100);

        uint256 tokensToTransfer = (1e18 * 10 ** 9) * 60 / 100;
        launch.approve(address(ethStaking), tokensToTransfer);

        // Transfer the reward tokens to the EthStaking contract
        ethStaking.addRewardToken(tokensToTransfer);
        console.log("launch msg.sender bal", launch.balanceOf(msg.sender));
        console.log("allowance", launch.allowance(msg.sender, address(ethStaking)));


        ethStaking.stake{value: 1}();
        vm.stopBroadcast();
    }
}

// forge script script/Deploy.s.sol:Deploy --rpc-url $BSC_TESTNET_RPC_URL --private-key $PRIVATE_KEY -vvvv --broadcast