var Web3=require('web3');
var _abiBinJson = require('./MyBank.json');      //importing a javascript file

var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
contractName=Object.keys(_abiBinJson.contracts); // reading ['src/MyBank.sol:MyBank']
//console.log("- contract name: ", contractName); //or console.log(contractName[0]);
_abi=_abiBinJson.contracts[contractName].abi;
_abiArray=JSON.parse(JSON.stringify(_abi));
//_abiArray=JSON.parse(_abi);      //JSON parsing needed!!
//_bin=_abiBinJson.contracts[contractName].bin;
//console.log("- ABI: " + _abiArray);
//console.log("- Bytecode: " + _bin);

var myBank = new web3.eth.Contract(_abiArray,"0x81b928274EC5c4F366fEb3572252A327474C921d");

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Call from: " + accounts[0]);
    //timer.methods.getNow().call().then(function(value) {console.log("Now: ", value);});
    //await timer.methods.start().send({from:accounts[0],gas:100000});
    //await 4000;
    //timer.methods.timePassed().call().then(function(value) {console.log("Passed: ", value);});
    //var myBank = new web3.eth.Contract(_abiArray, '0x426E553a5C51a4258Dbb13Aca762bfe75684D7ea');
    myBank.methods.getBalance().call().then(console.log);
    myBank.methods.deposit(1111).send({from:accounts[0],gas:80000,value:1111});
    myBank.methods.getBalance().call().then(console.log);
}

doIt()
