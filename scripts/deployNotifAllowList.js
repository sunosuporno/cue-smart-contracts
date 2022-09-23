const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const NotifAllowList = await hre.ethers.getContractFactory("NotifAllowList");
  const notifAllowList = await NotifAllowList.deploy(
    "0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA"
  );

  await notifAllowList.deployed();

  console.log("NotifAllowList deployed to:", notifAllowList.address);

  await notifAllowList.deployTransaction.wait(10);

  await hre.run("verify:verify", {
    address: notifAllowList.address,
    constructorArguments: ["0xC72E8a7Be04f2469f8C2dB3F1BdF69A7D516aBbA"],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
