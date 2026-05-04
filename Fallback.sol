// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
The fallback function is a special function that's executed when:
1. A function that does not exist is called
2. Ether is sent to the contract and:
   - receive() does not exist, OR
   - msg.data is NOT empty

Fallback function:
- transfer/send → forward 2300 gas (very limited)
- call → forwards all gas (default)thod

It’s not recommended to include extensive logic inside the fallback function,
since operations like transfer and send can fail.

Best practices:
- Keep fallback logic minimal
- Avoid heavy computations to reduce the risk of failure

*/


contract Fallback {

    // Event to log which function was triggered and remaining gas
    event Log(string func, uint256 gas);

    /*
    fallback():
    - Called when:
        • Function does not exist
        • OR msg.data is not empty
    - Must be 'external'
    - Must be 'payable' to receive Ether
    */
    fallback() external payable {

        // gasleft() returns remaining gas at this point in execution
        emit Log("fallback", gasleft());

    }


    /*
    receive():
    - Called when:
        • Ether is sent
        • AND msg.data is empty
    - Preferred way to receive plain Ether transfers
    */    receive() external payable {

        emit Log("receive", gasleft());

    }


    // Returns the Ether balance of this contract
    function getBalance() public view returns (uint256) {

        return address(this).balance;

    }
}


contract SendToFallback {

    // Sends Ether using transfer()
    function transferToFallback(address payable _to) public payable {

        // Forwards 2300 gas → likely triggers receive() if msg.data is empty
        _to.transfer(msg.value);

    }

    // Sends Ether using call()
    function callFallback(address payable _to) public payable {

        // Empty data "" → triggers:
        // - 'receive()' (if exists),
        // - otherwise 'fallback()' (if receive doesn't exist)
        (bool sent,) = _to.call{value: msg.value}("");

        require(sent, "Failed to send Ether");

    }
}
