var Web3=require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://117.16.44.45:8345"))
async function sendEth() {
    var ac;
    try {
        ac = await web3.eth.getAccounts(function(err,addr) {
            console.log("AWAIT: "+addr);
        });
        console.log("OUT AWAIT: "+ac);
        var hash=web3.eth.sendTransaction({from:ac[0],to:ac[1],value:1111})
        web3.eth.getTransactionReceipt(hash);
    } catch(err) {
        console.log(err);
    }
    return ac;
}
var myAddr0=sendEth();
console.log("--After: "+myAddr0)
