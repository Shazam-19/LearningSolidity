// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Order {
    // Enum representing shipping status
    enum Status {
        Pending,  // 0
        Shipped,  // 1
        Accepted, // 2
        Rejected, // 3
        Canceled  // 4
    }

    Status public status; // status default value will be initialized to Pending

    function ship() public {
        require(status == Status.Pending);
        status = Status.Shipped;
    }

    function acceptDelivery() public {
        require(status == Status.Shipped);
        status = Status.Accepted;
    }

    function rejectDelivery() public {
        require(status == Status.Shipped);
        status = Status.Rejected;
    }

    function cancel() public {
        require(status == Status.Pending);
        status = Status.Canceled;
    }
}