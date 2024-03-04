var Web3=require('web3');
var web3=new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));       //nok
//var web3 = new Web3(new Web3.providers.WebsocketProvider("http://localhost:8345"));  //ok
//var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));  //ok
var fs = require('fs');
var _str = fs.readFileSync("src/Rectangle.json");
var _json = JSON.parse(_str)
//var _abiArray = JSON.parse(_json.contracts.sHello2.abi);
//var _abiArray = JSON.parse(_json.contracts["src/Rectangle.sol:Rectangle"].abi);
var _abiArray = _json.contracts["src/Rectangle.sol:Rectangle"].abi;

async function doIt() {
    var rect = new web3.eth.Contract(_abiArray, "0xA6D9e53c4E10ae1Af52F647C417E1F41eBEe9B1A");
    const accounts = await web3.eth.getAccounts();
    console.log("(1) Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("(2) Balance before: " + balanceBefore);
    rect.methods.getPerimeter().call().then(function(res) {console.log("(3) Perimeter: "+res)});
    rect.methods.getXOpposite().call().then(function(res) {console.log("(4) X opp: "+res)});
    rect.methods.getYOpposite().call().then(function(res) {console.log("(5) Y opp: "+res)});
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("(6) Balance after: " + balanceAfter);
    console.log("(7) Balance diff: " + (balanceBefore - balanceAfter));
    
}

doIt()
