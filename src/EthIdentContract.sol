/* ****************************************************
*  A contract to support the Record Validation Oracle  *
*******************************************************/
/** ADRESS **/
/*
0x954eD964093195Da674c4D1D291680ED3C4E5160
*/

contract RecordVerifier {

  /* Events fired when a payment comes in. We try to be max honest and return money in case we don't expect it*/
  event PaymentPending(address forAddress, address byAddress, bytes32 recordSha3Hash, bytes32 externalTxId);
  event PaymentAccepted(address forAddress, address byAddress, bytes32 recordSha3Hash, uint256 amount, bytes32 externalTxId);
  event RecordRegistered(address forAddress, address byAddresss, uint recordType, bytes32 recordSha3Hash, bool captchaPassed, uint timestamp, bytes32 externalTxId);
  event Transfer(address beneficary, uint256 amount);

  /* Events in case of error. Basically warnings. */
  event PaymentAlreadyPending(address forAddress, address byAddress, bytes32 recordSha3Hash, bytes32 externalTxId);
  event AlreadyPaid(address forAddress, address byAddress, bytes32 externalTxId);
  event NoPendingPayment(address forAddress, address byAddress, bytes32 externalTxId);
  event NoAcceptedPayment(address forAddress, address byAddress, bytes32 recordSha3Hash, bytes32 externalTxId);
  event ZeroPaymentNotSupported(address forAddress, bytes32 externalTxId);
  event InsufficientFunds(address forAddress, bytes32 externalTxId);
  event Refund(address forAddress, uint amount, bytes32 externalTxId);

  /* The person or contract which can modify the register */
  address public controller;

  /* The price of the service. Subject to change by the controller*/
  uint256 public servicePrice;
  uint256 public servicePriceCompanies;

  /* Global validity period for validated records. */
  uint public validityPeriod;

  /* The structure of the record */
  struct RecordInfo {
    uint recordType;
    bytes32 recordHash;
    uint timestamp;
    uint validity;
    bool captchaRequired;
    bool captchaPassed;
    string provider;
  }

  /* The structure of the payment record */
  struct PaymentInfo {
    bytes32 recordHashIntent; // optional
    address paidFor;
    address paidBy;
    uint256 amount;
    uint timestamp;
    bool refunded;
    bytes32 externalTxId;
    uint state; // 0 - no pending payment, 1 - pending payment, 2 - accepted payment
  }

  /* *******************************************************
  *  Storage of hashes corresponding to user addresses     *
  * *******************************************************/
  mapping(address => RecordInfo[]) recordRegister;
  mapping(address => PaymentInfo) paymentRegister;

   /* Someone may be interested in getting information about core register params changes */
  event SetValidity(uint oldValidity, uint newValidity);
  event SetServicePrice(uint256 oldPrice, uint servicePrice);
  event SetServicePriceCompanies(uint256 oldPrice, uint servicePrice);
  event SetController(address oldController, address newController);

  /* Modifier for access control. Only the controller can operate. */
  modifier onlyController {
    if (msg.sender != controller) throw;
    _
  }

  /* Initialize contract with controller and service price. */
  function RecordVerifier(address registerController, uint256 defaultServicePrice, uint defaultValidityPeriod) {
      if (registerController == 0) registerController = msg.sender;
      controller = registerController;
      if (defaultServicePrice == 0) defaultServicePrice = 10 finney; //0.01 ether
      servicePrice = defaultServicePrice;
      servicePriceCompanies = defaultServicePrice;
      if (defaultValidityPeriod ==0) defaultValidityPeriod = 31536000; // 1 year
      validityPeriod = defaultValidityPeriod;
   }


  /* Default execution function. We accept payments through it for individual users. */
  function() {
      payForAddress(msg.sender, sha3(msg.sender, msg.value));
  }

  /* Accept payments from companies paying for their customers */
  function payForAddress(address userAddress, bytes32 externalTxId) {

      var payer = msg.sender;

      if (msg.value == 0) {
         ZeroPaymentNotSupported(msg.sender, externalTxId);
         return;
      }

      bool paymentValid = true;
      uint _servicePrice = servicePrice;

      if(userAddress != msg.sender) {
        _servicePrice = servicePriceCompanies;
      }

      /* Not enough funds sent to complete the procedure? */
      if (msg.value < _servicePrice) {
          paymentValid = false;
          InsufficientFunds(msg.sender, externalTxId); //inform oracle of unsuccessful payment
      }

      /* We are expecting payment from that address. Get info from the payment register. */
      PaymentInfo paymentInfo = paymentRegister[userAddress];

      if ((paymentInfo.state == 0)||(paymentInfo.state == 3)) {
          paymentValid = false;
          NoPendingPayment(userAddress, payer, externalTxId);
      }

      if (paymentInfo.state == 2) {
          paymentValid = false;
          AlreadyPaid(userAddress, msg.sender, externalTxId); //inform oracle of unsuccessful payment
      }

      /* At this point it should be clear if the payment is valid or not. */
      if (!paymentValid) {
          msg.sender.call.value(msg.value)(0); // refund
          paymentInfo.refunded = true;
          paymentInfo.timestamp = block.timestamp;
          Refund(msg.sender, msg.value, externalTxId);
      } else {
          /* Return any money paid above the service price. Be honest. */
          if (msg.value > _servicePrice) {
             msg.sender.call.value(msg.value - _servicePrice)(0);
          }
          paymentInfo.state = 2;
          paymentInfo.timestamp = block.timestamp;
          paymentRegister[userAddress] = paymentInfo;
          PaymentAccepted(userAddress, msg.sender, paymentInfo.recordHashIntent, msg.value, externalTxId); // inform oracle of successful payment
      }

  }

  function registerPendingPayment(address userAddress, address payer, bytes32 recordSha3Hash, bytes32 externalTxId) onlyController {
      PaymentInfo paymentInfo = paymentRegister[userAddress];
      bool newRecord = paymentInfo.recordHashIntent != recordSha3Hash;
      bool newPaymentProcess = (((paymentInfo.state == 1) || (paymentInfo.state == 2))&&newRecord);
      uint _servicePrice = servicePrice;
      if (userAddress != payer) {
        _servicePrice = servicePriceCompanies;
      }
      if ((paymentInfo.state == 0)||(paymentInfo.state == 3)||(newPaymentProcess)) {
        paymentInfo.state = 1;
        paymentInfo.paidFor = userAddress;
        paymentInfo.paidBy = payer;
        paymentInfo.recordHashIntent = recordSha3Hash;
        paymentInfo.amount = _servicePrice;
        paymentInfo.timestamp = block.timestamp;
        paymentInfo.externalTxId = externalTxId;
        PaymentPending(userAddress, payer, recordSha3Hash, externalTxId);
      } else if (paymentInfo.state == 1) {
        PaymentAlreadyPending(paymentInfo.paidFor, paymentInfo.paidBy, paymentInfo.recordHashIntent, externalTxId);
      }
  }

  /* Oracle will execute this after successful validation */
  function registerRecord(address userAddress, uint typeOfRecord, bytes32 recordSha3Hash, bool captchaPassed, bool captchaRequired, string provider, bytes32 externalTxId) onlyController {
      PaymentInfo paymentInfo = paymentRegister[userAddress];
      if ((paymentInfo.state == 2)&&(paymentInfo.recordHashIntent == recordSha3Hash)&&(recordSha3Hash != 0)) {
         RecordInfo[] recordDataA = recordRegister[userAddress];
         var recordId = recordDataA.length++;
         RecordInfo recordData = recordDataA[recordId];
         recordData.recordType = typeOfRecord;
         recordData.recordHash = recordSha3Hash;
         recordData.timestamp = block.timestamp;
         recordData.validity = block.timestamp + validityPeriod; // 1 year validity
         recordData.captchaPassed = captchaPassed;
         recordData.captchaRequired = captchaRequired;
         recordData.provider = provider;
         paymentInfo.state = 3; // process complete
         RecordRegistered(userAddress, paymentInfo.paidBy,  recordData.recordType, recordSha3Hash, recordData.captchaPassed, recordData.validity, externalTxId);
      } else {
         NoAcceptedPayment(paymentInfo.paidFor, paymentInfo.paidBy, recordData.recordHash, externalTxId);
      }
  }

  /* Other users or services on the blockchain may execute this to check if record is verified. Costs 0. */
  function isRecordVerified(address userAddress, uint recordType, bytes32 recordSha3Hash) constant returns (bool verified) {
      RecordInfo[] recordInfoA = recordRegister[userAddress];
      verified = false;
      for (uint i = 0; i < recordInfoA.length; i++) {
        RecordInfo recordInfo = recordInfoA[i];
        verified = ((recordInfo.recordHash == recordSha3Hash) && (recordInfo.recordType == recordType) && (recordSha3Hash != 0));
        if (verified) break;
      }
  }

  /* Returns the expiration date if the record is validated. Returns 0 if the record is not verified or invalid. */
  function getRecordValidity(address userAddress, uint recordType, bytes32 recordSha3Hash) constant returns (uint validity) {
      RecordInfo[] recordInfoA = recordRegister[userAddress];
      validity = 0;
      for (uint i = 0; i < recordInfoA.length; i++) {
        RecordInfo recordInfo = recordInfoA[i];
        bool valid = ((recordInfo.validity > block.timestamp) && (recordInfo.recordType == recordType) && (recordInfo.recordHash == recordSha3Hash));
        if (valid) {
          validity = recordInfo.validity;
        }
      }
  }

  /* Checks if a record is both verified and yet valid. */
  function isRecordValid(address userAddress, uint recordType, bytes32 recordSha3Hash) constant returns (bool valid) {
    valid = (getRecordValidity(userAddress, recordType, recordSha3Hash) > block.timestamp);
  }

  /* Allows to check if user has passed captcha for a specific record */
  function isRecordCaptchaPassed(address userAddress, uint recordType, bytes32 recordSha3Hash) constant returns (bool captchaPassed) {
    RecordInfo[] recordInfoA = recordRegister[userAddress];
    captchaPassed = false;
    for (uint i = 0; i < recordInfoA.length; i++) {
      RecordInfo recordInfo = recordInfoA[i];
      bool valid = ((recordInfo.recordType == recordType) && (recordInfo.recordHash == recordSha3Hash));
      if (valid) {
        captchaPassed = recordInfo.captchaPassed;
      }
    }
  }

  function isPaymentPending(address userAddress, bytes32 recordSha3Hash) constant returns (bool pending) {
      PaymentInfo paymentInfo = paymentRegister[userAddress];
      pending = ((paymentInfo.state == 1) && (paymentInfo.recordHashIntent == recordSha3Hash) && (recordSha3Hash != 0));
  }

  function resetPaymentState(address userAddress) onlyController {
      PaymentInfo paymentInfo = paymentRegister[userAddress];
      paymentInfo.state = 0;
  }

  /* Checks if payment is in status accepted */
  function isPaymentAccepted(address userAddress, bytes32 recordSha3Hash) constant returns (bool accepted) {
      PaymentInfo paymentInfo = paymentRegister[userAddress];
      accepted = ((paymentInfo.state == 2)&&(paymentInfo.recordHashIntent == recordSha3Hash));
  }

  /* Returns the ratio [captchas passed : captchas required] */
  function isHuman(address userAddress) constant returns (uint humanOperator){
    RecordInfo[] recordInfoA = recordRegister[userAddress];
    uint captchas = 0;
    uint records = 0;
    for (uint i = 0; i < recordInfoA.length; i++) {
      RecordInfo recordInfo = recordInfoA[i];
      if (recordInfo.captchaRequired) {
        records++;
        if (recordInfo.captchaPassed) captchas++;
      }
    }
    if (records == 0) {
      humanOperator = 0;
    } else {
      humanOperator = (captchas * 100) / records;
    }
  }

  /* Selecting a new price. Fires respective event. */
  function setServicePrice(uint256 newPrice) onlyController {
      var oldPrice = servicePrice;
      servicePrice = newPrice;
      SetServicePrice(oldPrice, servicePrice);
  }

  /* Selecting a new price for companies. Fires respective event. */
  function setServicePriceCompanies(uint256 newPrice) onlyController {
      var oldPrice = servicePriceCompanies;
      servicePriceCompanies = newPrice;
      SetServicePriceCompanies(oldPrice, servicePriceCompanies);
  }

  /* Selecting a new register controller. Fires respective event. */
  function setController(address newController) onlyController {
      var oldController = controller;
      controller = newController;
      SetController(oldController, controller);
  }

  /* Change global validity period. Fire event. */
  function setValidity(uint newValidityPeriod) onlyController {
      var oldValidityPeriod = validityPeriod;
      validityPeriod = newValidityPeriod;
      SetValidity(oldValidityPeriod, newValidityPeriod);
  }

   /* Transfer funds from the contract to the owner */
  function transfer(uint256 amount) onlyController {
    if (amount > this.balance) {
      amount = this.balance;
    }
    msg.sender.call.value(amount)(0);
    Transfer(msg.sender, amount);
  }

}

