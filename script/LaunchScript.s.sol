// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Launch.sol";

contract LaunchScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        Launch launch = new Launch();
        console.log("Launch", address(launch));
        console.log("script address 1:", address(this));
        console.log("msg.sender 2:", msg.sender);
        launch.mint(msg.sender,1e18);
        vm.stopBroadcast();
    }
}

// forge script script/LaunchScript.s.sol:LaunchScript --rpc-url $BSC_TESTNET_RPC_URL --private-key $PRIVATE_KEY -vvvv --broadcast