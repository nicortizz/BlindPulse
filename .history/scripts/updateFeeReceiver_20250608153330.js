const hre = require("hardhat");

async function main() {
  const [owner] = await hre.ethers.getSigners();

  const auctionAddress = "0x..."; // ← deployed address
  const newFeeReceiver = "0xABCDEF1234567890abcdef1234567890ABCDEF12"; // ← new address

  const Auction = await hre.ethers.getContractFactory("Auction");
  const auction = await Auction.attach(auctionAddress);

  console.log("Connected as:", owner.address);
  console.log("Current fee receiver:", await auction.feeReceiver());

  const tx = await auction.updateFeeReceiver(newFeeReceiver);
  await tx.wait();

  console.log("Fee receiver updated to:", await auction.feeReceiver());
}

main().catch((error) => {
  console.error("Error:", error);
  process.exitCode = 1;
});
