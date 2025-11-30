/**
 * Vercel Serverless Function untuk Oracle Service
 */

import { ethers } from 'ethers';

const CONTRACT_ABI = [
  "function submitAIPrediction(uint256 _contractId, string memory _predictionType, int256 _value, uint8 _confidence) external",
  "function getLatestPrediction(uint256 _contractId) external view returns (tuple(uint256 timestamp, string predictionType, int256 value, uint8 confidence, address oracle))"
];

async function requestAIPrediction(modelType, data) {
  try {
    const baseUrl = process.env.VERCEL_URL 
      ? `https://${process.env.VERCEL_URL}` 
      : 'http://localhost:3000';
    
    const response = await fetch(`${baseUrl}/api/ai/predict`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model_type: modelType,
        data: data
      })
    });
    
    return await response.json();
  } catch (error) {
    console.error('Error requesting AI prediction:', error);
    throw error;
  }
}

async function submitToBlockchain(contractId, predictionType, value, confidence) {
  const rpcUrl = process.env.RPC_URL;
  const contractAddress = process.env.CONTRACT_ADDRESS;
  const privateKey = process.env.ORACLE_PRIVATE_KEY;

  if (!rpcUrl || !contractAddress || !privateKey) {
    console.log('Demo mode - blockchain config missing');
    return { demo: true, success: true };
  }

  try {
    const provider = new ethers.JsonRpcProvider(rpcUrl);
    const wallet = new ethers.Wallet(privateKey, provider);
    const contract = new ethers.Contract(contractAddress, CONTRACT_ABI, wallet);

    const tx = await contract.submitAIPrediction(
      contractId,
      predictionType,
      value,
      confidence
    );

    const receipt = await tx.wait();
    return { success: true, txHash: receipt.hash };
  } catch (error) {
    console.error('Error submitting to blockchain:', error);
    throw error;
  }
}

export default async function handler(req, res) {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET' && req.url === '/api/oracle/health') {
    return res.status(200).json({
      status: 'healthy',
      blockchain_connected: !!(process.env.CONTRACT_ADDRESS && process.env.ORACLE_PRIVATE_KEY),
      timestamp: new Date().toISOString()
    });
  }

  if (req.method === 'POST' && req.url === '/api/oracle/request-prediction') {
    try {
      const { contractId, modelType, data, submitToChain } = req.body;

      if (!contractId || !modelType) {
        return res.status(400).json({ error: 'contractId and modelType required' });
      }

      const prediction = await requestAIPrediction(modelType, data || {});

      if (prediction.error) {
        return res.status(500).json({ error: prediction.error });
      }

      let blockchainResult = null;
      if (submitToChain) {
        const value = prediction.prediction || prediction.risk_score || prediction.fraud_score || 0;
        blockchainResult = await submitToBlockchain(
          contractId,
          modelType,
          Math.floor(value),
          prediction.confidence
        );
      }

      return res.status(200).json({
        success: true,
        prediction,
        blockchain: blockchainResult,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      console.error('Error processing request:', error);
      return res.status(500).json({ error: error.message });
    }
  }

  return res.status(404).json({ error: 'Not found' });
}
