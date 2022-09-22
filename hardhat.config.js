require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();
const alchemyMumbai = process.env.ALCHEMY_MUMBAI;
const alchemyGoerli = process.env.ALCHEMY_GOERLI;
const alchemy_opt_goerli = process.env.ALCHEMY_GOERLI_OPTIMISM;
const privateKey1 = process.env.PRIVATE_KEY;
const polygonscanApiKey = process.env.POLYGONSCAN_API_KEY;
const etherscanApiKey = process.env.ETHERSCAN_API_KEY;
const optimismApiKey = process.env.OPTIMISM_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "mumbai",
  networks: {
    hardhat: {},
    mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/" + alchemyMumbai,
      accounts: [privateKey1],
    },
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/" + alchemyGoerli,
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
      goerli: etherscanApiKey,
      opt_goerli: optimismApiKey,
    },
    customChains: [
      {
        network: "opt_goerli",
        chainId: 420,
        urls: {
          apiURL: "https://api-optimistic.etherscan.io/api",
          browserURL: "https://optimistic.etherscan.io",
        },
      },
    ],
  },
};
