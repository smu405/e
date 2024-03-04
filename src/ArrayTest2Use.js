var Web3=require('web3');
var _abiJson = require('./ArrayTest2ABI.json');
var web3=new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));       //ok

contractName=Object.keys(_abiJson.contracts); // reading ['src/ArrayTest2.sol:ArrayTest2']
console.log("- contract name: ", contractName[0]); //or console.log(contractName);
_abiArray=_abiJson.contracts[contractName].abi;
//_abiArray=JSON.parse(_abiJson.contracts[contractName].abi);    //JSON parsing needed!!

async function doIt() {
    var arr = new web3.eth.Contract(_abiArray, "0x23293b04d95B80b7aFbcb20a70258203ad040448");
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    
    arr.methods.setCities23().estimateGas(function(err, gas) {
        if(!err) console.log(">> gas: "+ gas);
    });

    //await arr.methods.setCities23().send({from: accounts[0]});   //out of gas error
    await arr.methods.setCities23().send({from: accounts[0], gas:133310});
    arr.methods.getCities2().call().then(console.log);

    arr.methods.setMathMarks().estimateGas(function(err, gas) {
        if(!err) console.log(">> gas: "+ gas);
    });

    await arr.methods.setMathMarks().send({from: accounts[0], gas: 162354});
    //ERROR invalid opcode arr.methods.getMathAbove70().call().then(console.log);
    arr.methods.getMarksArr().call().then(console.log);

    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
}

doIt()
