const hre = require("hardhat");
require("@nomiclabs/hardhat-etherscan");
async function main() {
  // We get the contract to deploy
  const CueB2B = await hre.ethers.getContractFactory("CueB2B");
  const cueB2B = await CueB2B.deploy(
    "0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68",
    "0x7B8AC044ebce66aCdF14197E8De38C1Cc802dB4A"
  );

  await cueB2B.deployed();

  console.log("CueB2B deployed to:", cueB2B.address);

  await cueB2B.deployTransaction.wait(7);

  await hre.run("verify:verify", {
    address: cueB2B.address,
    constructorArguments: [
      "0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68",
      "0x7B8AC044ebce66aCdF14197E8De38C1Cc802dB4A",
    ],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
