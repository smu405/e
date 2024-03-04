var Web3=require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8445"));
//var web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8445'));
var _abiArray=[{"constant":true,"inputs":[],"name":"getBalance","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_receiver","type":"address"}],"name":"forwardTo","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[],"name":"widthdrawAll","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"amount","type":"uint256"}],"name":"deposit","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"from","type":"address"},{"indexed":false,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Sent","type":"event"}];

async function doIt() {
    var bank = new web3.eth.Contract(_abiArray, '0xb69A207C9Cb6cA35E2B797A430542D2ec79c06eA');
    var event = bank.events.Sent({fromBlock: 0}, function (error, result) {
        if (!error) {
            console.log("Event fired: " + JSON.stringify(result.returnValues));
        }
    });

    const accounts = await web3.eth.getAccounts();
    console.log("Account0: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 before: " + balanceBefore);

    
    bank.methods.getBalance().call().then(console.log);
    bank.methods.deposit(1111).send({from: accounts[0],gas:80000,value:1111});
    bank.methods.getBalance().call().then(console.log);

    const value = await bank.methods.forwardTo(accounts[1]).send({from: accounts[0],gas:100000,value:555});
    //const value = await _test.methods.forwardTo().send({from: accounts[0], gas: 364124, gasPrice: '1000000000'})
        //.then(function(value) {console.log("---> myFunction called " + JSON.stringify(value.events.Sent.returnValues));});

    bank.methods.getBalance().call().then(console.log);  
    
    console.log("---> forwardTo called " + JSON.stringify(value.events.Sent.returnValues));
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
}
doIt()
