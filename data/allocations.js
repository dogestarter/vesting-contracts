const web3 = require('web3');

const tokens = amount => web3.utils.toWei(amount, 'ether');

module.exports = {
  marketing: {
    address: '0x726806A6D3e2816e5874D14c627277BDadf51daB',
    amount: tokens('20000000'),
  },
  team: {
    address: '0x2660e15494310AB76D49d1470E0397202676Fb16',
    amount: tokens('12000000'),
  },
  foundation: {
    address: '0x2660e15494310AB76D49d1470E0397202676Fb16',
    amount: tokens('15000000'),
  },
  staking: {
    address: '0xf185eb3383DbCF64F59afE6918Df3A85f2a5EE19',
    amount: tokens('8000000'),
  },
  cex: {
    address: '0x24b5576D1cB661c8cA4D04aaa8237b82Ea4813A1',
    amount: tokens('12000000'),
  },
};