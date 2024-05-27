import { expect } from "chai";
import { ethers } from "hardhat";

describe("JapanRewardsCoin", function () {
  let JapanRewardsCoin: any, japanRewardsCoin: any;
  let owner: any, addr1: any, addr2: any;

  beforeEach(async function () {
    JapanRewardsCoin = await ethers.getContractFactory("JapanRewardsCoin");
    [owner, addr1, addr2] = await ethers.getSigners();

    japanRewardsCoin = await JapanRewardsCoin.deploy(
      ethers.parseUnits("1000000", 18), // Initial supply
      100, // Fixed cashback amount
      2, // Percentage cashback (2%)
      1 // Jackpot percentage (1%)
    );
    await japanRewardsCoin.waitForDeployment();
  });

  it("Should deploy with the correct initial supply", async function () {
    const ownerBalance = await japanRewardsCoin.balanceOf(owner.address);
    expect(await japanRewardsCoin.totalSupply()).to.equal(ownerBalance);
  });

  it("Should transfer tokens and apply fixed cashback", async function () {
    const transferAmount = ethers.parseUnits("100", 18);
    await japanRewardsCoin.transfer(addr1.address, transferAmount);

    const addr1Balance = await japanRewardsCoin.balanceOf(addr1.address);
    const expectedBalance = transferAmount.add(ethers.parseUnits("100", 18)); // Adding fixed cashback

    expect(addr1Balance).to.equal(expectedBalance);
  });

  it("Should transfer tokens and apply percentage cashback", async function () {
    const transferAmount = ethers.parseUnits("100", 18);
    await japanRewardsCoin.transfer(addr1.address, transferAmount);

    const addr1Balance = await japanRewardsCoin.balanceOf(addr1.address);
    const percentageCashback = transferAmount.mul(2).div(100); // 2% of 100
    const expectedBalance = transferAmount.add(ethers.parseUnits("100", 18)).add(percentageCashback);

    expect(addr1Balance).to.equal(expectedBalance);
  });

  it("Should handle jackpot correctly", async function () {
    const transferAmount = ethers.parseUnits("100", 18);
    await japanRewardsCoin.setJackpotPercentage(100); // Set jackpot chance to 100% for testing

    await japanRewardsCoin.transfer(addr1.address, transferAmount);
    const addr1Balance = await japanRewardsCoin.balanceOf(addr1.address);

    expect(addr1Balance).to.be.gt(transferAmount);
  });

  it("Should allow owner to set location permissions", async function () {
    await japanRewardsCoin.setLocationPermission(addr1.address, true, ethers.parseUnits("500", 18));
    const location = await japanRewardsCoin.locationPermissions(addr1.address);

    expect(location.isAllowed).to.equal(true);
    expect(location.maxAmount).to.equal(ethers.parseUnits("500", 18));
  });

  it("Should prevent transfers to addresses without location permission", async function () {
    await japanRewardsCoin.setLocationPermission(addr1.address, false, ethers.parseUnits("500", 18));
    const transferAmount = ethers.parseUnits("100", 18);

    await expect(japanRewardsCoin.transfer(addr1.address, transferAmount)).to.be.revertedWith("Recipient location not allowed for transactions");
  });
});
