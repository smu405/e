var Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var fs = require('fs');
var _str = fs.readFileSync("src/TestSafeMathZeppelin.json");
var _json = JSON.parse(_str)
//var _abiArray = JSON.parse(_json.contracts.sHello2.abi);
//|var _abiArray = JSON.parse(_json.contracts["src/TestSafeMathZeppelin.sol:TestSafeMath"].abi);
var _abiArray = _json.contracts["src/TestSafeMathZeppelin.sol:TestSafeMath"].abi;

async function doIt() {
    var lib = new web3.eth.Contract(_abiArray, "0x235C5eb4C4ec5A0FB30e4CdAA8AA28f9812fF67D");
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    lib.methods.add(11,20).estimateGas(function(err,gas) {
        if(!err) console.log(">> gas: "+ gas);
    });
    lib.methods.add(11,20).call().then(console.log);
}

doIt()
