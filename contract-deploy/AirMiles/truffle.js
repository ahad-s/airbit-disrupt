var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "4bjuTMM9udbx1RroD5u6";
// var mnemonic = "twelve words you can find in metamask/settings/reveal seed words blabla";
var mnemonic = "pony hood prevent bounce buddy miracle twenty jar oven crunch crucial tragic";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+infura_apikey),
      network_id: 3
    }
  }
};
