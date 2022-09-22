const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const NotifAllowList = await hre.ethers.getContractFactory("NotifAllowList");
  const notifAllowList = await NotifAllowList.deploy(
    "0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68"
  );

  await notifAllowList.deployed();

  console.log("NotifAllowList deployed to:", notifAllowList.address);

  await notifAllowList.deployTransaction.wait(7);

  await hre.run("verify:verify", {
    address: notifAllowList.address,
    constructorArguments: ["0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68"],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
