var Web3=require('web3');

//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/65b8df8bc3e84ae29d55984be7dc1d11')); // ropsten
// var web3 = new Web3(new Web3.providers.HttpProvider('https://mainnet.infura.io')); // main

async function doIt() {
    console.log("Account: " + await web3.eth.getAccounts()); //empty
    //console.log("request Account: " + await web3.eth.requestAccounts());
    console.log("Balance E1931: " + await web3.eth.getBalance("0xE1931BF7ec2EcBD176C9b1852b64753878A316c5"));
    console.log("Balance 591c8: " + await web3.eth.getBalance("0x591c86219c77B0Be11a0D57D42DaB6915E2E6f92"));
    console.log("block number: "+await web3.eth.getBlockNumber());
}

doIt()
