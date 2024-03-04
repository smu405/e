var Web3 = require('web3');
var web3 = new Web3('http://localhost:8345');
//web3.eth.getChainId().then(console.log);
web3.eth.getAccounts(console.log);
web3.eth.getCoinbase().then(console.log);
web3.eth.getBlockNumber().then(console.log);
web3.eth.getBalance('0xf2a4f09c903a0a7b3450d9d16bbca14dea36aee1').then(console.log);
web3.eth.getNodeInfo().then(console.log);
