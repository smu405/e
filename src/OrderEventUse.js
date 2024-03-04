var Web3=require('web3');
//var fs = require('fs');
var _abiBinJson = require('./OrderEvent.json');      //importing a javascript file

//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
//var web3 = new Web3(new Web3.providers.WebsocketProvider("http://localhost:8345"));
var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));
contractName=Object.keys(_abiBinJson.contracts); // reading ['src/OrderEvent.sol:OrderEvent']
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
    var _order = new web3.eth.Contract(_abiArray, '0x3E04292870AA4Ef2bc44A1638B19A50BCD99b04D');
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    var event = _order.events.OrderLog({
            //filter: {_from: accounts[0], _value: [20,50]},
            filter: {_from: accounts[0], _value: 30},
            fromBlock: 'latest', toBlock: 'pending'
        }, function (error, result) {
        if (!error) {
            //console.log("Event fired: " + JSON.stringify(result) + "\n---> " + JSON.stringify(result.returnValues));
            console.log("Event fired: " + JSON.stringify(result.returnValues));
            //process.exit(1);
        }
    });
    var value;
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    // this will fire an event
    my = await _order.methods.order("0x1234", 3)
        .send({from: accounts[0], gas: 100000, value:30})
        //.then(function(my) {console.log("---> MyFunction called " + JSON.stringify(my.events.OrderLog.returnValues));});
    console.log("---> MyFunction called " + JSON.stringify(my.events.OrderLog.returnValues));
    // this will fire another event
    my = await _order.methods.order("0x1234", 4).send({from: accounts[0], gas: 100000, value:40});
    console.log("---> MyFunction called " + JSON.stringify(my.events.OrderLog.returnValues));
    // this will NOT fire another event
    my = await _order.methods.order("0x1234", 10).send({from: accounts[0], gas: 100000, value:100});
    console.log("---> MyFunction called " + JSON.stringify(my.events.OrderLog.returnValues));
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));    
    process.exit(1); //force exit to disconnect websocket
}

doIt()
