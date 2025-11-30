const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SmartContract2", function () {
  let smartContract2;
  let owner;
  let oracle;
  let user;

  beforeEach(async function () {
    [owner, oracle, user] = await ethers.getSigners();
    
    const SmartContract2 = await ethers.getContractFactory("SmartContract2");
    smartContract2 = await SmartContract2.deploy();
    await smartContract2.waitForDeployment();
    
    // Authorize oracle
    await smartContract2.authorizeOracle(oracle.address);
  });

  describe("Contract Creation", function () {
    it("Should create adaptive contract", async function () {
      const tx = await smartContract2.connect(user).createAdaptiveContract("insurance", 1000);
      await tx.wait();
      
      const contract = await smartContract2.contracts(1);
      expect(contract.creator).to.equal(user.address);
      expect(contract.contractType).to.equal("insurance");
      expect(contract.threshold).to.equal(1000);
      expect(contract.isActive).to.equal(true);
    });
  });

  describe("AI Prediction Submission", function () {
    beforeEach(async function () {
      await smartContract2.connect(user).createAdaptiveContract("insurance", 1000);
    });

    it("Should submit AI prediction from authorized oracle", async function () {
      await smartContract2.connect(oracle).submitAIPrediction(1, "risk_analysis", 500, 85);
      
      const prediction = await smartContract2.getLatestPrediction(1);
      expect(prediction.predictionType).to.equal("risk_analysis");
      expect(prediction.value).to.equal(500);
      expect(prediction.confidence).to.equal(85);
    });

    it("Should reject prediction from unauthorized address", async function () {
      await expect(
        smartContract2.connect(user).submitAIPrediction(1, "risk_analysis", 500, 85)
      ).to.be.revertedWith("Not authorized oracle");
    });

    it("Should auto-execute when threshold reached", async function () {
      await smartContract2.connect(oracle).submitAIPrediction(1, "risk_analysis", 1500, 90);
      
      const contract = await smartContract2.contracts(1);
      expect(contract.isActive).to.equal(false);
    });
  });
});
