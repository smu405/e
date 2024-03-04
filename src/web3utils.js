var Web3 = require('web3');
var web3 = new Web3('http://localhosst:8345');
console.log("random hex: ", web3.utils.randomHex(32));    //generate random 32 byte hex
console.log("234 hash: ", web3.utils.keccak256('234'));  //calculate keccak256 for '234'
console.log("is address?: ",web3.utils.isAddress('0xf2a4f09c903a0a7b3450d9d16bbca14dea36aee1'));  //check if the input is a valid address
console.log("안녕 in Hex: "+web3.utils.utf8ToHex('안녕'));
console.log("wei of 1 ether: "+web3.utils.toWei('1', 'ether'));
