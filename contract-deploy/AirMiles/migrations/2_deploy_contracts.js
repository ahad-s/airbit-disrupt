// var ConvertLib = artifacts.require("./ConvertLib.sol");
// var MetaCoin = artifacts.require("./MetaCoin.sol");
var AirMiles = artifacts.require("./AirMiles.sol")

module.exports = function(deployer) {
	deployer.deploy(AirMiles)
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MetaCoin);
};
