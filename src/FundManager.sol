contract Bank {
    address owner;
    mapping (address => uint) balances;

    function init() returns(bool){
        owner = tx.origin;
        return true;
    }
    // This will take the value of the transaction and add to the senders account.
    function deposit(address customer,uint value) returns (bool res) {
        // If the amount they send is 0, return false.
        balances[customer] += value;
        return true;
    }

    // Attempt to withdraw the given 'amount' of Ether from the account.
    function withdraw(address customer, uint amount) returns (bool res) {
        // Skip if someone tries to withdraw 0 or if they don't have
        // enough Ether to make the withdrawal.
        if (balances[customer] < amount || amount == 0){
            return false;
        }
        balances[customer] -= amount;

        return true;
    }

    function getBalanceOf(address customer) constant returns(uint){
        return balances[customer];
    }
}

contract FundManager {
    address owner;
    Bank bank;

    function init(address bank) returns (bool){
        owner = tx.origin;
        bank = Bank(bank);
        return true;
    }

    function deposit(uint value) returns (bool res) {
        bool success = bank.deposit(tx.origin,value);
        return success;
    }

    function withdraw(uint amount) returns (bool res) {
        bool success = bank.withdraw(msg.sender, amount);
        return success;
    }
}

