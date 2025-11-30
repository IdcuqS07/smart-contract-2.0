/**
 * Linera Oracle HTTP Server
 * Provides REST API for oracle operations
 */

const express = require('express');
const cors = require('cors');
const LineraOracleClient = require('./linera-oracle');

const app = express();
const PORT = process.env.PORT || 3002;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Oracle Client (with mock config for now)
const oracleConfig = {
  graphqlEndpoint: process.env.LINERA_GRAPHQL || 'http://localhost:8080/graphql',
  chainId: process.env.CHAIN_ID || 'default',
  applicationId: process.env.APP_ID || 'default',
  ownerAddress: process.env.OWNER_ADDRESS || 'default',
  aiEngineUrl: process.env.AI_ENGINE_URL || 'http://localhost:5001'
};

const oracle = new LineraOracleClient(oracleConfig);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'Linera Oracle Service',
    version: '1.0.0',
    config: {
      graphqlEndpoint: oracleConfig.graphqlEndpoint,
      aiEngineUrl: oracleConfig.aiEngineUrl
    }
  });
});

// Create adaptive contract
app.post('/contract/create', async (req, res) => {
  try {
    const { contractType, threshold } = req.body;
    
    if (!contractType || threshold === undefined) {
      return res.status(400).json({
        error: 'Missing required fields: contractType, threshold'
      });
    }

    const result = await oracle.createAdaptiveContract(contractType, threshold);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Request and submit prediction
app.post('/prediction/request', async (req, res) => {
  try {
    const { contractId, modelType, data } = req.body;
    
    if (!contractId || !modelType) {
      return res.status(400).json({
        error: 'Missing required fields: contractId, modelType'
      });
    }

    const result = await oracle.requestAndSubmitPrediction(contractId, modelType, data);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get contract info
app.get('/contract/:id', async (req, res) => {
  try {
    const contractId = parseInt(req.params.id);
    const contract = await oracle.getContract(contractId);
    
    if (!contract) {
      return res.status(404).json({ error: 'Contract not found' });
    }
    
    res.json(contract);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get latest prediction
app.get('/prediction/latest/:contractId', async (req, res) => {
  try {
    const contractId = parseInt(req.params.contractId);
    const prediction = await oracle.getLatestPrediction(contractId);
    
    if (!prediction) {
      return res.status(404).json({ error: 'No prediction found' });
    }
    
    res.json(prediction);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Authorize oracle
app.post('/oracle/authorize', async (req, res) => {
  try {
    const { oracleAddress } = req.body;
    
    if (!oracleAddress) {
      return res.status(400).json({
        error: 'Missing required field: oracleAddress'
      });
    }

    const result = await oracle.authorizeOracle(oracleAddress);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start server
app.listen(PORT, () => {
  console.log('🚀 Linera Oracle Service Started');
  console.log('================================');
  console.log(`📡 Server running on: http://localhost:${PORT}`);
  console.log(`🔗 Linera GraphQL: ${oracleConfig.graphqlEndpoint}`);
  console.log(`🤖 AI Engine: ${oracleConfig.aiEngineUrl}`);
  console.log('================================');
  console.log('');
  console.log('📊 Available Endpoints:');
  console.log(`  GET  /health - Health check`);
  console.log(`  POST /contract/create - Create adaptive contract`);
  console.log(`  POST /prediction/request - Request AI prediction`);
  console.log(`  GET  /contract/:id - Get contract info`);
  console.log(`  GET  /prediction/latest/:contractId - Get latest prediction`);
  console.log(`  POST /oracle/authorize - Authorize oracle address`);
  console.log('');
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('🛑 Shutting down gracefully...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🛑 Shutting down gracefully...');
  process.exit(0);
});
