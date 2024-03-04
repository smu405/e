var Web3=require('web3');
var web3=new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
//var web3 = new Web3(new Web3.providers.WebsocketProvider("http://117.16.44.45:8345"));  //ok
//var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://117.16.44.45:8345"));  //ok
var fs = require('fs');
var _str = fs.readFileSync("src/LibraryTest.json");
var _json = JSON.parse(_str)
//var _abiArray = JSON.parse(_json.contracts.sHello2.abi);
//var _abiArray = JSON.parse(_json.contracts["src/LibraryTest.sol:LibrayTest"].abi);
var _abiArray = _json.contracts["src/LibraryTest.sol:LibrayTest"].abi;

async function doIt() {
    var lib = new web3.eth.Contract(_abiArray, "0x073AC32fCAffe303BF39D15Bad575Eb882E6262A");
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    lib.methods.multiply7By(5).estimateGas(function(err,gas) {
        if(!err) console.log(">> gas: "+ gas);
    });
    lib.methods.multiply7By(5).call().then(console.log);
}

doIt()
