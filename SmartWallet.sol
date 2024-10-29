// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract SmartWallet {
    address payable public owner;
    address[5] public guardians;
    uint256 public guardianApprovalsCount;
    address payable pendingNewOwner;
    mapping(address => uint256) public allownaces;
    mapping(address => mapping(address => bool)) public guardianApprovals;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier onlyGuardian() {
        bool isGuardian = false;
        for (uint256 i = 0; i < guardians.length; i++) {
            if (msg.sender == guardians[i]) {
                isGuardian = true;
                break;
            }
        }
        require(isGuardian, "Not a Guardian");
        _;
    }

    receive() external payable {}

    fallback() external payable {}

    constructor(address[5] memory _guardians) {
        owner = payable(msg.sender);
        guardians = _guardians;
    }

    function setAllowance(address _sender, uint256 _amount) public onlyOwner {
        allownaces[_sender] = _amount;
    }

    function spend(address payable _to, uint256 _amount) public {
        require(
            msg.sender == owner || allownaces[msg.sender] >= _amount,
            "Not allowed"
        );

        if (msg.sender != owner) {
            allownaces[msg.sender] -= _amount;
        }

        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Transaction failed");
    }

    function proposeNewOwner(address payable _newOwner) public onlyOwner {
        pendingNewOwner = _newOwner;
        guardianApprovalsCount = 0;

        for (uint256 i = 0; i < guardians.length; i++) {
            guardianApprovals[guardians[i]][_newOwner] = false;
        }
    }

    function approveNewOwner() public onlyGuardian {
        require(pendingNewOwner != address(0), "No new owner proposed");
        require(
            !guardianApprovals[msg.sender][pendingNewOwner],
            "Guardian already approved"
        );

        guardianApprovals[msg.sender][pendingNewOwner] = true;
        guardianApprovalsCount++;

        if (guardianApprovalsCount >= 3) {
            owner = pendingNewOwner;
            pendingNewOwner = payable(address(0));

            for (uint256 i = 0; i < guardians.length; i++) {
                guardianApprovals[guardians[i]][owner] = false;
            }
        }
    }
}
