const hre = require("hardhat");

async function main() {
  const [owner] = await hre.ethers.getSigners();

  const auctionAddress = "0x..."; // ← Reemplaza con la dirección de tu contrato desplegado
  const newFeePercent = 3; // ← Nuevo porcentaje (por ejemplo, 3%)

  const Auction = await hre.ethers.getContractFactory("Auction");
  const auction = await Auction.attach(auctionAddress);

  console.log("Connected as:", owner.address);
  console.log("Current fee percent:", (await auction.feePercent()).toString(), "%");

  const tx = await auction.updateFeePercent(newFeePercent);
  await tx.wait();

  console.log("Fee percent updated to:", (await auction.feePercent()).toString(), "%");
}

main().catch((error) => {
  console.error("Error:", error);
  process.exitCode = 1;
});
