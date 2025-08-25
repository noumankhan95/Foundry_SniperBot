require("dotenv").config();
const { ethers } = require("ethers");

const RPC_URL = process.env.RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const SNIPER_CONTRACT = process.env.SNIPER_CONTRACT;
const FACTORY = process.env.FACTORY;
const WETH = process.env.WETH;
const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

const factoryAbi = [
    "event PairCreated(address indexed token0, address indexed token1, address pair, uint)"
];

const pairAbi = [
    "function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)",
    "function token0() external view returns (address)",
    "function token1() external view returns (address)"
];

const sniperAbi = [
    "function buyToken(address token, uint tokenPrice, uint slippageTolerance) external payable"
];

const factory = new ethers.Contract(FACTORY, factoryAbi, provider);
const sniper = new ethers.Contract(SNIPER_CONTRACT, sniperAbi, wallet);

const SLIPPAGE = 9950;

factory.on("PairCreated", async (token0, token1, pairAddress) => {
    try {
        console.log(`New pair detected: ${token0} / ${token1} at ${pairAddress}`);

        // Skip the pair if both tokens are WETH (unlikely) or your token is WETH
        let targetToken;
        if (token0.toLowerCase() !== WETH.toLowerCase()) {
            targetToken = token0;
        } else if (token1.toLowerCase() !== WETH.toLowerCase()) {
            targetToken = token1;
        } else {
            console.log("Both tokens are WETH, skipping...");
            return;
        }

        const pair = new ethers.Contract(pairAddress, pairAbi, provider);

        const [reserve0, reserve1] = await pair.getReserves();
        const token0Address = await pair.token0();
        const token1Address = await pair.token1();
        console.log("fetched reserves", reserve0, "  ", reserve1)
        const ONE_ETHER = 10n ** 18n; // BigInt literal
        let tokenPrice;
        if (token0Address.toLowerCase() === targetToken.toLowerCase()) {
            tokenPrice = (reserve1 * ONE_ETHER) / reserve0; // target token is token0
        } else {
            tokenPrice = (reserve0 * ONE_ETHER) / reserve1; // target token is token1
        }

        console.log(`Target token: ${targetToken}`);
        console.log(`Estimated token price: ${tokenPrice / ONE_ETHER} ETH`);

        const tx = await sniper.buyToken(targetToken, tokenPrice, SLIPPAGE, {
            value: ethers.parseEther("0.1"),
            gasLimit: 500000
        });
        console.log("Buy tx sent:", tx.hash);
        await tx.wait();
        console.log("Buy executed successfully!");

    } catch (err) {
        console.error("Error sniping token:", err);
    }
});
