// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenVesting {

  IERC20 public DOGS;
  address public beneficiary;
  uint256 public start;
  uint256 public allocatedTokens;
  uint256 public claimedTokens;
  uint256 public duration;
  uint256 public initialReleasePercentage;

  event TokensClaimed(address beneficiary, uint256 value);
  event TokensAllocated(address beneficiary, uint256 value);

  constructor ( 
    address _DOGSaddress, 
    uint256 _start,
    uint256 _duration,
    uint256 _initialReleasePercentage,
    address _beneficiary, 
    uint256 _amount 
  ) {
    DOGS = IERC20(_DOGSaddress);
    start = _start;
    duration = _duration;
    beneficiary = _beneficiary;
    initialReleasePercentage = _initialReleasePercentage;
    allocatedTokens = _amount;
    emit TokensAllocated(beneficiary, allocatedTokens);
  }

  function claimTokens() public {
    uint256 claimableTokens = getClaimableTokens();
    require(claimableTokens > 0, "Vesting: no claimable tokens");

    claimedTokens += claimableTokens;
    DOGS.transfer(beneficiary, claimableTokens);

    emit TokensClaimed(beneficiary, claimableTokens);
  }

  function getAllocatedTokens() public view returns (uint256 amount) {
    return allocatedTokens;
  }

  function getClaimedTokens() public view returns (uint256 amount) {
    return claimedTokens;
  }

  function getClaimableTokens() public view returns (uint256 amount) {
    uint256 releasedTokens = getReleasedTokensAtTimestamp(block.timestamp);
    return releasedTokens - claimedTokens;
  }

  function getReleasedTokensAtTimestamp(uint256 timestamp) public view returns (uint256 amount) {
    if (timestamp < start) {
      return 0;
    }
    
    uint256 elapsedTime = timestamp - start;

    if (elapsedTime >= duration) {
      return allocatedTokens;
    }

    uint256 initialRelease = allocatedTokens * initialReleasePercentage / 100;
    uint256 remainingTokensAfterInitialRelease = allocatedTokens - initialRelease;
    uint256 subsequentRelease = remainingTokensAfterInitialRelease * elapsedTime / duration;
    uint256 totalReleasedTokens = initialRelease + subsequentRelease;

    return totalReleasedTokens;
  }

}