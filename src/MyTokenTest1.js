var _abiJson = require('./MyToken.json');
contractName=Object.keys(_abiJson.contracts);
console.log("- contract name: ", contractName[4]);

_abi=_abiJson.contracts[contractName[4]].abi
_bin=_abiJson.contracts[contractName[4]].bin
console.log("- ABI: ", _abi);
console.log("- Bytecode: ", _bin);