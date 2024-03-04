var Web3=require('web3');
var _abiJson = require('./Hello1ABI.json');
var _binJson = require('./Hello1BIN.json');
//var fs=require('fs');
//var _str = fs.readFileSync("src/Hello1ABI.json");
//var _json=JSON.parse(_str)

var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));

contractName=Object.keys(_abiJson.contracts); // reading ['src/Hello1.sol:Hello1']
//console.log("- contract name: ", contractName[0]); //or console.log(contractName);
_abiArray=_abiJson.contracts[contractName].abi;    //JSON parsing needed!!
//_abiArray=JSON.parse(_abiJson.contracts[contractName].abi);    //JSON parsing needed!!
_bin="0x"+_binJson.contracts[contractName].bin;  // ok with "0x"
//_bin=_binJson.contracts[contractName].bin;  // ok without"0x"
//console.log("- ABI: " + _abiArray);
//console.log("- Bytecode: " + _bin);

//unlock the account with a password provided
//web3.personal.unlockAccount(web3.eth.accounts[0],'password');
async function deploy() {
    const accounts = await web3.eth.getAccounts();
    console.log("Deploying the contract from " + accounts[0]);
    var deployed = await new web3.eth.Contract(_abiArray)
        .deploy({data: _bin, arguments: ["Hello from web3"]})
        .send({from: accounts[0], gas: 1000000}, function(err, transactionHash) {
                if(!err) console.log("hash: " + transactionHash); 
        })
        //.then(function(newContractInstance){
        //    console.log(newContractInstance.options.address)
        //});
    console.log("---> The contract deployed to: " + deployed.options.address)
}
deploy()
