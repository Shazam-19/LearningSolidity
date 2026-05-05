// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
call - low level method available on address type

Examples:
- call existing function in a contract
- call non-existing fcuntion (triggers the fallback function)

Note: It's not recommended to use 'call' to call other functions
*/

contract Reciever {
    event Received(address caller, uint256 amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    function foo(string memory _message, uint256 _x) public payable returns (uint256) {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }

    // Ether is accepted and added to contract balance
    receive() external payable {}

}

contract Caller {

    event Responce(bool success, bytes data);

    // Let's imagine that contract Caller does not have the source code for the
    // contract Receiver, but we do know the address of contract Receiver and the function to call.
    function textCallFoo(address payable _address) public payable {
        
        // You can send ether and specify a custom gas amount
        (bool success, bytes memory data) = _address.call{
            value: msg.value,
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));

        emit Responce(success, data);
    }


    function testCallDoesNotExist(address payable _address) public payable {
        
        // You can send ether and specify a custom gas amount
        (bool success, bytes memory data) = _address.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Responce(success, data);
    }
}