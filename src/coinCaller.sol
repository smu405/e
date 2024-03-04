contract metaCoin {	
	mapping (address => uint) public balances;
	function metaCoin() {
		balances[msg.sender] = 10000;
	}
	function sendToken(address receiver, uint amount) returns(bool successful){
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		return false;
	}
}

contract coinCaller{
	struct transfer{
		metaCoin coinContract;
		uint amount;
		address recipient;
	}
	mapping(uint => transfer) transfers;
	uint numTransfers;
	function sendCoin(address coinContractAddress, address receiver, uint amount){
		transfer t = transfers[numTransfers]; //Creates a reference t
		t.coinContract = metaCoin(coinContractAddress);
		t.amount = amount;
		t.recipient = receiver;
		t.coinContract.sendToken(receiver, amount);
		numTransfers++;
	}
}
