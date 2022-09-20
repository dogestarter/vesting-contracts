const { time } = require('@openzeppelin/test-helpers');
const CexVesting = artifacts.require('CexVesting');
const tokenContract = require('../data/tokenContract');
const tge = require('../data/tge');
const allocation = require('../data/allocations').cex;

module.exports = async function (deployer, network) {
  const start = tge.timestamp + time.duration.days(30*3).toNumber();
  const beneficiary = allocation.address;
  const amount = allocation.amount;
  console.log(network)
  await deployer.deploy(
    CexVesting, 
    tokenContract[network].address, 
    beneficiary, 
    start, 
    amount
  );
};