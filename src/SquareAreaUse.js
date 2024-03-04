var Web3 = require('web3');
//var web3 = new Web3(new Web3.providers.HttpProvider("http://117.16.44.45:8345"));         //nok
//var web3 = new Web3(new Web3.providers.WebsocketProvider("http://117.16.44.45:8345"));  //ok
var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));
var fs=require('fs');
var _str = fs.readFileSync("src/SquareArea.json");
var _json = JSON.parse(_str)
//var _abiArray = JSON.parse(_json.contracts.sHello2.abi);
//var _abiArray = JSON.parse(_json.contracts["src/SquareArea.sol:Area"].abi);
var _abiArray = _json.contracts["src/SquareArea.sol:Area"].abi;

async function doIt() {
    var area = new web3.eth.Contract(_abiArray, "0xf9B59A87fF00Eb38E59A4E065c63b2C991C8C11A");
    var speed;
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    area.methods.getDegree().call().then(console.log);
    await area.methods.setLength(9).send({from: accounts[0]});
    area.methods.getLength().call().then(console.log);
    //area.methods.calcArea().send({from: accounts[0]});
    area.methods.calcArea().call().then(console.log);
    area.methods.getAddressOfSquare().call().then(function(address) {
        console.log("Square Address: " + address);
    });
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
    //process.exit(1); //force exit -> may terminate some functions (speedDownBy10, getSpeed)  
}

doIt()
