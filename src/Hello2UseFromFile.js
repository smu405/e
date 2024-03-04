var Web3=require('web3');
var _abiJson = require('./Hello2ABI.json');
//var web3=new Web3(new Web3.providers.HttpProvider("http://117.16.44.45:8345"));       //nok
//var web3 = new Web3(new Web3.providers.WebsocketProvider("http://117.16.44.45:8345"));  //ok
var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));  //ok

contractName=Object.keys(_abiJson.contracts); // reading ['src/Hello2.sol:Hello2']
console.log("- contract name: ", contractName[0]); //or console.log(contractName);
_abiArray=_abiJson.contracts[contractName].abi;
//_abiArray=JSON.parse(_abiJson.contracts[contractName].abi);    //JSON parsing needed!!

async function doIt() {
    var hello = new web3.eth.Contract(_abiArray, "0x0de24099235b8CB671f3Ed2771F69B2049F679AF");
    var event = hello.events.PrintLog(function (error, result) {
        if (!error) {
            console.log("Event fired: " + JSON.stringify(result.returnValues));
        }
    });
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    hello.methods.sayHello().call().then(console.log);  //null
    await hello.methods.setHello("Hello World!").send({from: accounts[0], value: 1111});
    hello.methods.sayHello().call().then(console.log);
    //hello.methods.getBalance().call(function(err, bal) { console.log("Contract Balance: "+bal) });
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
    process.exit(1);
    //hello.methods.kill().send({from: accounts[0]})
}

doIt()
