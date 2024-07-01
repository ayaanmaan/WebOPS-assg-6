// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GradeBook {
    struct Grade {
        string studentName;
        string subject;
        uint256 grade;
    }

    Grade[] public grades;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function addGrade(string memory _studentName, string memory _subject, uint256 _grade) public onlyOwner {
        grades.push(Grade(_studentName, _subject, _grade));
    }

    function updateGrade(uint256 _index, uint256 _newGrade) public onlyOwner {
        require(_index < grades.length, "Invalid grade index");
        grades[_index].grade = _newGrade;
    }

    function getGrade(string memory _studentName, string memory _subject) public view returns (uint256) {
        for (uint256 i = 0; i < grades.length; i++) {
            if (keccak256(abi.encodePacked(grades[i].studentName)) == keccak256(abi.encodePacked(_studentName)) &&
                keccak256(abi.encodePacked(grades[i].subject)) == keccak256(abi.encodePacked(_subject))) {
                return grades[i].grade;
            }
        }
        revert("Grade not found");
    }

    function averageGrade(string memory _subject) public view returns (uint256) {
        uint256 total = 0;
        uint256 count = 0;
        
        for (uint256 i = 0; i < grades.length; i++) {
            if (keccak256(abi.encodePacked(grades[i].subject)) == keccak256(abi.encodePacked(_subject))) {
                total += grades[i].grade;
                count++;
            }
        }
        
        require(count > 0, "No grades found for the subject");
        return total / count;
    }
}
