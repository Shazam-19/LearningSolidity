// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Examples:
- Declaring arrays (dynamic and fixed-size)
- Using push, pop, and length
- Removing elements from arrays (two approaches)
*/

contract Array {
    // Several ways to initialize an array

    // 1. Dynamic array (can grow or shrink)
    uint256[] public arr;

    // 2. Dynamic array initialized with values
    uint256[] public arr2 = [1, 2, 3];
    
    // Fixed-size array (length is always 10)
    // All elements are initialized to 0 by default (uint256 default value is 0)
    uint256[10] public myFixedSizeArr;

    
    // Returns the element at index `i` from `arr`
    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }


    // Returns the entire array
    // ⚠️ Avoid using this for very large arrays due to gas and memory costs
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }
    
    // Appends a new element to the end of the array
    // Increases array length by 1
    function push(uint256 i) public {
        arr.push(i);
    }

    // Removes the last element of the array
    // Decreases array length by 1
    function pop() public {
        arr.pop();
    }

    // Returns the current number of elements in the array
    function getLength() public view returns (uint256) {
        return arr.length;
    }

    // ⚠️ Does NOT reduce array length, ONLY deletes the element at a given index
    // Instead, it resets the value at that index to the default (0 for uint256)
    function remove(uint256 index) public {
        delete arr[index];

        // Note: we can get the value stored in a specific index in a specific array using arr[index]
        // this is the same index
    }

    // Alternative array for demonstrating compact removal, by copying the last element
    // into the index we want to delete
    uint256[] public compactArray;

    // Removes an element by replacing it with the last element
    // Then removes the last element to keep the array compact
    // ⚠️ This method does NOT preserve order
    function removeCompact(uint256 index) public {
        compactArray[index] = compactArray[compactArray.length - 1];
        compactArray.pop();
    }

    // Test function demonstrating how compact removal works
    function testCompact() public {

        // Initialize array: [1, 2, 3, 4]
        compactArray.push(1);
        compactArray.push(2);
        compactArray.push(3);
        compactArray.push(4);

        // Remove element at index 1 (value = 2)
        // Replace it with last element (4), then remove last
        // Result: [1, 4, 3]
        removeCompact(1);

        // Validate expected results
        assert(compactArray.length == 3);
        assert(compactArray[0] == 1);
        assert(compactArray[1] == 4);
        assert(compactArray[2] == 3);

        // Remove element at index 2 (value = 3)
        // Replace with last element (itself), then remove last
        // Result: [1, 4]
        removeCompact(2);

        // Validate expected results
        assert(compactArray.length == 2);
        assert(compactArray[0] == 1);
        assert(compactArray[1] == 4);

    }

    
    // Example of creating arrays in memory (temporary, not stored on-chain)

    function examples() external pure {
        // create array in memory, only fixed size can be created
        uint256[] memory a = new uint256[](5);

        // create a nested array / 2D array (array of arrays) in memory
        // b = [[1, 2, 3], [4, 5, 6]]
        uint256[][] memory b = new uint256[][](2);

        // Initialize inner arrays
        for (uint256 i = 0; i < b.length; i++) {
            b[i] = new uint256[](3);
        }
        b[0][0] = 1;
        b[0][1] = 2;
        b[0][2] = 3;
        b[1][0] = 4;
        b[1][1] = 5;
        b[1][2] = 6;
    }
    
}
