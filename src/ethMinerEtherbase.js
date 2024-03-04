console.log('Before: ', eth.coinbase);
miner.setEtherbase(eth.accounts[1]);
console.log('After: ', eth.coinbase);