// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*

Another way to call other contracts is to use the low-level call.

This method is not recommended.
*/

/*
Calling Other Contracts
-----------------------
A contract can interact with another contract in 2 ways:

1. Direct function calls
   Example:
   - contractA.someFunction(x, y, x)

2. Low-level calls using .call()
   - Commonly used for advanced interactions and proxy patterns
   - More flexible, but less safe and harder to debug because .call() does not automatically
     bubble up errors or enforce type checking.
   - It returns (bool success, bytes memory data) instead of reverting automatically,
     unlike direct function calls, so failures must be checked manually.

This example demonstrates direct contract-to-contract calls.
*/

contract Callee {

    // Stores a number
    uint256 public x;

    // Stores the amount of ETH received
    uint256 public value;

    // Updates the value of x.
    // Returns the updated value of x
    function setX(uint256 _x) public returns (uint256) {
        x = _x;

        // Returned so the calling contract can assign and use the returned value.
        return x; 
    }


    /*
    Updates x and stores received ETH.

    'payable' Allows this function to receive ETH.

    Returns:
    - Updated x value
    - ETH amount received
    */
    function setXandSendEther(uint256 _x) 
        public
        payable
        returns (uint256, uint256)
    {
        x = _x;
        value = msg.value; // msg.value = amount of ETH sent with the transaction

        return (x, value);
    }
}




contract Caller {

    // Calls setX() using a contract instance.
    // Example: Pass the deployed Callee contract directly.
    function setX(Callee _callee, uint256 _x) public {
        uint256 x = _callee.setX(_x);
    }

    // Calls setX() using a contract address.
    // Useful when only the deployed contract address is known.
    function setXFromAddress(address _addr, uint256 _x) public {

        // Create a Callee contract object for the given address
        Callee callee = Callee(_addr);

        // Call function on the target contract
        callee.setX(_x);
    }

    // Calls setXandSendEther() and forwards ETH.
    // 'payable' Allows this function to receive ETH before forwarding it.
    function setXandSendEther(Callee _callee, uint256 _x) public payable {

        // Forward ETH using {value: msg.value}
        (uint256 x, uint256 value) =
                    _callee.setXandSendEther{value: msg.value}(_x);

        // The '{value: msg.value}' forwards ETH to the target contract.
    }
}

