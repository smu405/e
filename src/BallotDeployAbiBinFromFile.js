var Web3=require('web3');
var _abiBinJson = require('./Ballot.json');

var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));

contractName=Object.keys(_abiBinJson.contracts); // reading ['src/Ballot.sol:Ballot']
console.log("- contract name: ", contractName); //or console.log(contractName);

_abiArray=JSON.parse(JSON.stringify(_abiBinJson.contracts[contractName].abi));    //JSON parsing needed!!
_bin="0x"+_abiBinJson.contracts[contractName].bin;
//console.log("- ABI: " + JSON.stringify(_abiArray));
//console.log("- Bytecode: " + _bin);

async function deploy() {
    const accounts = await web3.eth.getAccounts();
    console.log("Deploying the contract from " + accounts[0]);
    var deployed = await new web3.eth.Contract(_abiArray)
        .deploy({data: _bin, arguments: [["0x6b696d", "0x6c6565", "0x6c696d"]]})
        .send({from: accounts[0], gas: 1000000}, function(err, transactionHash) {
                if(!err) console.log("hash: " + transactionHash); 
        })
        //.then(function(newContractInstance){
        //    console.log(newContractInstance.options.address)
        //});
    console.log("---> The contract deployed to: " + deployed.options.address)
}
deploy()
