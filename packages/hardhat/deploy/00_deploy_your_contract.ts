import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

/**
 * Deploys a contract named "JapanRewardsCoin" using the deployer account and
 * constructor arguments set to the deployer address
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployJapanRewardsCoin: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  /*
    On localhost, the deployer account is the one that comes with Hardhat, which is already funded.

    When deploying to live networks (e.g `yarn deploy --network sepolia`), the deployer account
    should have sufficient balance to pay for the gas fees for contract creation.

    You can generate a random account with `yarn generate` which will fill DEPLOYER_PRIVATE_KEY
    with a random private key in the .env file (then used on hardhat.config.ts)
    You can run the `yarn account` command to check your balance in every network.
  */
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;
  const initialSupply = 100000000000000;
  const fixedCashback = 100; // fixed cashback amount
  const percentageCashback = 2; // percentage cashback (2%)
  const jackpotPercentage = 1; // jackpot percentage (1%)

  await deploy("JapanRewardsCoin", {
    from: deployer,
    // Contract constructor arguments
    args: [initialSupply, fixedCashback, percentageCashback, jackpotPercentage],
    log: true,
    // autoMine: can be passed to the deploy function to make the deployment process faster on local networks by
    // automatically mining the contract deployment transaction. There is no effect on live networks.
    autoMine: true,
  });

  // Get the deployed contract to interact with it after deploying.
  const JapanRewardsCoin = await hre.ethers.getContract<Contract>("JapanRewardsCoin", deployer);
  // console.log("👋 Initial mint:", await JapanRewardsCoin.mint());
};

export default deployJapanRewardsCoin;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags JapanRewardsCoin
deployJapanRewardsCoin.tags = ["JapanRewardsCoin"];
