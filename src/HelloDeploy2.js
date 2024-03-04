var Web3=require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8445"));
//web3.eth.personal.unlockAccount("0x21c70...생략...7451","password",1000).then(console.log('unlocked!'));
var shelloContract = new web3.eth.Contract([{"constant":true,"inputs":[],"name":"sayHello","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"pure","type":"function"}]);
shelloContract
    .deploy({
            data: '0x608060405234801561001057600080fd5b50610139806100206000396000f3fe608060405234801561001057600080fd5b5060043610610048576000357c010000000000000000000000000000000000000000000000000000000090048063ef5fb05b1461004d575b600080fd5b6100556100d0565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561009557808201518184015260208101905061007a565b50505050905090810190601f1680156100c25780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60606040805190810160405280600b81526020017f48656c6c6f20576f726c6400000000000000000000000000000000000000000081525090509056fea165627a7a72305820992c2f4c73a27b9eb53c6aa7b52ba8a5eddba258089eb7d1a3710711703459950029', 
    })
    .send({
     from: "0xC8Ea4C4e655F8152aDC075a649AA7ec35564C7C0",
     gas: '4700000'
    }, function (error, transactionHash){ 
            console.log(error, transactionHash); 
    })
    .on('transactionHash', function(error,transactionHash) {
            console.log("hash-- "+transactionHash);
    })
    .on('receipt', function(receipt) {
            console.log('receipt:: '+receipt.contractAddress);
    })
    .then(function(newContractInstance){
            console.log(newContractInstance.options.address)
    });
