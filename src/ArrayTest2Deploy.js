var Web3=require('web3');
var _abiJson = require('./ArrayTest2ABI.json');
var _binJson = require('./ArrayTest2BIN.json');

var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
contractName=Object.keys(_abiJson.contracts); // reading ['src/ArrayTest2.sol:ArrayTest2']
console.log("- contract name: ", contractName[0]); //or console.log(contractName);
_abiArray=_abiJson.contracts[contractName].abi;
//_abiArray=JSON.parse(_abiJson.contracts[contractName].abi);    //JSON parsing needed!!
_bin="0x"+_binJson.contracts[contractName].bin; //ok without "0x"

//unlock the account with a password provided
//web3.personal.unlockAccount(web3.eth.accounts[0],'password');
async function deploy() {
    const accounts = await web3.eth.getAccounts();
    console.log("Deploying the contract from " + accounts[0]);

    new web3.eth.Contract(_abiArray).deploy({data: _bin}).estimateGas(function(err, gas) {
        if(!err) console.log(">> gas: "+ gas);
    });

    var deployed = await new web3.eth.Contract(_abiArray)
        .deploy({data: _bin})
        .send({from: accounts[0], gas: 1621137}, function(err, transactionHash) {
                if(!err) console.log("hash: " + transactionHash); 
        })
        //.then(function(newContractInstance){
        //    console.log(newContractInstance.options.address)
        //});
    console.log("---> The contract deployed to: " + deployed.options.address);
}

deploy()
