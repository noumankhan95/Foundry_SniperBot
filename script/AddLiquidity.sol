// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import {SniperBot} from "src/Sniper.sol";
import {console} from "forge-std/console.sol";

import {MockRouter} from "test/Mocks/Router.s.sol"; // Import the minimal router

contract AddLiquidty is Script {
    function run() external {
        // Start broadcasting using Anvil private key
        vm.startBroadcast(
            0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
        ); // Replace with your Anvil key
        vm.deal(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 100 ether);
        address router = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        ERC20Mock token = new ERC20Mock();
        token.mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 10e18);
        console.log("Token deployed at:", address(token));

        token.approve(router, 8e18);

        MockRouter(router).addLiquidityETH{value: 1 ether}(
            address(token),
            8e18,
            0,
            0,
            msg.sender,
            block.timestamp + 600
        );

        console.log("Liquidity added via MockRouter!");

        vm.stopBroadcast();
    }
}
