var Web3=require('web3');
var web3=new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var fs=require('fs');
var _str = fs.readFileSync("src/C1C2.json");
var _json=JSON.parse(_str)
//var _abiArray=JSON.parse(_json.contracts.sHello2.abi);
//var _abiArray=JSON.parse(_json.contracts["src/C1C2.sol:C2"].abi);
var _abiArray=_json.contracts["src/C1C2.sol:C2"].abi;

var c2 = new web3.eth.Contract(_abiArray, "0xE0b20Cf5684a8Aa9Bac4F7c1A186237Abe18026B");

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    c2.methods.get7().call().then(function(res) {console.log("C1 get7(): " + res)});
    await c2.methods.set(9).send({from: accounts[0],gas:50000}, function(err,res) {
        console.log("setting 9..."+res);
    });
    c2.methods.get().call().then(function(res) {console.log("C1 get(): " + res)});
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
    //hello.methods.kill().send({from: accounts[0]})
}

doIt()
