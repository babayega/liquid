import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import "hardhat-deploy";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-etherscan";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        runs: 200,
        enabled: true,
      },
    },
  },
  networks: {
    mumbai: {
      chainId: 80001,
      url: process.env.MUMBAI_RPC || "",
      accounts:
        process.env.PVT_KEY !== undefined
          ? [process.env.PVT_KEY]
          : [],
    }
  },
  paths: {
    deploy: "scripts",
    deployments: "deployments",
  },
  namedAccounts: {
    deployer: 0
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
