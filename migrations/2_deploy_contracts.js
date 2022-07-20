const Nft = artifacts.require("Nft");

module.exports = function (deployer) {
  deployer.deploy(Nft);
};