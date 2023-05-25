import { HardhatRuntimeEnvironment } from "hardhat/types";
import { ethers } from 'hardhat'

const main = async ({
  network,
  deployments,
  getNamedAccounts,
}: HardhatRuntimeEnvironment) => {
  const { deploy, execute } = deployments;
  const { deployer } = await getNamedAccounts();
  console.log(`Deploying USDC AAVE Contract on ${network.name}`);

  const POOL = '0xe336CbD5416CDB6CE70bA16D9952A963a81A918d'
  const USDC = '0xe9DcE89B076BA6107Bb64EF30678efec11939234'


  const aaveUSDC = await deploy("AaveAdapterUSDC", {
    contract: "AaveAdapter",
    from: deployer,
    args: [POOL, USDC],
  });

  console.log(`AaveAdapterUSDC @ ${aaveUSDC.address}`);

  await execute('Treasury', { from: deployer }, 'addAdapter', ...[aaveUSDC.address]);
};
main.tags = ["AaveAdapterUSDC"];

export default main;
