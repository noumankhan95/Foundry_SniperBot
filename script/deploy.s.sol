//SPDX-License-Identifier:MIT

pragma solidity ^0.8.20;
import {MockRouter} from "test/Mocks/Router.s.sol"; // Import the minimal router
import {console} from "forge-std/console.sol";
import {SniperBot} from "src/Sniper.sol";
import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import {Script} from "forge-std/Script.sol";
import {WETH} from "test/Mocks/coin.sol";

contract Deploy is Script {
    function run() external returns (address) {
        vm.broadcast(
            0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
        );
        MockRouter router = new MockRouter();
        console.log("Mock Router deployed at:", address(router));

        SniperBot sniper = new SniperBot(address(router));
        WETH weth = new WETH();
        console.log("WETH Token deployed at:", address(weth));
        return (address(sniper));
    }
}
