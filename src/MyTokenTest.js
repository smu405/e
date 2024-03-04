var _abiJson = require('./MyToken.json');
contractName=Object.keys(_abiJson.contracts); 
console.log("- contract name: ", contractName[4]); //reading src/MyToken.sol:MyToken
