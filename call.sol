// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Low-level call in Solidity

Key Concepts:
- `call` is a low-level function available on all addresses
- It allows interaction with other contracts without requiring their interface
- It is flexible but unsafe compared to high-level function calls

Use cases:
- Calling existing functions on another contract
- Calling non-existing functions (triggers fallback)
- Sending Ether with custom gas control

⚠️ Best Practice:
Avoid using `call` unless necessary, as it bypasses compile-time checks.
*/

contract Reciever {

    // Event emitted when either foo(), fallback(), or receive() is triggered
    event Received(address caller, uint256 amount, string message);

    /*
    fallback():
    - Triggered when:
        • Function does not exist
        • OR calldata does not match any function signature
    - Can receive Ether since it's marked as payable
    */
    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }


    /*
    Example function that can be called via low-level call
    - Accepts Ether
    - Returns input value + 1
    */
    function foo(string memory _message, uint256 _x) public payable returns (uint256) {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }

    /*
    receive():
    - Triggered when Ether is sent with empty calldata
    - Used for plain Ether transfers
    */
    receive() external payable {}

}

contract Caller {

    // Event to log success/failure of low-level calls and returned data
    event Responce(bool success, bytes data);


    /*
    Calls the `foo` function on another contract using low-level call

    Key Points:
    - We manually encode the function signature using ABI encoding
    - We send Ether along with the call
    - We optionally limit gas usage
    */
    function textCallFoo(address payable _address) public payable {
        
        // Low-level call to function foo(string,uint256)
        // "call foo" and 123 are the arguments passed to foo()
        (bool success, bytes memory data) = _address.call{
            value: msg.value,
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));

        emit Responce(success, data);
    }


    /*
    Calls a non-existent function on the target contract

    Behavior:
    - Since function does not exist, fallback() is triggered on receiver
    - No compile-time validation of function existence
    */
    function testCallDoesNotExist(address payable _address) public payable {
        
        // You can send ether and specify a custom gas amount
        (bool success, bytes memory data) = _address.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Responce(success, data);
    }
}