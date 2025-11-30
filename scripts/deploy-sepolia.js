const hre = require("hardhat");

async function main() {
  console.log("🚀 Deploying Smart Contract 2.0 to Sepolia...");
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

  // Get deployer
  const [deployer] = await hre.ethers.getSigners();
  console.log("📍 Deploying from:", deployer.address);
  
  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("💰 Balance:", hre.ethers.formatEther(balance), "ETH");

  if (balance === 0n) {
    console.log("\n⚠️  WARNING: No ETH balance!");
    console.log("Get Sepolia ETH from: https://sepoliafaucet.com/");
    return;
  }

  // Deploy SmartContract2
  console.log("\n📝 Deploying SmartContract2...");
  const SmartContract2 = await hre.ethers.getContractFactory("SmartContract2");
  const smartContract2 = await SmartContract2.deploy();
  await smartContract2.waitForDeployment();
  const sc2Address = await smartContract2.getAddress();
  
  console.log("✅ SmartContract2 deployed to:", sc2Address);

  // Deploy IntelligentLayer
  console.log("\n📝 Deploying IntelligentLayer...");
  const IntelligentLayer = await hre.ethers.getContractFactory("IntelligentLayer");
  const intelligentLayer = await IntelligentLayer.deploy();
  await intelligentLayer.waitForDeployment();
  const ilAddress = await intelligentLayer.getAddress();
  
  console.log("✅ IntelligentLayer deployed to:", ilAddress);

  // Authorize deployer as oracle
  console.log("\n📝 Authorizing oracle address:", deployer.address);
  const tx = await smartContract2.authorizeOracle(deployer.address);
  await tx.wait();
  console.log("✅ Oracle authorized");

  console.log("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  console.log("📋 DEPLOYMENT SUMMARY");
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  console.log("Network:", hre.network.name);
  console.log("SmartContract2:", sc2Address);
  console.log("IntelligentLayer:", ilAddress);
  console.log("Oracle Address:", deployer.address);
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  
  console.log("\n💡 NEXT STEPS:");
  console.log("1. Set these in Vercel Environment Variables:");
  console.log(`   RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY`);
  console.log(`   CONTRACT_ADDRESS=${sc2Address}`);
  console.log(`   ORACLE_PRIVATE_KEY=<your-private-key>`);
  console.log("\n2. Deploy to Vercel:");
  console.log("   vercel --prod");
  console.log("\n3. Verify contracts (optional):");
  console.log(`   npx hardhat verify --network sepolia ${sc2Address}`);
  console.log(`   npx hardhat verify --network sepolia ${ilAddress}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
