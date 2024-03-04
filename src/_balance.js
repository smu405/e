/* 
 * @author jsl
 * @version modified web3.js/example/balance.html
 */
var Web3=require('web3');
var web3;
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://117.16.44.45:8545"));
}

function watchBalance() {
    var coinbase = web3.eth.accounts[3];

    var originalBalance = web3.eth.getBalance(coinbase).toNumber();
    console.log("original: "+originalBalance);
    web3.eth.filter('latest').watch(function() {
        var currentBalance = web3.eth.getBalance(coinbase).toNumber();
        console.log("current: "+currentBalance);
        console.log('diff current-original :    ' + (currentBalance - originalBalance));
    });
}

watchBalance();
web3.eth.sendTransaction({from:web3.eth.accounts[2], to:web3.eth.accounts[3], value:11});


