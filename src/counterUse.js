var Web3=require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var abi =[{"constant":false,"inputs":[],"name":"add","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"subtract","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCounter","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}];
var addr = "0xb24ab776373e53fFeb9B7298209E195853D2fc8e"; <--- (Z) 위 (C)를 복사-붙여넣기
var counter = new web3.eth.Contract(abi,addr);
counter.methods.getCounter().call().then(function(str) {console.log(str);});
//counter.methods.subtract().send({from:"0x0A815B7818A8e6BC27B430e41Edc8FC455F658c2",gas:100000});
counter.methods.add().send({from:"0x0A815B7818A8e6BC27B430e41Edc8FC455F658c2",gas:100000});
counter.methods.add().send({from:"0x0A815B7818A8e6BC27B430e41Edc8FC455F658c2",gas:100000});
counter.methods.getCounter().call().then(function(str) {console.log(str);});