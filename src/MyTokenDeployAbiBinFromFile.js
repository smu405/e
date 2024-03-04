var Web3=require('web3');
var _abiBinJson = require('./MyToken.json');

var web3;
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
}

contractName=Object.keys(_abiBinJson.contracts);
console.log("- contract name: ", contractName[4]); //or console.log(contractName);

//_abi=_abiBinJson.contracts[contractName[4]].abi
//_bin=_abiBinJson.contracts[contractName[4]].bin


//contractName=Object.keys(_abiJson.contracts); // reading ['src//Timer.sol:Timer'];
//console.log("- contract name: ", contractName[4]); //or console.log(contractName);
_abiArray=JSON.parse(JSON.stringify(_abiBinJson.contracts[contractName[4]].abi));    //JSON parsing needed!!
//_abiArray=JSON.stringify(_abi)
_bin="0x"+_abiBinJson.contracts[contractName[4]].bin;
//console.log("- ABI: " + JSON.stringify(_abiArray));
//console.log("- Bytecode: " + _bin);

//unlock the account with a password provided
//web3.personal.unlockAccount(web3.eth.accounts[0],'password');

async function deploy() {
    const accounts = await web3.eth.getAccounts();
    console.log("Deploying the contract from " + accounts[0]);
    var deployed = await new web3.eth.Contract(_abiArray)
        .deploy({data: _bin})
        .send({from: accounts[0], gas: 1000000}, function(err, transactionHash) {
                if(!err) console.log("hash: " + transactionHash); 
        })
        //.then(function(newContractInstance){
        //    console.log(newContractInstance.options.address)
        //});
    console.log("---> The contract deployed to: " + deployed.options.address)
}
deploy()
