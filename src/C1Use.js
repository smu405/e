var Web3=require('web3');
var web3=new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var fs=require('fs');
var _str = fs.readFileSync("src/C1.json");
var _json=JSON.parse(_str)
//var _abiArray=JSON.parse(_json.contracts.sHello2.abi);
//var _abiArray=JSON.parse(_json.contracts["src/C1.sol:C1"].abi);
var _abiArray = _json.contracts["src/C1.sol:C1"].abi;

var c1 = new web3.eth.Contract(_abiArray, "0xc84381615C183B74ba3cd0cb9Ae9455d5236d586");
async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    c1.methods.get7().call().then(console.log);
    await c1.methods.set(9).send({from: accounts[0],gas:50000});
    c1.methods.get().call().then(console.log);
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
    //hello.methods.kill().send({from: accounts[0]})
}

doIt()
