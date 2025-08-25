// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Pair.sol";

contract MockRouter {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint,
        uint,
        address to,
        uint deadline
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity)
    {
        MockPair fakePair = new MockPair(
            token,
            msg.sender,
            uint112(amountTokenDesired),
            uint112(msg.value)
        );
        emit PairCreated(token, msg.sender, address(fakePair), block.timestamp);

        return (amountTokenDesired, msg.value, 1);
    }
}
