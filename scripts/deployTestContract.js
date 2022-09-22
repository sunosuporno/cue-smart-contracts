const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const TestContract = await hre.ethers.getContractFactory("TestContract");
  const testContract = await TestContract.deploy(
    "0x31142163f5D4d9fe4B5767C196610F9eEb6E3C69"
  );

  await testContract.deployed();

  console.log("TestContract deployed to:", testContract.address);

  await testContract.deployTransaction.wait(7);

  await hre.run("verify:verify", {
    address: testContract.address,
    constructorArguments: ["0x31142163f5D4d9fe4B5767C196610F9eEb6E3C69"],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
