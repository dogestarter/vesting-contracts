const { time } = require('@openzeppelin/test-helpers');
const FoundationVesting = artifacts.require('FoundationVesting');
const tokenContract = require('../data/tokenContract');
const tge = require('../data/tge');
const allocation = require('../data/allocations').foundation;

module.exports = async function (deployer, network) {
  const start = tge.timestamp + time.duration.days(30*5).toNumber();
  const beneficiary = allocation.address;
  const amount = allocation.amount;
  console.log(network)
  await deployer.deploy(
    FoundationVesting, 
    tokenContract[network].address, 
    beneficiary, 
    start, 
    amount
  );
};