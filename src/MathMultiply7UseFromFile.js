var Web3=require('web3');
var _abiJson = require('./MathMultiply7ABI.json');
//var _binJson = require('./MathMultiply7BIN.json'); // not needed
//var fs=require('fs');
//var _str = fs.readFileSync("src/MathMultiply7ABI.json");
//var _json=JSON.parse(_str)

//var web3;
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
//if (typeof web3 !== 'undefined') {
//    web3 = new Web3(web3.currentProvider);
//} else {
    //web3 = new Web3(new Web3.providers.WebsocketProvider("ws://117.16.44.45:8345"));
//    web3 = new Web3(new Web3.providers.HttpProvider("http://117.16.44.45:8345"));
//}

contractNames=Object.keys(_abiJson.contracts); //Math, Multiply7
contractName=contractNames[0]; // -> 'src/MathMultiply7.sol:Math', contractNames[1] -> Multiply7
console.log("- contract name: ", contractName); //or console.log(contractName);
//_abiArray=JSON.parse(_abiJson.contracts[contractName].abi);    //JSON parsing needed!!
_abiArray=JSON.parse(JSON.stringify(_abiJson.contracts[contractName].abi));    //Unexpected token error
//_bin=_binJson.contracts[contractName].bin;
//console.log("- ABI: " + _abiArray);
//console.log("- Bytecode: " + _bin);

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    var _instance = new web3.eth.Contract(_abiArray, "0xcD3F2A7eca9E6cF6dA466E0e011858E05B033C65");

    _instance.methods.multiply().call().then(console.log);
    _instance.methods.deposit(123).send({from:accounts[0], value:123});
    _instance.methods.getBalanceOfM7().call().then(console.log);
    await _instance.methods.send11M7().send({from:accounts[0]});
    _instance.methods.getBalanceOfM7().call().then(console.log);
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
}

doIt()
