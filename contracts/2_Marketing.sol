// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./base/TokenVesting.sol";

contract MarketingVesting is TokenVesting {

  uint256 internal constant _duration = 30*9 days; // 9 months of vesting
  uint256 internal constant _initialReleasePercentage = 10;

  constructor ( 
    address _DOGSaddress, 
    address _beneficiary, 
    uint256 _start,
    uint256 _amount 
  ) TokenVesting(
    _DOGSaddress,
    _start,
    _duration,
    _initialReleasePercentage,
    _beneficiary,
    _amount
  ){}
}