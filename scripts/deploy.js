const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying Smart Contract 2.0...");

  // Deploy SmartContract2
  const SmartContract2 = await hre.ethers.getContractFactory("SmartContract2");
  const smartContract2 = await SmartContract2.deploy();
  await smartContract2.waitForDeployment();
  const sc2Address = await smartContract2.getAddress();
  
  console.log("✅ SmartContract2 deployed to:", sc2Address);

  // Deploy IntelligentLayer
  const IntelligentLayer = await hre.ethers.getContractFactory("IntelligentLayer");
  const intelligentLayer = await IntelligentLayer.deploy();
  await intelligentLayer.waitForDeployment();
  const ilAddress = await intelligentLayer.getAddress();
  
  console.log("✅ IntelligentLayer deployed to:", ilAddress);

  // Get deployer address
  const [deployer] = await hre.ethers.getSigners();
  console.log("\n📝 Authorizing oracle address:", deployer.address);
  
  // Authorize deployer as oracle (for testing)
  const tx = await smartContract2.authorizeOracle(deployer.address);
  await tx.wait();
  console.log("✅ Oracle authorized");

  console.log("\n📋 Deployment Summary:");
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  console.log("SmartContract2:", sc2Address);
  console.log("IntelligentLayer:", ilAddress);
  console.log("Oracle Address:", deployer.address);
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  console.log("\n💡 Update your .env file with:");
  console.log(`CONTRACT_ADDRESS=${sc2Address}`);
  console.log(`ORACLE_PRIVATE_KEY=<your-private-key>`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
