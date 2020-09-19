pragma solidity 0.6.1;

import "./ItemManager.sol";

contract Item {
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract ,uint _priceInWei, uint _index) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }
    
    receive() external payable {
        require(priceInWei == msg.value, "Only full payments are allowed");
        require(pricePaid == 0, "Item is paid already.");
        pricePaid += msg.value;
        (bool sucess, ) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)", index)); // This is a low level function to execute specific method of a contract, here we are sending a value for payment against a specific Product
        require(sucess, "The Transaction wasn't sucessfull, canceling"); // This statment is responsible for executing a Transaction sucessfull
    }
    
    fallback () external {
    }
}