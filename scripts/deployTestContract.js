const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const TestContract = await hre.ethers.getContractFactory("TestContract");
  const testContract = await TestContract.deploy(
    "0xbF2c92D57A9b8270273D1b9e42cc51566184a3f7"
  );

  await testContract.deployed();

  console.log("TestContract deployed to:", testContract.address);

  await testContract.deployTransaction.wait(7);

  await hre.run("verify:verify", {
    address: testContract.address,
    constructorArguments: ["0xbF2c92D57A9b8270273D1b9e42cc51566184a3f7"],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// https://testnet.tableland.network/query?mode=json&s=select%20*%20from%20notifs_allowlist_80001_2623%20where%20company_name%20=%20%27cue_test%27%20and%20wallet_address%20=%20%2743690047485523017521719660013406923964685528852%27
