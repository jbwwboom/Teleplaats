var Migrations = artifacts.require("./Migrations.sol");

module.exports = function(deployer) {
  //web3.personal.unlockAccount(web3.personal.listAccounts[0], "node1@geth", 500)

  deployer.deploy(Migrations);
};
