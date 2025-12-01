#!/usr/bin/env node

/**
 * Mock Linera Service
 * Simulates Linera blockchain for testing without CLI
 */

const express = require('express');
const cors = require('cors');
const { graphqlHTTP } = require('express-graphql');
const { buildSchema } = require('graphql');

const app = express();
const PORT = 8080;

// Mock blockchain state
const mockState = {
  chains: ['chain_1', 'chain_2'],
  applications: new Map(),
  contracts: new Map(),
  predictions: new Map(),
  nextContractId: 1,
  nextPredictionId: 1
};

// GraphQL Schema
const schema = buildSchema(`
  type Chain {
    id: String!
    description: String
    balance: Float
    timestamp: String
  }
  
  type Contract {
    id: Int!
    creator: String!
    contract_type: String!
    threshold: Int!
    is_active: Boolean!
    created_at: String!
    last_updated: String!
  }
  
  type Prediction {
    id: Int!
    contract_id: Int!
    timestamp: String!
    prediction_type: String!
    value: Int!
    confidence: Int!
    oracle: String!
  }
  
  type ExecutionResult {
    hash: String!
    success: Boolean!
  }
  
  type Query {
    chains: [Chain!]!
    contract(id: Int!): Contract
    contracts: [Contract!]!
    prediction(id: Int!): Prediction
    predictions(contractId: Int!): [Prediction!]!
    latestPrediction(contractId: Int!): Prediction
  }
  
  type Mutation {
    createContract(
      contractType: String!
      threshold: Int!
    ): Contract!
    
    submitPrediction(
      contractId: Int!
      predictionType: String!
      value: Int!
      confidence: Int!
    ): Prediction!
  }
`);

// Resolvers
const root = {
  // Queries
  chains: () => {
    return mockState.chains.map(id => ({
      id,
      description: `Mock Chain ${id}`,
      balance: 1000000,
      timestamp: new Date().toISOString()
    }));
  },
  
  contract: ({ id }) => {
    return mockState.contracts.get(id) || null;
  },
  
  contracts: () => {
    return Array.from(mockState.contracts.values());
  },
  
  prediction: ({ id }) => {
    return mockState.predictions.get(id) || null;
  },
  
  predictions: ({ contractId }) => {
    return Array.from(mockState.predictions.values())
      .filter(p => p.contract_id === contractId);
  },
  
  latestPrediction: ({ contractId }) => {
    const predictions = Array.from(mockState.predictions.values())
      .filter(p => p.contract_id === contractId)
      .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));
    
    return predictions[0] || null;
  },
  
  // Mutations
  createContract: ({ contractType, threshold }) => {
    const id = mockState.nextContractId++;
    const now = new Date().toISOString();
    
    const contract = {
      id,
      creator: 'mock_owner',
      contract_type: contractType,
      threshold,
      is_active: true,
      created_at: now,
      last_updated: now
    };
    
    mockState.contracts.set(id, contract);
    
    console.log(`✅ Contract created: ID ${id}, Type: ${contractType}, Threshold: ${threshold}`);
    
    return contract;
  },
  
  submitPrediction: ({ contractId, predictionType, value, confidence }) => {
    const contract = mockState.contracts.get(contractId);
    
    if (!contract) {
      throw new Error(`Contract ${contractId} not found`);
    }
    
    if (!contract.is_active) {
      throw new Error(`Contract ${contractId} is not active`);
    }
    
    const id = mockState.nextPredictionId++;
    const now = new Date().toISOString();
    
    const prediction = {
      id,
      contract_id: contractId,
      timestamp: now,
      prediction_type: predictionType,
      value,
      confidence,
      oracle: 'mock_oracle'
    };
    
    mockState.predictions.set(id, prediction);
    
    console.log(`✅ Prediction submitted: Contract ${contractId}, Value: ${value}, Confidence: ${confidence}%`);
    
    // Check if threshold is reached
    const absValue = Math.abs(value);
    if (absValue >= contract.threshold) {
      contract.is_active = false;
      contract.last_updated = now;
      mockState.contracts.set(contractId, contract);
      
      console.log(`🎯 Contract ${contractId} AUTO-EXECUTED! Threshold reached: ${absValue} >= ${contract.threshold}`);
    }
    
    return prediction;
  }
};

// Middleware
app.use(cors());
app.use(express.json());

// GraphQL endpoint
app.use('/graphql', graphqlHTTP({
  schema: schema,
  rootValue: root,
  graphiql: true
}));

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'Mock Linera Service',
    version: '1.0.0',
    mode: 'simulation',
    contracts: mockState.contracts.size,
    predictions: mockState.predictions.size
  });
});

// REST API for easier testing
app.post('/api/contract/create', (req, res) => {
  try {
    const { contractType, threshold } = req.body;
    const contract = root.createContract({ contractType, threshold });
    res.json({ success: true, contract });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/api/prediction/submit', (req, res) => {
  try {
    const { contractId, predictionType, value, confidence } = req.body;
    const prediction = root.submitPrediction({ contractId, predictionType, value, confidence });
    res.json({ success: true, prediction });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/api/contract/:id', (req, res) => {
  try {
    const id = parseInt(req.params.id);
    const contract = root.contract({ id });
    
    if (!contract) {
      return res.status(404).json({ success: false, error: 'Contract not found' });
    }
    
    res.json({ success: true, contract });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/api/predictions/:contractId', (req, res) => {
  try {
    const contractId = parseInt(req.params.contractId);
    const predictions = root.predictions({ contractId });
    res.json({ success: true, predictions });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Start server
app.listen(PORT, () => {
  console.log('🚀 Mock Linera Service Started');
  console.log('================================');
  console.log(`📡 GraphQL: http://localhost:${PORT}/graphql`);
  console.log(`🔍 GraphiQL: http://localhost:${PORT}/graphql`);
  console.log(`💚 Health: http://localhost:${PORT}/health`);
  console.log('================================');
  console.log('');
  console.log('📊 REST API Endpoints:');
  console.log(`  POST /api/contract/create`);
  console.log(`  POST /api/prediction/submit`);
  console.log(`  GET  /api/contract/:id`);
  console.log(`  GET  /api/predictions/:contractId`);
  console.log('');
  console.log('⚠️  NOTE: This is a MOCK service for testing');
  console.log('   For production, use real Linera CLI');
  console.log('');
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('🛑 Shutting down mock service...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🛑 Shutting down mock service...');
  process.exit(0);
});
