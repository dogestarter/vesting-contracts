const { time } = require('@openzeppelin/test-helpers');
const TeamAdvVesting = artifacts.require('TeamAdvVesting');
const tokenContract = require('../data/tokenContract');
const tge = require('../data/tge');
const allocation = require('../data/allocations').team;

module.exports = async function (deployer, network) {
  const start = tge.timestamp + time.duration.days(30*5).toNumber();
  const beneficiary = allocation.address;
  const amount = allocation.amount;
  console.log(network)
  await deployer.deploy(
    TeamAdvVesting, 
    tokenContract[network].address, 
    beneficiary, 
    start, 
    amount
  );
};