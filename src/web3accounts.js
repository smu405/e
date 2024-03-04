var Web3 = require('web3');
var web3 = new Web3('http://localhost:8345');
web3.eth.getAccounts(function(err,res) { console.log("(1) accounts: " + res); } );
my=[]
web3.eth.getAccounts(function(err, res) { for (x in res) { my.push(res[x]) } } );
console.log("(2) accounts from array: " + my[0]);
