---
inclusion: always
---

# JavaScript/Node.js Standards for Oracle Service

## Modern ES6+ Syntax

Always use modern JavaScript features:

```javascript
// Use const/let, never var
const API_URL = 'http://localhost:5000';
let requestCount = 0;

// Arrow functions
const processRequest = async (data) => {
  return await fetchPrediction(data);
};

// Destructuring
const { symbol, timeframe, amount } = request.body;

// Template literals
const message = `Processing ${symbol} for ${timeframe}`;

// Spread operator
const config = { ...defaultConfig, ...userConfig };

// Optional chaining
const price = response?.data?.prediction?.price;

// Nullish coalescing
const timeout = config.timeout ?? 5000;
```

## Express.js API Standards

### Route Structure

```javascript
const express = require('express');
const router = express.Router();

// Middleware
const validateRequest = require('../middleware/validation');
const rateLimit = require('../middleware/rateLimit');

// Route with middleware
router.post('/predict',
  rateLimit,
  validateRequest,
  async (req, res) => {
    try {
      const { symbol, timeframe } = req.body;
      
      const result = await predictionService.predict({
        symbol,
        timeframe
      });
      
      res.json({
        success: true,
        data: result,
        timestamp: Date.now()
      });
      
    } catch (error) {
      res.status(500).json({
        success: false,
        error: error.message
      });
    }
  }
);

module.exports = router;
```

### Error Handling

```javascript
class OracleError extends Error {
  constructor(message, statusCode = 500) {
    super(message);
    this.name = 'OracleError';
    this.statusCode = statusCode;
  }
}

class ValidationError extends OracleError {
  constructor(message) {
    super(message, 400);
    this.name = 'ValidationError';
  }
}

// Error middleware
const errorHandler = (err, req, res, next) => {
  console.error(`[Error] ${err.name}: ${err.message}`);
  
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal server error';
  
  res.status(statusCode).json({
    success: false,
    error: message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
};

module.exports = { OracleError, ValidationError, errorHandler };
```

## GraphQL Standards

### Schema Definition

```javascript
const { gql } = require('apollo-server-express');

const typeDefs = gql`
  type Prediction {
    id: ID!
    symbol: String!
    predictedPrice: Float!
    confidence: Float!
    timestamp: String!
  }
  
  type Query {
    getPrediction(id: ID!): Prediction
    getLatestPredictions(limit: Int = 10): [Prediction!]!
  }
  
  type Mutation {
    requestPrediction(
      symbol: String!
      timeframe: String!
    ): Prediction!
  }
  
  type Subscription {
    predictionUpdated(symbol: String!): Prediction!
  }
`;
```

### Resolvers

```javascript
const resolvers = {
  Query: {
    getPrediction: async (_, { id }, context) => {
      const prediction = await context.db.predictions.findById(id);
      if (!prediction) {
        throw new Error('Prediction not found');
      }
      return prediction;
    },
    
    getLatestPredictions: async (_, { limit }, context) => {
      return await context.db.predictions
        .find()
        .sort({ timestamp: -1 })
        .limit(limit);
    }
  },
  
  Mutation: {
    requestPrediction: async (_, { symbol, timeframe }, context) => {
      // Validate input
      if (!symbol || !timeframe) {
        throw new ValidationError('Symbol and timeframe required');
      }
      
      // Process prediction
      const result = await context.services.ai.predict({
        symbol,
        timeframe
      });
      
      // Save to database
      const prediction = await context.db.predictions.create(result);
      
      // Publish subscription
      context.pubsub.publish('PREDICTION_UPDATED', {
        predictionUpdated: prediction,
        symbol
      });
      
      return prediction;
    }
  },
  
  Subscription: {
    predictionUpdated: {
      subscribe: (_, { symbol }, context) => {
        return context.pubsub.asyncIterator(['PREDICTION_UPDATED']);
      }
    }
  }
};

module.exports = resolvers;
```

## WebSocket Implementation

