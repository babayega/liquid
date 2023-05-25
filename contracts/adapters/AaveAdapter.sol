// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/IAdapter.sol";
import "../interfaces/ILendingPoolV3.sol";

contract AaveAdapter is IAdapter {
    /************************************************
     *  IMMUTABLES & CONSTANTS
     ***********************************************/

    /// @notice POOL contract is the LP pool for the stablecoin pair
    address public immutable POOL;

    /// @notice POOL contract is the LP pool for the stablecoin pair
    address public immutable ASSET;

    /**
     * @notice Initializes the contract with immutable variables
     * @param _pool is the AAVE pool
     * @param _asset is the underlying asset contract
     */
    constructor(address _pool, address _asset) {
        require(_pool != address(0), "!_pool");
        require(_asset != address(0), "!_asset");

        POOL = _pool;
        ASSET = _asset;
    }

    /**
     * @notice Deploys the asset to the pool
     * @param _amount is the amount of `asset` to deploy
     */
    function deposit(uint256 _amount) external override {
        // Deposit amount into aave lending pool
        ILendingPoolV3(POOL).supply(ASSET, _amount, address(this), 0);
    }

    /**
     * @notice Withdraws the asset from the pool
     * @param _amount is the amount of `asset` to withdraw
     */
    function withdraw(uint256 _amount) external override {
        // Withdraw amount from the aave pool
        uint256 amountWithdrawn = ILendingPoolV3(POOL).withdraw(
            ASSET,
            _amount,
            msg.sender
        );
        IERC20(ASSET).transfer(msg.sender, amountWithdrawn);
    }

    /**
     * @notice Reader function to get the underlying asset
     */
    function asset() external view override returns (address) {
        return ASSET;
    }
}
