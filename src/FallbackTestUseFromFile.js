var Web3=require('web3');
var _abiBinJson = require('./FallbackTest.json');      //importing a javascript file

//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));
contractName=Object.keys(_abiBinJson.contracts); // reading ['src/FallbackTest.sol:FallbackTest']
console.log("- contract name: ", contractName); //or console.log(contractName[0]);
_abiArray=_abiBinJson.contracts[contractName].abi; //use just as read from file
//_abiArray=JSON.parse(JSON.stringify(_abi));
//_abiArray=JSON.parse(_abi);      //JSON parsing needed!!
//_bin=_abiBinJson.contracts[contractName].bin;
console.log("- ABI: " + _abiArray);
//console.log("- Bytecode: " + _bin);
_abiArray=[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"","type":"string"}],"name":"PrintLog","type":"event"},{"stateMutability":"nonpayable","type":"fallback"},{"inputs":[],"name":"callA","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"}];
async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    var _instance = new web3.eth.Contract(_abiArray, "0x305F89e9b9C91B0b242874d77Ef675b0eBAD437C");
    var event = _instance.events.PrintLog({fromBlock: 0}, function (error, result) {
        if (!error) {
            console.log("Event fired: " + JSON.stringify(result) + "\n---> " + JSON.stringify(result.returnValues));
        }
    });

    _instance.methods.callA().call().then(function(res) { console.log(res); });  //null
    //call without calling any method
    //await _instance.methods.callB().send({from:accounts[0], to: "0x3991e87b71cBFf94aA0718F341d8Ad4bCF969f36"}); //fail
    //await _instance.methods.callA().send({from:accounts[0], data:"0x1234"});  //empty calldata to call fallback -> fail
    web3.eth.sendTransaction({from:accounts[0], to:"0x305F89e9b9C91B0b242874d77Ef675b0eBAD437C"}); //fallback called
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
    process.exit(1); //force exit
}
doIt()
