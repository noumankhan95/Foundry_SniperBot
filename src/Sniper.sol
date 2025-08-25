// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IUniswapV2Router} from "./interfaces/Uniswap.sol";

contract SniperBot {
    address private immutable UNISWAP_ROUTER;

    constructor(address router) {
        require(router != address(0), "Router cannot be zero");
        UNISWAP_ROUTER = router;
    }

    /**
     * @notice Buy a token using ETH on Uniswap V2
     * @param token Address of the token to buy
     * @param slippageTolerance e.g. 9500 for 5% slippage (10000 = 0%)
     */
    function buyToken(address token, uint slippageTolerance) external payable {
        require(msg.value > 0, "Send ETH to buy");
        require(token != address(0), "Token address cannot be zero");
        require(
            slippageTolerance > 0 && slippageTolerance <= 10000,
            "Invalid slippage"
        );

        IUniswapV2Router router = IUniswapV2Router(UNISWAP_ROUTER);
        address weth = router.WETH();

        address[] memory path;
        path[0] = weth;
        path[1] = token;

        uint amountOutMin = 0; // For now, accept any amount. You can integrate price feed for exact slippage

        router.swapExactETHForTokens{value: msg.value}(
            amountOutMin,
            path,
            msg.sender,
            block.timestamp + 300 // 5 minutes deadline
        );
    }

    receive() external payable {}
}
