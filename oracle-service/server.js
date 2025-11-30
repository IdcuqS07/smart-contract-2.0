/**
 * Oracle Service - Bridge antara AI Engine dan Smart Contract
 * Mengambil hasil AI dan mengirimkannya ke blockchain
 */

const express = require('express');
const axios = require('axios');
const { ethers } = require('ethers');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '..', '.env') });

const app = express();
app.use(express.json());

// Enable CORS for all routes
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  
  // Handle preflight
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// Configuration
const AI_ENGINE_URL = process.env.AI_ENGINE_URL || 'http://localhost:5001';
const RPC_URL = process.env.RPC_URL || 'http://localhost:8545';
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const PRIVATE_KEY = process.env.ORACLE_PRIVATE_KEY;

// Smart Contract ABI (simplified)
const CONTRACT_ABI = [
  "function submitAIPrediction(uint256 _contractId, string memory _predictionType, int256 _value, uint8 _confidence) external",
  "function getLatestPrediction(uint256 _contractId) external view returns (tuple(uint256 timestamp, string predictionType, int256 value, uint8 confidence, address oracle))"
];

class OracleService {
  constructor() {
    this.provider = null;
    this.wallet = null;
    this.contract = null;
    this.isInitialized = false;
  }

  async initialize() {
    try {
      if (!CONTRACT_ADDRESS || !PRIVATE_KEY) {
        console.log('⚠️  Running in demo mode (no blockchain connection)');
        this.isInitialized = false;
        return;
      }

      this.provider = new ethers.JsonRpcProvider(RPC_URL);
      this.wallet = new ethers.Wallet(PRIVATE_KEY, this.provider);
      this.contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, this.wallet);
      this.isInitialized = true;
      
      console.log('✅ Oracle connected to blockchain');
      console.log('📍 Contract:', CONTRACT_ADDRESS);
      console.log('🔑 Oracle address:', this.wallet.address);
    } catch (error) {
      console.error('❌ Failed to initialize oracle:', error.message);
      this.isInitialized = false;
    }
  }

  async requestAIPrediction(modelType, data) {
    try {
      const response = await axios.post(`${AI_ENGINE_URL}/predict`, {
        model_type: modelType,
        data: data
      });
      return response.data;
    } catch (error) {
      console.error('Error requesting AI prediction:', error.message);
      throw error;
    }
  }

  async submitToBlockchain(contractId, predictionType, value, confidence) {
    if (!this.isInitialized) {
      console.log('📝 Demo mode - would submit:', { contractId, predictionType, value, confidence });
      return { demo: true, success: true };
    }

    try {
      const tx = await this.contract.submitAIPrediction(
        contractId,
        predictionType,
        value,
        confidence
      );
      
      console.log('📤 Transaction sent:', tx.hash);
      const receipt = await tx.wait();
      console.log('✅ Transaction confirmed:', receipt.hash);
      
      return { success: true, txHash: receipt.hash };
    } catch (error) {
      console.error('Error submitting to blockchain:', error.message);
      throw error;
    }
  }
}

const oracle = new OracleService();

// Routes
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    blockchain_connected: oracle.isInitialized,
    timestamp: new Date().toISOString()
  });
});

app.post('/request-prediction', async (req, res) => {
  try {
    const { contractId, modelType, data, submitToChain } = req.body;

    if (!contractId || !modelType) {
      return res.status(400).json({ error: 'contractId and modelType required' });
    }

    // Request prediction from AI engine
    console.log(`🤖 Requesting ${modelType} prediction for contract ${contractId}`);
    const prediction = await oracle.requestAIPrediction(modelType, data || {});

    if (prediction.error) {
      return res.status(500).json({ error: prediction.error });
    }

    // Submit to blockchain if requested
    let blockchainResult = null;
    if (submitToChain) {
      const value = prediction.prediction || prediction.risk_score || prediction.fraud_score || 0;
      blockchainResult = await oracle.submitToBlockchain(
        contractId,
        modelType,
        Math.floor(value),
        prediction.confidence
      );
    }

    res.json({
      success: true,
      prediction,
      blockchain: blockchainResult,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error processing request:', error);
    res.status(500).json({ error: error.message });
  }
});

app.post('/submit-to-chain', async (req, res) => {
  try {
    const { contractId, predictionType, value, confidence } = req.body;

    if (!contractId || !predictionType || value === undefined || !confidence) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const result = await oracle.submitToBlockchain(
      contractId,
      predictionType,
      value,
      confidence
    );

    res.json({ success: true, result });

  } catch (error) {
    console.error('Error submitting to chain:', error);
    res.status(500).json({ error: error.message });
  }
});

// Start server
const PORT = process.env.PORT || 3002;

oracle.initialize().then(() => {
  app.listen(PORT, () => {
    console.log(`🌐 Oracle Service running on port ${PORT}`);
    console.log(`🤖 AI Engine URL: ${AI_ENGINE_URL}`);
  });
});
