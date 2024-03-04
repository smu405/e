var _abiJson = require('./Ballot.json');
contractName=Object.keys(_abiJson.contracts); // reading ['src/Ballot.sol:Ballot']
console.log("- contract name: ", contractName); //or console.log(contractName);

_abi=_abiJson.contracts[contractName].abi
_bin=_abiJson.contracts[contractName].bin
console.log("- ABI: ", JSON.stringify(_abi));
console.log("- Bytecode: ", _bin);
