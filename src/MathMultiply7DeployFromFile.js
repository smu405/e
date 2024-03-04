var Web3=require('web3');
var _abiJson = require('./MathMultiply7ABI.json');
var _binJson = require('./MathMultiply7BIN.json');
//var fs=require('fs');
//var _str = fs.readFileSync("src/MathMultiply7ABI.json");
//var _json=JSON.parse(_str)

//var web3;
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
//if (typeof web3 !== 'undefined') {
//    web3 = new Web3(web3.currentProvider);
//} else {
//    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
//}

contractNames=Object.keys(_abiJson.contracts); //Math, Multiply7
contractName=contractNames[0]; // -> 'src/MathMultiply7.sol:Math', contractNames[1] -> Multiply7
console.log("- contract name: ", contractName);
//_abiArray=JSON.parse(_abiJson.contracts[contractName].abi);    //JSON parsing needed!!
_abiArray=JSON.parse(JSON.stringify(_abiJson.contracts[contractName].abi));    //Unexpected token error
_bin="0x"+_binJson.contracts[contractName].bin;
//_bin=_binJson.contracts[contractName].bin;
//console.log("- ABI: " + _abiArray);
//console.log("- Bytecode: " + _bin);

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