/***************************/
/* Contract JSON Interface */
/***************************/
/*
[
  {
    "constant": true,
    "inputs": [

    ],
    "name": "servicePriceCompanies",
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "value": "10000000000000000"
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "transfer",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [

    ],
    "name": "validityPeriod",
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "value": "31536000"
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "recordType",
        "type": "uint256"
      },
      {
        "name": "recordSha3Hash",
        "type": "bytes32"
      }
    ],
    "name": "isRecordValid",
    "outputs": [
      {
        "name": "valid",
        "type": "bool",
        "value": false
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "payForAddress",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "recordSha3Hash",
        "type": "bytes32"
      }
    ],
    "name": "isPaymentAccepted",
    "outputs": [
      {
        "name": "accepted",
        "type": "bool",
        "value": false
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      }
    ],
    "name": "resetPaymentState",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "payer",
        "type": "address"
      },
      {
        "name": "recordSha3Hash",
        "type": "bytes32"
      },
      {
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "registerPendingPayment",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "newController",
        "type": "address"
      }
    ],
    "name": "setController",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "recordType",
        "type": "uint256"
      },
      {
        "name": "recordSha3Hash",
        "type": "bytes32"
      }
    ],
    "name": "isRecordCaptchaPassed",
    "outputs": [
      {
        "name": "captchaPassed",
        "type": "bool",
        "value": false
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "typeOfRecord",
        "type": "uint256"
      },
      {
        "name": "recordSha3Hash",
        "type": "bytes32"
      },
      {
        "name": "captchaPassed",
        "type": "bool"
      },
      {
        "name": "captchaRequired",
        "type": "bool"
      },
      {
        "name": "provider",
        "type": "string"
      },
      {
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "registerRecord",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "recordType",
        "type": "uint256"
      },
      {
        "name": "recordSha3Hash",
        "type": "bytes32"
      }
    ],
    "name": "isRecordVerified",
    "outputs": [
      {
        "name": "verified",
        "type": "bool",
        "value": false
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "newPrice",
        "type": "uint256"
      }
    ],
    "name": "setServicePriceCompanies",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "newValidityPeriod",
        "type": "uint256"
      }
    ],
    "name": "setValidity",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [

    ],
    "name": "servicePrice",
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "value": "10000000000000000"
      }
    ],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "newPrice",
        "type": "uint256"
      }
    ],
    "name": "setServicePrice",
    "outputs": [

    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "recordSha3Hash",
        "type": "bytes32"
      }
    ],
    "name": "isPaymentPending",
    "outputs": [
      {
        "name": "pending",
        "type": "bool",
        "value": false
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      }
    ],
    "name": "isHuman",
    "outputs": [
      {
        "name": "humanOperator",
        "type": "uint256",
        "value": "0"
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [

    ],
    "name": "controller",
    "outputs": [
      {
        "name": "",
        "type": "address",
        "value": "0x649ca15a60e94b13139167511c2855626835708a"
      }
    ],
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "userAddress",
        "type": "address"
      },
      {
        "name": "recordType",
        "type": "uint256"
      },
      {
        "name": "recordSha3Hash",
        "type": "bytes32"
      }
    ],
    "name": "getRecordValidity",
    "outputs": [
      {
        "name": "validity",
        "type": "uint256",
        "value": "0"
      }
    ],
    "type": "function"
  },
  {
    "inputs": [
      {
        "name": "registerController",
        "type": "address",
        "index": 0,
        "typeShort": "address",
        "bits": "",
        "displayName": "register Controller",
        "template": "elements_input_address",
        "value": "0x649ca15a60e94b13139167511c2855626835708a"
      },
      {
        "name": "defaultServicePrice",
        "type": "uint256",
        "index": 1,
        "typeShort": "uint",
        "bits": "256",
        "displayName": "default Service Price",
        "template": "elements_input_uint",
        "value": ""
      },
      {
        "name": "defaultValidityPeriod",
        "type": "uint256",
        "index": 2,
        "typeShort": "uint",
        "bits": "256",
        "displayName": "default Validity Period",
        "template": "elements_input_uint",
        "value": ""
      }
    ],
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "byAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "recordSha3Hash",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "PaymentPending",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "byAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "recordSha3Hash",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "name": "amount",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "PaymentAccepted",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "byAddresss",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "recordType",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "recordSha3Hash",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "name": "captchaPassed",
        "type": "bool"
      },
      {
        "indexed": false,
        "name": "timestamp",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "RecordRegistered",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "beneficary",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "Transfer",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "byAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "recordSha3Hash",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "PaymentAlreadyPending",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "byAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "AlreadyPaid",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "byAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "NoPendingPayment",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "byAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "recordSha3Hash",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "NoAcceptedPayment",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "ZeroPaymentNotSupported",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "InsufficientFunds",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "forAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "amount",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "externalTxId",
        "type": "bytes32"
      }
    ],
    "name": "Refund",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "oldValidity",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "newValidity",
        "type": "uint256"
      }
    ],
    "name": "SetValidity",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "oldPrice",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "servicePrice",
        "type": "uint256"
      }
    ],
    "name": "SetServicePrice",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "oldPrice",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "servicePrice",
        "type": "uint256"
      }
    ],
    "name": "SetServicePriceCompanies",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "oldController",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "newController",
        "type": "address"
      }
    ],
    "name": "SetController",
    "type": "event"
  }
]
*/
