/**
 * Oracle Service - Smart Contract 2.0
 * REST API for contract operations and AI integration
 */

const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Middleware
app.use(cors());
app.use(express.json());

// Request logging middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.path} ${res.statusCode} ${duration}ms`);
  });
  next();
});

// Rate limiting (simple in-memory implementation)
const rateLimitMap = new Map();
const RATE_LIMIT_WINDOW = 15 * 60 * 1000; // 15 minutes
const RATE_LIMIT_MAX = 100; // max requests per window

const rateLimit = (req, res, next) => {
  const ip = req.ip || req.connection.remoteAddress;
  const now = Date.now();
  
  if (!rateLimitMap.has(ip)) {
    rateLimitMap.set(ip, { count: 1, resetAt: now + RATE_LIMIT_WINDOW });
    return next();
  }
  
  const limit = rateLimitMap.get(ip);
  
  if (now > limit.resetAt) {
    limit.count = 1;
    limit.resetAt = now + RATE_LIMIT_WINDOW;
    return next();
  }
  
  if (limit.count >= RATE_LIMIT_MAX) {
    return res.status(429).json({
      success: false,
      error: 'Too many requests. Please try again later.',
      retryAfter: Math.ceil((limit.resetAt - now) / 1000)
    });
  }
  
  limit.count++;
  next();
};

// Apply rate limiting to all routes
app.use(rateLimit);

// Configuration
const AI_ENGINE_URL = process.env.AI_ENGINE_URL || 'http://localhost:5001';

// In-memory storage (replace with database in production)
const contracts = new Map();
const predictions = new Map();
let contractIdCounter = 1;
let predictionIdCounter = 1;

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'oracle',
    timestamp: Date.now()
  });
});

// Create adaptive contract
app.post('/request', async (req, res) => {
  try {
    const { contractType, threshold } = req.body;
    
    if (!contractType || threshold === undefined) {
      return res.status(400).json({
        success: false,
        error: 'Missing required fields: contractType, threshold'
      });
    }

    const contractId = contractIdCounter++;
    const contract = {
      id: contractId,
      type: contractType,
      threshold: parseFloat(threshold),
      status: 'active',
      createdAt: new Date().toISOString(),
      predictions: []
    };
    
    contracts.set(contractId, contract);
    
    res.json({
      success: true,
      data: contract
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Get contract by ID
app.get('/contract/:id', (req, res) => {
  try {
    const contractId = parseInt(req.params.id);
    const contract = contracts.get(contractId);
    
    if (!contract) {
      return res.status(404).json({
        success: false,
        error: 'Contract not found'
      });
    }
    
    res.json({
      success: true,
      data: contract
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Get all contracts
app.get('/contracts', (req, res) => {
  try {
    const allContracts = Array.from(contracts.values());
    res.json({
      success: true,
      data: allContracts,
      count: allContracts.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Request AI prediction
app.post('/predict', async (req, res) => {
  try {
    const { contractId, modelType, data } = req.body;
    
    if (!contractId || !modelType) {
      return res.status(400).json({
        success: false,
        error: 'Missing required fields: contractId, modelType'
      });
    }

    const contract = contracts.get(parseInt(contractId));
    if (!contract) {
      return res.status(404).json({
        success: false,
        error: 'Contract not found'
      });
    }

    // Call AI Engine
    const aiResponse = await axios.post(`${AI_ENGINE_URL}/predict`, {
      model_type: modelType,
      data: data || {}
    });

    const predictionId = predictionIdCounter++;
    const prediction = {
      id: predictionId,
      contractId: parseInt(contractId),
      modelType,
      result: aiResponse.data,
      timestamp: new Date().toISOString()
    };

    predictions.set(predictionId, prediction);
    contract.predictions.push(predictionId);

    res.json({
      success: true,
      data: prediction
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Get prediction by ID
app.get('/prediction/:id', (req, res) => {
  try {
    const predictionId = parseInt(req.params.id);
    const prediction = predictions.get(predictionId);
    
    if (!prediction) {
      return res.status(404).json({
        success: false,
        error: 'Prediction not found'
      });
    }
    
    res.json({
      success: true,
      data: prediction
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Get latest prediction for contract
app.get('/prediction/latest/:contractId', (req, res) => {
  try {
    const contractId = parseInt(req.params.contractId);
    const contract = contracts.get(contractId);
    
    if (!contract) {
      return res.status(404).json({
        success: false,
        error: 'Contract not found'
      });
    }

    if (contract.predictions.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'No predictions found for this contract'
      });
    }

    const latestPredictionId = contract.predictions[contract.predictions.length - 1];
    const prediction = predictions.get(latestPredictionId);
    
    res.json({
      success: true,
      data: prediction
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Metrics endpoint
app.get('/metrics', (req, res) => {
  res.json({
    service: 'oracle',
    environment: NODE_ENV,
    uptime: process.uptime(),
    memory: {
      used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
      total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024),
      unit: 'MB'
    },
    stats: {
      contracts: contracts.size,
      predictions: predictions.size,
      activeConnections: rateLimitMap.size
    },
    timestamp: Date.now()
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    path: req.path
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error(`[ERROR] ${err.message}`);
  console.error(err.stack);
  
  res.status(err.statusCode || 500).json({
    success: false,
    error: NODE_ENV === 'production' ? 'Internal server error' : err.message,
    ...(NODE_ENV === 'development' && { stack: err.stack })
  });
});

// Start server
const server = app.listen(PORT, () => {
  console.log('🚀 Oracle Service Started');
  console.log('================================');
  console.log(`📡 Server: http://localhost:${PORT}`);
  console.log(`🤖 AI Engine: ${AI_ENGINE_URL}`);
  console.log(`🌍 Environment: ${NODE_ENV}`);
  console.log('================================');
  console.log('');
  console.log('📊 Available Endpoints:');
  console.log('  GET  /health - Health check');
  console.log('  GET  /metrics - Service metrics');
  console.log('  POST /request - Create adaptive contract');
  console.log('  GET  /contract/:id - Get contract by ID');
  console.log('  GET  /contracts - Get all contracts');
  console.log('  POST /predict - Request AI prediction');
  console.log('  GET  /prediction/:id - Get prediction by ID');
  console.log('  GET  /prediction/latest/:contractId - Get latest prediction');
  console.log('');
  console.log('🔒 Security:');
  console.log(`  Rate Limit: ${RATE_LIMIT_MAX} requests per ${RATE_LIMIT_WINDOW/60000} minutes`);
  console.log('  CORS: Enabled');
  console.log('  Request Logging: Enabled');
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

module.exports = app;
