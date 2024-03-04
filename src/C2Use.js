var Web3=require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var fs=require('fs');
var _str = fs.readFileSync("src/C2.json");
var _json = JSON.parse(_str)
//var _abiArray = JSON.parse(_json.contracts.sHello2.abi);
//var _abiArray = JSON.parse(_json.contracts["src/C2.sol:C2"].abi);
var _abiArray = _json.contracts["src/C2.sol:C2"].abi;

var c2 = new web3.eth.Contract(_abiArray, "0x3B7A1c3e7C223eDd963eE045DaCf4A6860164Cf8");
async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    console.log("--- new C1 ---");
    await c2.methods.getC1Address().call(function(err, c1addr) {
        if(!err) console.log("c1 address by 'new': "+c1addr);
    });
    c2.methods.get7().call().then(function(res) { console.log("get7(): "+res) });
    console.log("--- set the above deployed address of C1 ---");
    await c2.methods.setC1("0xc84381615C183B74ba3cd0cb9Ae9455d5236d586").send({from:accounts[0], gas:50000});
    await c2.methods.getC1Address().call(function(err, c1addr) {
        if(!err) console.log("c1 address by 'setC1()': "+c1addr);
    });
    c2.methods.get7().call().then(console.log);
    await c2.methods.set(222).send({from: accounts[0],gas:50000});
    c2.methods.get().call().then(console.log);
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
    //hello.methods.kill().send({from: accounts[0]})
}

doIt()
