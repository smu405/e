var Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var fs = require('fs');
var _str = fs.readFileSync("src/Rectangle.json");
var _json = JSON.parse(_str)
//var _abiArray = JSON.parse(_json.contracts.sHello2.abi);
//var _abiArray = JSON.parse(_json.contracts["src/Rectangle.sol:Rectangle"].abi);
var _abiArray = _json.contracts["src/Rectangle.sol:Rectangle"].abi;
//var _bin = _json.contracts.sHello2.bin;
var _bin = "0x" + _json.contracts["src/Rectangle.sol:Rectangle"].bin;

//unlock the account with a password provided
//web3.personal.unlockAccount(web3.eth.accounts[0],'password');
async function deploy() {
    const accounts = await web3.eth.getAccounts();
    console.log("Deploying the contract from " + accounts[0]);
    var deployed = await new web3.eth.Contract(_abiArray)
        .deploy({data: _bin, arguments: [10, 20, 30, 40]})
        .send({from: accounts[0], gas: 1000000}, function(err, transactionHash) {
                if(!err) console.log("hash: " + transactionHash); 
        })
        //.then(function(newContractInstance){
        //    console.log(newContractInstance.options.address)
        //});
    console.log("---> The contract deployed to: " + deployed.options.address)
}

deploy()
