// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IAdapter {
    function deposit(uint256) external;

    function withdraw(uint256) external;

    function asset() external returns (address);
}
