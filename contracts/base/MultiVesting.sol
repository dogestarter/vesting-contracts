// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MultiVesting {

  IERC20 public DOGS;
  uint256 public start;
  uint256 public constant duration = 180 days;
  uint256 public constant initialReleasePercentage = 10;

  mapping (address => uint256) internal _allocatedTokens;
  mapping (address => uint256) internal _claimedTokens;

  event TokensAllocated(address indexed beneficiary, uint256 value);
  event TokensClaimed(address indexed beneficiary, uint256 value);

  constructor(
    address _DOGSaddress,
    uint256 _start,
    address[] memory _beneficiaries,
    uint256[] memory _amounts
  ) {
    DOGS = IERC20(_DOGSaddress);
    start = _start;
    _allocateTokens(_beneficiaries, _amounts);
  }

  function claimAllTokens(address[] memory beneficiaries) public {
    for (uint256 i = 0; i < beneficiaries.length; i++) {
      uint256 claimableTokens = getClaimableTokens(beneficiaries[i]);
      require(claimableTokens > 0, "Vesting: no claimable tokens");

      _claimedTokens[beneficiaries[i]] += claimableTokens;
      DOGS.transfer(beneficiaries[i], claimableTokens);

      emit TokensClaimed(beneficiaries[i], claimableTokens);
    }
  }

  function getAllocatedTokens(address beneficiary) public view returns (uint256 amount) {
    return _allocatedTokens[beneficiary];
  }

  function getClaimedTokens(address beneficiary) public view returns (uint256 amount) {
    return _claimedTokens[beneficiary];
  }

  function getClaimableTokens(address beneficiary) public view returns (uint256 amount) {
    uint256 releasedTokens = getReleasedTokensAtTimestamp(beneficiary, block.timestamp);
    return releasedTokens - _claimedTokens[beneficiary];
  }

  function getReleasedTokensAtTimestamp(address beneficiary, uint256 timestamp) 
    public
    view
    returns (uint256 amount)
  {
    if (timestamp < start) {
      return 0;
    }
    
    uint256 elapsedTime = timestamp - start;

    if (elapsedTime >= duration) {
      return _allocatedTokens[beneficiary];
    }

    uint256 initialRelease = _allocatedTokens[beneficiary] * initialReleasePercentage / 100;
    uint256 remainingTokensAfterInitialRelease = _allocatedTokens[beneficiary] - initialRelease;
    uint256 subsequentRelease = remainingTokensAfterInitialRelease * elapsedTime / duration;
    uint256 totalReleasedTokens = initialRelease + subsequentRelease;

    return totalReleasedTokens;
  }

  function _allocateTokens(address[] memory beneficiaries, uint256[] memory amounts)
    internal
  {
    require(
      beneficiaries.length == amounts.length, 
      "Vesting: beneficiaries and amounts length mismatch"
    );

    for (uint256 i = 0; i < beneficiaries.length; i++) {
      require(beneficiaries[i] != address(0), "Vesting: beneficiary is 0 address");
      _allocatedTokens[beneficiaries[i]] = amounts[i];

      emit TokensAllocated(beneficiaries[i], amounts[i]);
    }
  }
}