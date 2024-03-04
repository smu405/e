var primary = eth.accounts[0];
var bal=eth.getBalance(primary);
console.log('balance in Wei: ', bal);
console.log('balance in ether: ', web3.fromWei(bal, "ether"));
console.log('blocknumber: ', eth.blockNumber);
console.log('coinbase: ', eth.coinbase);
