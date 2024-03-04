var Web3=require('web3');
var _abiBinJson = require('./Multiply7Event.json');      //importing a javascript file

//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));
contractName=Object.keys(_abiBinJson.contracts); // reading ['src/Multiply7Event.sol:Multiply7Event']
//console.log("- contract name: ", contractName); //or console.log(contractName[0]);
_abiArray=_abiBinJson.contracts[contractName].abi; //use just as read from file
//_abiArray=JSON.parse(JSON.stringify(_abi));
//_abiArray=JSON.parse(_abi);      //JSON parsing needed!!
//_bin=_abiBinJson.contracts[contractName].bin;
//console.log("- ABI: " + _abiArray);
//console.log("- Bytecode: " + _bin);
var m7 = new web3.eth.Contract(_abiArray, '0x33add2effA3E32050aCD8446d826b0EFFB93A515');
var event = m7.events.Print({fromBlock: 0}, function (error, result) {
    if (!error) {
        //console.log("Event fired: " + JSON.stringify(result) + "\n---> " + JSON.stringify(result.returnValues));
        console.log("Event fired: " + JSON.stringify(result.returnValues));
        //process.exit(1);
    }
});

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    //const value = m7.methods.multiply(8).call();
    const value = m7.methods.multiply(8)
        .send({from: accounts[0]})
        //.then(function(value) {console.log("---> MyFunction called " + JSON.stringify(value) +
        //                               '\n---> '+ JSON.stringify(value.events.Print.returnValues));});
    console.log("---> MyFunction called " + JSON.stringify(value));
        //+ '\n---> '+ JSON.stringify(value.events.Print.returnValues));
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
    process.exit(1); //force exit to end waiting
}

doIt()
