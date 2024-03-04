var Web3=require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var shelloContract = new web3.eth.Contract([{"constant":true,"inputs":[],"name":"sayHello","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"pure","type":"function"}],
                                      "0x0d3C29cAD3c40497699e13CC34bA099E1fe426Ba");
shelloContract.methods.sayHello().call().then(function(str) {console.log(str);});
