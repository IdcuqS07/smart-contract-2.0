const hre = require("hardhat");

async function main() {
  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  
  const SmartContract2 = await hre.ethers.getContractFactory("SmartContract2");
  const contract = SmartContract2.attach(contractAddress);
  
  console.log("📝 Creating adaptive contract...");
  
  const tx = await contract.createAdaptiveContract("insurance", 1000);
  const receipt = await tx.wait();
  
  console.log("✅ Contract created!");
  console.log("Transaction hash:", receipt.hash);
  
  // Get contract ID from event
  const event = receipt.logs.find(log => {
    try {
      const parsed = contract.interface.parseLog(log);
      return parsed.name === "ContractCreated";
    } catch (e) {
      return false;
    }
  });
  
  if (event) {
    const parsed = contract.interface.parseLog(event);
    console.log("Contract ID:", parsed.args.contractId.toString());
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
