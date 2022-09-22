const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const CueB2C = await hre.ethers.getContractFactory("CueB2C");
  const cueB2C = await CueB2C.deploy(
    "0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68"
  );

  await cueB2C.deployed();

  console.log("CueB2C deployed to:", cueB2C.address);

  await cueB2C.deployTransaction.wait(7);

  await hre.run("verify:verify", {
    address: cueB2C.address,
    constructorArguments: ["0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68"],
  });
}
