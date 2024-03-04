var Web3=require('web3');
var fs = require('fs');
var _abiBinJson = require('./EventTest.json');      //importing a javascript file

//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
//var web3 = new Web3(new Web3.providers.WebsocketProvider("http://localhost:8345"));
var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));
contractName=Object.keys(_abiBinJson.contracts); // reading ['src/EventTest.sol:EventTest']
//console.log("- contract name: ", contractName); //or console.log(contractName[0]);
_abiArray=_abiBinJson.contracts[contractName].abi; //use just as read from file
//_abiArray=JSON.parse(JSON.stringify(_abi));
//_abiArray=JSON.parse(_abi);      //JSON parsing needed!!
//_bin=_abiBinJson.contracts[contractName].bin;
console.log("- ABI: " + _abiArray);
//console.log("- Bytecode: " + _bin);
//var _test = new web3.eth.Contract(_abiArray,"0x8911bA097c812Bf0B3ff22F90eaf2A905112C5a6");
//var event = _test.events.MyLog({fromBlock: 0}, function (error, result) {
//    if (!error) {
//        console.log("Event fired: " + JSON.stringify(result.returnValues));
//    }
//});

async function doIt() {
    var _test = new web3.eth.Contract(_abiArray, '0x8911bA097c812Bf0B3ff22F90eaf2A905112C5a6');
    var event = _test.events.MyLog({fromBlock: 0}, function (error, result) {
        if (!error) {
            log = JSON.stringify(result.returnValues);
            console.log("Event fired: " + log);
            //fs.writeFile("src/EventTestLog.txt", log, "utf-8", function(e) {
            fs.appendFile("src/EventTestLog.txt", log, "utf-8", function(e) {
                if(!e) {
                    console.log(">> Writing to file");
                }
            });
        }
    });
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    const value = await _test.methods.myFunction()
        .send({from: accounts[0], gas: 364124, gasPrice: '1000000000'})
        //.then(function(value) {console.log("---> myFunction called " + JSON.stringify(value.events.MyLog.returnValues));});
    console.log("---> myFunction called " + JSON.stringify(value.events.MyLog.returnValues));
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
    process.exit(1); //force exit to disconnect websocket
}

doIt()
