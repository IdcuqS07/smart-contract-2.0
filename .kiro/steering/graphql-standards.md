---
inclusion: always
---

# GraphQL Standards for Linera Integration

## Schema Design

### Type Definitions

```graphql
type Prediction {
  id: ID!
  symbol: String!
  predictedPrice: Float!
  confidence: Float!
  timestamp: String!
  status: PredictionStatus!
}

enum PredictionStatus {
  PENDING
  PROCESSING
  COMPLETED
  FAILED
}

type Query {
  prediction(id: ID!): Prediction
  predictions(
    symbol: String
    limit: Int = 10
    offset: Int = 0
  ): [Prediction!]!
  latestPrediction(symbol: String!): Prediction
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
```

## Resolver Implementation

### Query Resolvers

```javascript
const resolvers = {
  Query: {
    prediction: async (_, { id }, { dataSources }) => {
      const prediction = await dataSources.predictionAPI.getPrediction(id);
      if (!prediction) {
        throw new Error('Prediction not found');
      }
      return prediction;
    },
    
    predictions: async (_, { symbol, limit, offset }, { dataSources }) => {
      return await dataSources.predictionAPI.getPredictions({
        symbol,
        limit,
        offset
      });
    },
    
    latestPrediction: async (_, { symbol }, { dataSources }) => {
      const predictions = await dataSources.predictionAPI.getPredictions({
        symbol,
        limit: 1
      });
      return predictions[0] || null;
    }
  }
};
```

### Mutation Resolvers

```javascript
const resolvers = {
  Mutation: {
    requestPrediction: async (_, { symbol, timeframe }, context) => {
      // Validate input
      if (!['1m', '5m', '15m', '1h', '4h', '1d'].includes(timeframe)) {
        throw new ValidationError('Invalid timeframe');
      }
      
      // Create prediction request
      const prediction = await context.dataSources.predictionAPI.create({
        symbol,
        timeframe,
        status: 'PENDING'
      });
      
      // Trigger AI processing
      await context.services.ai.processPrediction(prediction.id);
      
      // Publish to subscribers
      context.pubsub.publish('PREDICTION_UPDATED', {
        predictionUpdated: prediction,
        symbol
      });
      
      return prediction;
    }
  }
};
```

### Subscription Resolvers

```javascript
const { PubSub } = require('graphql-subscriptions');
const pubsub = new PubSub();

const resolvers = {
  Subscription: {
    predictionUpdated: {
      subscribe: (_, { symbol }) => {
        return pubsub.asyncIterator(['PREDICTION_UPDATED']);
      },
      resolve: (payload, { symbol }) => {
        // Filter by symbol
        if (payload.symbol === symbol) {
          return payload.predictionUpdated;
        }
        return null;
      }
    }
  }
};
```

## Error Handling

```javascript
const { ApolloError } = require('apollo-server-express');

class ValidationError extends ApolloError {
  constructor(message) {
    super(message, 'VALIDATION_ERROR');
  }
}

class NotFoundError extends ApolloError {
  constructor(message) {
    super(message, 'NOT_FOUND');
  }
}

// Use in resolvers
if (!prediction) {
  throw new NotFoundError('Prediction not found');
}
```

## DataSources

```javascript
const { RESTDataSource } = require('apollo-datasource-rest');

class PredictionAPI extends RESTDataSource {
  constructor() {
    super();
    this.baseURL = process.env.AI_ENGINE_URL;
  }
  
  async getPrediction(id) {
    return this.get(`/predictions/${id}`);
  }
  
  async getPredictions({ symbol, limit, offset }) {
    return this.get('/predictions', {
      symbol,
      limit,
      offset
    });
  }
  
  async create(prediction) {
    return this.post('/predictions', prediction);
  }
}
```

## Context Setup

```javascript
const server = new ApolloServer({
  typeDefs,
  resolvers,
  context: ({ req }) => ({
    user: req.user,
    dataSources: {
      predictionAPI: new PredictionAPI()
    },
    services: {
      ai: aiService
    },
    pubsub
  }),
  dataSources: () => ({
    predictionAPI: new PredictionAPI()
  })
});
```

## Linera-Specific Patterns

### Query Linera State

```javascript
const { GraphQLClient } = require('graphql-request');

const lineraClient = new GraphQLClient(process.env.LINERA_GRAPHQL_URL);

async function queryLineraState(chainId) {
  const query = `
    query {
      chain(chainId: "${chainId}") {
        executionState {
          system {
            balance
            timestamp
          }
        }
      }
    }
  `;
  
  return await lineraClient.request(query);
}
```

### Subscribe to Linera Events

```javascript
const { createClient } = require('graphql-ws');
const WebSocket = require('ws');

const wsClient = createClient({
  url: process.env.LINERA_WS_URL,
  webSocketImpl: WebSocket
});

function subscribeToLineraEvents(chainId) {
  return wsClient.subscribe({
    query: `
      subscription {
        notifications(chainId: "${chainId}") {
          reason
          chainId
        }
      }
    `
  }, {
    next: (data) => {
      console.log('Linera event:', data);
    },
    error: (error) => {
      console.error('Subscription error:', error);
    },
    complete: () => {
      console.log('Subscription complete');
    }
  });
}
```
