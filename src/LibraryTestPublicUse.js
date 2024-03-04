var Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var fs = require('fs');
//var _str = fs.readFileSync("src/LibraryTestPublicLink__.json");
var _str = fs.readFileSync("src/LibraryTestPublicLink.json");
var _json = JSON.parse(_str)
//var _abiArray = JSON.parse(_json.contracts.sHello2.abi);
//var _abiArray = JSON.parse(_json.contracts["src/LibraryTestPublic.sol:LibrayTestPublic"].abi);
var _abiArray = _json.contracts["src/LibraryTestPublic.sol:LibrayTestPublic"].abi;

async function doIt() {
    var lib = new web3.eth.Contract(_abiArray, "0x27B4E66C995AB06bF7cB20F26AfCacA654C3914B");
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    lib.methods.multiply7By(5).estimateGas(function(err,gas) {
        if(!err) console.log(">> gas: "+ gas);
    });
    lib.methods.multiply7By(5).call().then(console.log);
}

doIt()
