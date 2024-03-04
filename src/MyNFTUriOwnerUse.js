var Web3=require('web3');
var _abiBinJson = require('./MyNFTUriOwner.json');      //importing a javascript file

var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8345"));
//var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8345"));
contractName=Object.keys(_abiBinJson.contracts);
console.log("- contract name: ", contractName[12]);
_abiArray=_abiBinJson.contracts[contractName[12]].abi;
//_abiArray=JSON.parse(JSON.stringify(_abi));
//_abiArray=JSON.parse(_abi);      //JSON parsing needed!! //SyntaxError: Unexpected token o in JSON at position 1
_bin="0x"+_abiBinJson.contracts[contractName[12]].bin;
var _nft = new web3.eth.Contract(_abiArray,"0x04F2A101720621B32cFF15cFfD9C15CbBE1cC780");
var event = _nft.events.Transfer({fromBlock: 0}, function (error, result) {
    if (!error) {
        console.log("Event fired: " + JSON.stringify(result.returnValues));
    }
});

async function doIt() {
    const accounts = await web3.eth.getAccounts();
    console.log("(0) Account: " + accounts[0]);
    var owner = await _nft.methods.getOwner().call();
    console.log("(1) owner: "+owner);
    console.log("(2) name: "+await _nft.methods.name().call());
    console.log("(3) symbol: "+await _nft.methods.symbol().call());

    var uri = "https://ipfs.io/ipfs/QmbdwcmzYacLZHLBAhAsaJm2aPV1bzBjFjweD1UgZzkEtA";
    var uri2= "http://example.com";
    var addrTo1 = accounts[1];
    var addrTo2 = accounts[2];
    console.log("(4) minting from "+owner+" to "+addrTo1);
    await _nft.methods.mintWithURI(addrTo1,uri).send({from: accounts[0], gas: 1000000});
    console.log("(5) minting from "+owner+" to "+addrTo2);
    await _nft.methods.mintWithURI(addrTo2,uri).send({from: accounts[0], gas: 1000000});
    var _tid = 1;
    //console.log("(6) [reverted] minting with a duplicate tokenId 1"+" to "+addrTo1);
    //await _nft.methods.mintWithIdURI(_tid,addrTo1,uri).send({from: accounts[0], gas: 1000000});
    console.log("(7) Total number minted: "+await _nft.methods.getTotalSupply().call());
    console.log("(8) balanceOf "+owner+": "+await _nft.methods.balanceOf(owner).call());    
    console.log("(8) balanceOf "+addrTo1+": "+await _nft.methods.balanceOf(addrTo1).call());
    console.log("(8) balanceOf "+addrTo2+": "+await _nft.methods.balanceOf(addrTo2).call());
    console.log("(9) ownerOf tokenId "+_tid+": "+await _nft.methods.ownerOf(_tid).call());
    console.log("(9) tokenURI of tokenId "+_tid+": "+await _nft.methods.tokenURI(_tid).call());
    console.log("(10) [TRANSFER ELSE OWNERSHIP IN NEED OF APPROVAL] owner transfers from addrTo1 to addrTo2");
    console.log("(10) Who gets approved: "+await _nft.methods.getApproved(_tid).call());
    console.log("(10) addrTo1 approves owner to transfer...");
    await _nft.methods.approve(owner, _tid).send({from: addrTo1, gas: 1000000});
    console.log("(10) Now gets approved (addrTo1 --> owner): "+await _nft.methods.getApproved(_tid).call());
    console.log("(10) then enables owner to transfer...")
    await _nft.methods.transferFrom(addrTo1, addrTo2, _tid).send({from: owner, gas: 1000000});
    console.log("(10) ownerOf after transferred: "+await _nft.methods.ownerOf(_tid).call());
    console.log("(11) [TRANSFER SELF OWNERSHIP] transfers mine to else --> no need of approval");
    await _nft.methods.transferFrom(addrTo2, accounts[3], _tid).send({from: addrTo2, gas: 1000000});
    console.log("(11) balanceOf "+owner+": "+await _nft.methods.balanceOf(owner).call());    
    console.log("(11) balanceOf "+addrTo1+": "+await _nft.methods.balanceOf(addrTo1).call());
    console.log("(11) balanceOf "+addrTo2+": "+await _nft.methods.balanceOf(addrTo2).call());
    console.log("(11) balanceOf "+accounts[3]+": "+await _nft.methods.balanceOf(accounts[3]).call());
    console.log("(11) ownerOf after transferred: "+await _nft.methods.ownerOf(_tid).call());
    console.log("(12) Now burns: "+await _nft.methods.burn(_tid).send({from: accounts[3], gas: 1000000}));
    console.log("(12) balanceOf "+accounts[3]+": "+await _nft.methods.balanceOf(accounts[3]).call());
    //process.exit(1); //force exit
}
doIt()
