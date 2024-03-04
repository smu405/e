var Web3=require('web3');
//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8446'));
var _abiArray=[{"constant":true,"inputs":[],"name":"getBalance","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_receiver","type":"address"}],"name":"forwardTo","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[],"name":"widthdrawAll","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"}],"name":"deposit","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"from","type":"address"},{"indexed":false,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Sent","type":"event"}];
var bank = new web3.eth.Contract(_abiArray, '0xb69A207C9Cb6cA35E2B797A430542D2ec79c06eA');
var event = bank.events.Sent({fromBlock: 0}, function (error, result) {
    if (!error) {
        console.log("Event fired: " + JSON.stringify(result.returnValues));
    }
});

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account0: " + accounts[0]);
    const balance0Before = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 before: " + balance0Before);
    const balance1Before = await web3.eth.getBalance(accounts[1]);
    console.log("Balance1 before: " + balance1Before);

    bank.methods.getBalance().call().then(function(bal) {
        console.log("Contract bal before deposit: " + bal[0] + " this.bal:" + bal[1]);
    });
    await bank.methods.deposit(1111).send({from: accounts[0],gas:80000,value:1111});
    bank.methods.getBalance().call().then(function(bal) {
        console.log("Contract bal after deposit: " + bal[0] + " this.bal:" + bal[1]);
    });
    const forward = await bank.methods.forwardTo(accounts[1]).send({from: accounts[0],gas:100000,value:555});
    //const forward = await _test.methods.forwardTo().send({from: accounts[0], gas: 364124, gasPrice: '1000000000'})
        //.then(function(value) {console.log("---> myFunction called " + JSON.stringify(forward.events.Sent.returnValues));});
  
    console.log("---> forwardTo called " + JSON.stringify(forward.events.Sent.returnValues));
    bank.methods.getBalance().call().then(function(bal) {
        console.log("Contract balance after forwardTo: " + bal[0] + " this.bal:" + bal[1]);
    });
    const balance0After = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 after: " + balance0After);
    console.log("Balance0 diff: " + (balance0After - balance0Before));
    const balance1After = await web3.eth.getBalance(accounts[1]);
    console.log("Balance1 after: " + balance1After);
    console.log("Balance1 diff: " + (balance1After - balance1Before));

    const withdraw = await bank.methods.widthdrawAll().send({from: accounts[0],gas:100000});
    bank.methods.getBalance().call().then(function(bal) {
        console.log("Contract balance after withdrawAll: " + bal[0] + " this.bal:" + bal[1]);
    });
    const balance0AfterWithdrawAll = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 after withdrawAll: " + balance0AfterWithdrawAll);
    console.log("Balance0 diff after withdrawAll: " + (balance0After - balance0AfterWithdrawAll));
}
doIt()
