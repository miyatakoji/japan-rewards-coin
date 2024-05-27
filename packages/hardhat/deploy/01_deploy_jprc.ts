import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const initialSupply = ethers.utils.parseUnits("1000000", 18);
const cashbackPercentage = 2; // 2%
const jackpotPercentage = 1; // 1%

const RewardYen = await ethers.getContractFactory("RewardYen");
const rewardYen = await RewardYen.deploy(initialSupply, cashbackPercentage, jackpotPercentage);
await rewardYen.deployed();