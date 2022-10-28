const { ethers, upgrades } = require("hardhat");
async function main() {
  // We get the contract to deploy
  const gas = await ethers.provider.getGasPrice();
  const CueB2C = await ethers.getContractFactory("CueB2C");
  console.log("Deploying CueB2C...");
  const cueB2C = await upgrades.deployProxy(
    CueB2C,
    ["0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68"],
    {
      gasPrice: gas,
      initializer: "initialize",
    }
  );

  await cueB2C.deployed();

  console.log("CueB2C deployed to:", cueB2C.address);

  // await cueB2C.deployTransaction.wait(14);

  // await hre.run("verify:verify", {
  //   address: cueB2C.address,
  //   constructorArguments: ["0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA"],
  // });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
