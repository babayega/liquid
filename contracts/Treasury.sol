// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IAdapter.sol";

contract Treasury is Ownable {
    //
    // MODIFIERS
    //

    modifier onlyValidToken(address _token) {
        require(_token == DAI || _token == USDC, "invalid token");
        _;
    }

    modifier onlyValidAmount(uint256 _amount) {
        require(_amount > 0, "invalid amount");
        _;
    }

    /************************************************
     *  IMMUTABLES & CONSTANTS
     ***********************************************/

    /// @notice USDC contract on the deployed chain
    address public immutable USDC;

    /// @notice DAI contract on the deployed chain
    address public immutable DAI;

    // Percentages are 4-decimal places. For example: 20 * 10**4 = 20%
    uint256 internal constant PERC_MULTIPLIER = 10 ** 4;

    /// @notice adapterAsset holds the assets that are used by the adapters
    mapping(address => address) public adapterAsset;

    /// @notice adapterPerc holds the percentage amount to be deployed to that adapter
    mapping(address => uint16) public adapterPerc;

    /// @notice adapters holds the addresses of the registered adapters
    IAdapter[] private adapters;

    /**
     * @notice Initializes the contract with immutable variables
     * @param _dai is the DAI contract
     * @param _usdc is the USDC contract
     */
    constructor(address _dai, address _usdc) {
        require(_dai != address(0), "!_dai");
        require(_usdc != address(0), "!_usdc");

        DAI = _dai;
        USDC = _usdc;
    }

    /**
     * @notice Deposits the `asset` from msg.sender.
     * @param _token is the type of `asset` to deposit
     * @param _amount is the amount of `asset` to deposit
     */
    function deposit(
        address _token,
        uint256 _amount
    ) external onlyOwner onlyValidToken(_token) onlyValidAmount(_amount) {
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
    }

    /**
     * @notice Withdraws the `asset` to msg.sender.
     * @param _token is the type of `asset` to withdraw
     * @param _amount is the amount of `asset` to withdraw
     */
    function withdraw(
        address _token,
        uint256 _amount
    ) external onlyOwner onlyValidToken(_token) onlyValidAmount(_amount) {
        require(
            IERC20(_token).balanceOf(address(this)) < _amount,
            "withdraw deployed liquidity"
        );

        IERC20(_token).transfer(msg.sender, _amount);
    }

    /**
     * @notice Deploys the token into adapters based on the percentage set by the owner
     * @param _token is the type of `asset` to deploy
     * @param _amount is the amount of `asset` to deploy
     */
    function deployLiquidity(
        address _token,
        uint256 _amount
    ) external onlyOwner onlyValidToken(_token) {
        // 1. Iterate through the adapters
        for (uint256 index = 0; index < adapters.length; index++) {
            // 2. If the adapter has same underlying token and perc > 0, call the deposit method
            if (
                adapterAsset[address(adapters[index])] == _token &&
                adapterPerc[address(adapters[index])] > 0
            ) {
                //Calculate amount to be transferred
                uint256 sendAmount = (_amount *
                    adapterPerc[address(adapters[index])]) / PERC_MULTIPLIER;

                //Transfer the amount
                IERC20(_token).transfer(address(adapters[index]), _amount);

                //Call the deposit function on the adapter
                adapters[index].deposit(sendAmount);
            }
        }
    }

    /**
     * @notice Removes the liquidity deployed by adapters
     * @param _adapter is the adapter to remove the liquidity from
     * @param _amount is the amount of `asset` to remove
     */
    function removeLiquidity(
        address _adapter,
        uint256 _amount
    ) external onlyOwner {
        IAdapter(_adapter).withdraw(_amount);
    }

    /**
     * @notice add aadapter address to the list
     * @param _adapter IAdapter address
     */
    function addAdapter(IAdapter _adapter) public onlyOwner {
        require(
            adapterAsset[address(_adapter)] == address(0),
            "adpater already added"
        );

        adapterAsset[address(_adapter)] = _adapter.asset();
        adapterPerc[address(_adapter)] = 0;

        adapters.push(_adapter);
    }

    /**
     * @notice remove aadapter address to the list
     * @param _adapter IAdapter address
     */
    function removeAdapter(IAdapter _adapter) public onlyOwner {
        require(
            adapterAsset[address(_adapter)] != address(0),
            "adpater already removed"
        );

        adapterAsset[address(_adapter)] = address(0);
        adapterPerc[address(_adapter)] = 0;
    }
}
