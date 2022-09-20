const { time } = require('@openzeppelin/test-helpers');
const StakingVesting = artifacts.require('StakingVesting');
const tokenContract = require('../data/tokenContract');
const tge = require('../data/tge');
const allocation = require('../data/allocations').staking;

module.exports = async function (deployer, network) {
  const start = tge.timestamp + time.duration.days(30).toNumber();
  const beneficiary = allocation.address;
  const amount = allocation.amount;
  console.log(network)
  await deployer.deploy(
    StakingVesting, 
    tokenContract[network].address, 
    beneficiary, 
    start, 
    amount
  );
};