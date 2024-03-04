var Web3=require('web3');
//var web3=new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
var web3=new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));
var _abiBinJson = require('./Ballot.json');
contractName=Object.keys(_abiBinJson.contracts); // reading ['src/Ballot.sol:Ballot']
console.log("- contract name: ", contractName); //or console.log(contractName);
_abiArray=JSON.parse(JSON.stringify(_abiBinJson.contracts[contractName].abi));    //JSON parsing needed!!
var ballot = new web3.eth.Contract(_abiArray, '0x0D35Ab6f840fD5d3A636EdA6986308498456A764');
var event = ballot.events.Voted({fromBlock: 0}, function (error, result) {
    if (!error) {
        console.log("Event fired: " + JSON.stringify(result.returnValues));
        console.log("address: "+result.returnValues._address+" proposal: "+result.returnValues._proposal);
        //console.log("voted and proposal"+ballot.methods.voters(result.returnValues._address)); //NO access the state variable
    }
});

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("Account0: " + accounts[0]);
    const balance0Before = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 before: " + balance0Before);
    const balance1Before = await web3.eth.getBalance(accounts[1]);
    console.log("Balance1 before: " + balance1Before);

    ballot.methods.winningProposal().call().then(function(p) {
        console.log("wining proposal before: " + p);
    });
    ballot.methods.winnerName().call().then(function(n) {
        console.log("winner before: " + n);
    });    
    //await ballot.methods.vote(accounts[3], 0).send({from: accounts[0],gas:800000});
    //await ballot.methods.vote(accounts[4], 1).send({from: accounts[1],gas:800000});
    //await ballot.methods.vote(accounts[5], 1).send({from: accounts[2],gas:800000});
    //await ballot.methods.vote(accounts[6], 1).send({from: accounts[6], gas:800000}, function (error, tranHash) {
    //    console.log("tranHash: " + tranHash);
    //});
    //ballot.methods.vote("0x18",1).send({from: accounts[0], gas:800000},function (error, tranHash) {
    ballot.methods.vote("0x241A076eE90E5703952C70c7cCe43d4388C8De4f",1).send({from: accounts[0], gas:800000},function (error, tranHash) {
        if (!error) {
            console.log("voted. transaction hash ===> ",tranHash);
        }
    });
    ballot.methods.getNVoted().call().then(function(n) {
        console.log("how many voted: " + n);
    });
    ballot.methods.winningProposal().call().then(function(p) {
        console.log("wining proposal after: " + p);
    });
    ballot.methods.winnerName().call().then(function(n) {
        console.log("winner after: " + n);
    });
    ballot.methods.getNVoted().call().then(function(n) {
        console.log("how many voted: " + n);
    });
    const balance0After = await web3.eth.getBalance(accounts[0]);
    console.log("Balance0 after: " + balance0After);
    console.log("Balance0 diff: " + (balance0After - balance0Before));
    const balance1After = await web3.eth.getBalance(accounts[1]);
    console.log("Balance1 after: " + balance1After);
    console.log("Balance1 diff: " + (balance1After - balance1Before));
}
doIt()
