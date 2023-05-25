import { HardhatRuntimeEnvironment } from "hardhat/types";

const main = async ({
  network,
  deployments,
  getNamedAccounts,
}: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  console.log(`Deploying Treasury Contract on ${network.name}`);

  const DAI = '0xF14f9596430931E177469715c591513308244e8F'
  const USDC = '0xe9DcE89B076BA6107Bb64EF30678efec11939234'


  const treasury = await deploy("Treasury", {
    contract: "Treasury",
    from: deployer,
    args: [DAI, USDC],
  });

  console.log(`Treasury @ ${treasury.address}`);
};
main.tags = ["Treasury"];

export default main;
