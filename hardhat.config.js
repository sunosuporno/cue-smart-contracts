require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();
const QUICKNODE_MUMBAI = process.env.QUICKNODE_MUMBAI;
const ALCHEMY_GOERLI = process.env.ALCHEMY_GOERLI;
const alchemy_opt_goerli = process.env.ALCHEMY_GOERLI_OPTIMISM;
const privateKey1 = process.env.PRIVATE_KEY;
const polygonscanApiKey = process.env.POLYGONSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "mumbai",
  networks: {
    hardhat: {},
    mumbai: {
      url:
        "https://clean-light-snow.matic-testnet.discover.quiknode.pro/" +
        QUICKNODE_MUMBAI,
      accounts: [privateKey1],
    },
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/" + ALCHEMY_GOERLI,
      accounts: [privateKey1],
    },
    opt_goerli: {
      url: "https://opt-goerli.g.alchemy.com/v2/" + alchemy_opt_goerli,
      accounts: [privateKey1],
    },
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  etherscan: {
    apiKey: {
      polygonMumbai: polygonscanApiKey,
    },
  },
};
