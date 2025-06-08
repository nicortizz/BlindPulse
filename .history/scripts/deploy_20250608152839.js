const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const durationInMinutes = 30;
  const feeReceiver = "0x1234567890abcdef1234567890abcdef12345678";
  const feePercent = 2; // 2%

  console.log("Deploying contract with account:", deployer.address);

  const Auction = await hre.ethers.getContractFactory("Auction");
  const auction = await Auction.deploy(durationInMinutes, feeReceiver, feePercent);

  await auction.deployed();

  console.log("Auction deployed to:", auction.address);
  console.log("Auction ends at:", await auction.auctionEndTime());
  console.log("Fee receiver:", await auction.feeReceiver());
  console.log("Fee percent:", (await auction.feePercent()).toString() + "%");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