```javascript
const WebSocket = require('ws');

class OracleWebSocket {
  constructor(server) {
    this.wss = new WebSocket.Server({ server });
    this.clients = new Map();
    this.setupHandlers();
  }
  
  setupHandlers() {
    this.wss.on('connection', (ws, req) => {
      const clientId = this.generateClientId();
      this.clients.set(clientId, ws);
      
      console.log(`Client connected: ${clientId}`);
      
      ws.on('message', async (message) => {
        try {
          const data = JSON.parse(message);
          await this.handleMessage(ws, data);
        } catch (error) {
          ws.send(JSON.stringify({
            type: 'error',
            message: error.message
          }));
        }
      });
      
      ws.on('close', () => {
        this.clients.delete(clientId);
        console.log(`Client disconnected: ${clientId}`);
      });
      
      ws.on('error', (error) => {
        console.error(`WebSocket error: ${error.message}`);
      });
    });
  }
  
  async handleMessage(ws, data) {
    const { type, payload } = data;
    
    switch (type) {
      case 'subscribe':
        await this.handleSubscribe(ws, payload);
        break;
      case 'unsubscribe':
        await this.handleUnsubscribe(ws, payload);
        break;
      default:
        throw new Error(`Unknown message type: ${type}`);
    }
  }
  
  broadcast(data, filter = null) {
    const message = JSON.stringify(data);
    
    this.clients.forEach((ws, clientId) => {
      if (ws.readyState === WebSocket.OPEN) {
        if (!filter || filter(clientId)) {
          ws.send(message);
        }
      }
    });
  }
  
  generateClientId() {
    return `client_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}

module.exports = OracleWebSocket;
```

## Security Patterns

### Input Validation

```javascript
const Joi = require('joi');

const predictionSchema = Joi.object({
  symbol: Joi.string()
    .uppercase()
    .min(2)
    .max(10)
    .required(),
  
  timeframe: Joi.string()
    .valid('1m', '5m', '15m', '1h', '4h', '1d')
    .required(),
  
  amount: Joi.number()
    .positive()
    .optional()
});

const validatePredictionRequest = (req, res, next) => {
  const { error, value } = predictionSchema.validate(req.body);
  
  if (error) {
    return res.status(400).json({
      success: false,
      error: error.details[0].message
    });
  }
  
  req.validatedData = value;
  next();
};
```

### Rate Limiting

```javascript
const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

const predictionLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 10, // 10 predictions per minute
  message: 'Prediction rate limit exceeded',
  keyGenerator: (req) => {
    return req.ip + ':' + (req.body?.symbol || 'unknown');
  }
});

module.exports = { apiLimiter, predictionLimiter };
```

### Authentication

```javascript
const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({
      success: false,
      error: 'Authentication required'
    });
  }
  
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        error: 'Invalid or expired token'
      });
    }
    
    req.user = user;
    next();
  });
};

module.exports = authenticateToken;
```

## Testing Standards

```javascript
const request = require('supertest');
const app = require('../app');

describe('Oracle API', () => {
  describe('POST /api/predict', () => {
    it('should return prediction for valid request', async () => {
      const response = await request(app)
        .post('/api/predict')
        .send({
          symbol: 'BTC',
          timeframe: '1h'
        })
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('predictedPrice');
      expect(response.body.data).toHaveProperty('confidence');
    });
    
    it('should return 400 for invalid symbol', async () => {
      const response = await request(app)
        .post('/api/predict')
        .send({
          symbol: 'X',
          timeframe: '1h'
        })
        .expect(400);
      
      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('symbol');
    });
  });
});
```

## Documentation

```javascript
/**
 * Process prediction request from AI engine
 * 
 * @param {Object} request - Prediction request
 * @param {string} request.symbol - Cryptocurrency symbol
 * @param {string} request.timeframe - Time interval
 * @param {number} [request.amount] - Optional amount for calculation
 * @returns {Promise<Object>} Prediction result
 * @throws {ValidationError} If input is invalid
 * @throws {OracleError} If prediction fails
 * 
 * @example
 * const result = await processPrediction({
 *   symbol: 'BTC',
 *   timeframe: '1h'
 * });
 */
async function processPrediction(request) {
  // Implementation
}
```
