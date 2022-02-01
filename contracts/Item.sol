pragma solidity ^0.8.0;

import "./ItemManager.sol";

contract Item {
    uint public pricePaid;
    uint public priceInWei;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        // in order to get gas we must use a low order function.
        // in this case we will do a boolean to say if the transaction was successful
        (bool success, ) = address(parentContract).call{value: msg.value }(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction wasnt' successful canceling");
    }

    fallback() external {

    }
}