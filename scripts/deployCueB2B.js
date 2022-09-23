const hre = require("hardhat");
require("@nomiclabs/hardhat-etherscan");
async function main() {
  // We get the contract to deploy
  const CueB2B = await hre.ethers.getContractFactory("CueB2B");
  const cueB2B = await CueB2B.deploy(
    "0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA",
    "0x08b193bC308eC1E60cE0064CB503c9D85A841347"
  );

  await cueB2B.deployed();

  console.log("CueB2B deployed to:", cueB2B.address);

  await cueB2B.deployTransaction.wait(7);

  await hre.run("verify:verify", {
    address: cueB2B.address,
    constructorArguments: [
      "0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA",
      "0x08b193bC308eC1E60cE0064CB503c9D85A841347",
    ],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
