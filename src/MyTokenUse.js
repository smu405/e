var Web3=require('web3');
var _abiBinJson = require('./MyToken.json');

var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));

contractName=Object.keys(_abiBinJson.contracts); 
console.log("- contract name: ", contractName[4]);// reading ['src//Timer.sol:Timer']
var _abiArray=JSON.parse(JSON.stringify(_abiBinJson.contracts[contractName[4]].abi));    //JSON parsing needed!!

var _test = new web3.eth.Contract(_abiArray, '0x8d8A11930c7C25554eD0EE8138E720206437af92');

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account: " + accounts[0]);
    const balanceBefore = await web3.eth.getBalance(accounts[0]);
    console.log("Balance before: " + balanceBefore);
    
    const name = await _test.methods.name().call();
    console.log("name: " + name);
    const decimals = await _test.methods.decimals().call();
    console.log("decimals: " + decimals);
    const value = await _test.methods.totalSupply().call();
    console.log("totalSupply: " + value);

    console.log("-----1 before transfer-----");
    console.log("1-1 balanceOfAccount0: " + await _test.methods.balanceOf(accounts[0]).call());
    console.log("1-2 balanceOfAccount1: " + await _test.methods.balanceOf(accounts[1]).call());
    await _test.methods.transfer(accounts[1], 1)
        .send({from: accounts[0], gas: 364124, gasPrice: '1000000000'})
    console.log("-----2 after transfer-----");
    console.log("2-1 balanceOfAccount0: " + await _test.methods.balanceOf(accounts[0]).call());
    console.log("2-2 balanceOfAccount1: " + await _test.methods.balanceOf(accounts[1]).call());
    console.log("-----3 after approve and transferFrom-----");    
    var addrTo = accounts[0];
    console.log("3-1 allowanceOfAddrTo: "+ await _test.methods.allowance(accounts[0], addrTo).call());
    await _test.methods.approve(addrTo, 111)
        .send({from: accounts[0], gas: 100000});
    console.log("3-2 allowanceOfAddrTo 111: "+ await _test.methods.allowance(accounts[0], addrTo).call());
    await _test.methods.transferFrom(addrTo, accounts[1], 1)
        .send({from: accounts[0], gas: 3641240, gasPrice: '1000000000'})
    console.log("3-3 balanceOfAccount0: " + await _test.methods.balanceOf(accounts[0]).call());
    console.log("3-4 balanceOfAccount1: " + await _test.methods.balanceOf(accounts[1]).call());
    //const value = await _test.methods.myFunction()
    //    .send({from: accounts[0], gas: 364124, gasPrice: '1000000000'})
        //.then(function(value) {console.log("---> myFunction called " + JSON.stringify(value.events.MyLog.returnValues));});
    //console.log("---> myFunction called " + JSON.stringify(value.events.MyLog.returnValues));
    const balanceAfter = await web3.eth.getBalance(accounts[0]);
    console.log("Balance after: " + balanceAfter);
    console.log("Balance diff: " + (balanceBefore - balanceAfter));
}
doIt()
