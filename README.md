## Foundry

**The Smart Contract aims to simulate sniper bot transactions**

first run your anvil node 
then run forge script ./script/deploy.s.sol --fork-url http://127.0.0.1:8545/ --broadcast 
this will deploy your smart contract to anvil 


After that use the bot.js file to run the bot .
Then run forge script script/AddLiquidity.sol:AddLiquidty   --fork-url http://127.0.0.1:8545   --broadcast   --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 .

Above will emit a fake event the bot listens to .The bot will behave as buying the token.# Foundry_SniperBot
