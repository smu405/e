var Web3 = require('web3');
var _abiBinJson = require('./BankV2.json');      // JSON 파일 읽기

//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8345')); //웹소켓 연결

contractName=Object.keys(_abiBinJson.contracts); // 컨트랙명 ['src/BankV2.sol:BankV2']
console.log("- contract name: ", contractName);
_abi=_abiBinJson.contracts[contractName].abi;
_abiArray=JSON.parse(JSON.stringify(_abi));
//_abiArray=JSON.parse(_abi);      // 이런 오류 발생하면 SyntaxError: Unexpected token o in JSON at position 1

var bank = new web3.eth.Contract(_abiArray,"0x8b1A8486fB70E1EF99b32Ac4b45848CF424f0F7B");
var event = bank.events.Sent(function (error, result) {
    if (!error) {
        console.log("Event fired: " + JSON.stringify(result.returnValues));
    }
});

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account0: " + accounts[0]);
    const balance0Before = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 before: " + balance0Before);
    const balance1Before = await web3.eth.getBalance(accounts[1]);
    console.log("Balance1 before: " + balance1Before);

    bank.methods.getBalance().call().then(function(bal) {
        console.log("Contract bal before deposit: " + bal[0] + " this.bal:" + bal[1]);
    });
    await bank.methods.deposit(1111).send({from: accounts[0],gas:80000,value:1111});
    bank.methods.getBalance().call().then(function(bal) {
        console.log("Contract bal after deposit: " + bal[0] + " this.bal:" + bal[1]);
    });
    const forward = await bank.methods.forwardTo(accounts[1]).send({from: accounts[0],gas:100000,value:555});
    //const forward = await _test.methods.forwardTo().send({from: accounts[0], gas: 364124, gasPrice: '1000000000'})
        //.then(function(value) {console.log("---> myFunction called " + JSON.stringify(forward.events.Sent.returnValues));});
  
    console.log("---> forwardTo called " + JSON.stringify(forward.events.Sent.returnValues));
    bank.methods.getBalance().call().then(function(bal) {
        console.log("Contract balance after forwardTo: " + bal[0] + " this.bal:" + bal[1]);
    });
    const balance0After = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 after: " + balance0After);
    console.log("Balance0 diff: " + (balance0After - balance0Before));
    const balance1After = await web3.eth.getBalance(accounts[1]);
    console.log("Balance1 after: " + balance1After);
    console.log("Balance1 diff: " + (balance1After - balance1Before));

    const withdraw = await bank.methods.widthdrawAll().send({from: accounts[0],gas:100000});
    bank.methods.getBalance().call().then(function(bal) {
        console.log("Contract balance after withdrawAll: " + bal[0] + " this.bal:" + bal[1]);
    });
    const balance0AfterWithdrawAll = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 after withdrawAll: " + balance0AfterWithdrawAll);
    console.log("Balance0 diff after withdrawAll: " + (balance0After - balance0AfterWithdrawAll));
}
doIt()
