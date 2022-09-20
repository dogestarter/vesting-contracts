const { time } = require('@openzeppelin/test-helpers');
const MarketingVesting = artifacts.require('MarketingVesting');
const tokenContract = require('../data/tokenContract');
const tge = require('../data/tge');
const allocation = require('../data/allocations').marketing;

module.exports = async function (deployer, network) {
  const start = tge.timestamp;
  const beneficiary = allocation.address;
  const amount = allocation.amount;
  console.log(network)
  await deployer.deploy(
    MarketingVesting, 
    tokenContract[network].address, 
    beneficiary, 
    start, 
    amount
  );
};