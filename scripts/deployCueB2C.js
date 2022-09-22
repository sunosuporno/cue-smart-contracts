const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const CueB2C = await hre.ethers.getContractFactory("CueB2C");
  const cueB2C = await CueB2C.deploy(
    "0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA"
  );

  await cueB2C.deployed();

  console.log("CueB2C deployed to:", cueB2C.address);

  await cueB2C.deployTransaction.wait(14);

  await hre.run("verify:verify", {
    address: cueB2C.address,
    constructorArguments: ["0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA"],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
