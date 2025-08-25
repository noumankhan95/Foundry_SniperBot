// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockPair {
    address public t0;
    address public t1;
    uint112 public r0;
    uint112 public r1;

    constructor(
        address token0,
        address token1,
        uint112 reserve0,
        uint112 reserve1
    ) {
        t0 = token0;
        t1 = token1;
        r0 = reserve0;
        r1 = reserve1;
    }

    function getReserves() external view returns (uint112, uint112, uint32) {
        return (r0, r1, uint32(block.timestamp));
    }

    function token0() external view returns (address) {
        return t0;
    }

    function token1() external view returns (address) {
        return t1;
    }
}
