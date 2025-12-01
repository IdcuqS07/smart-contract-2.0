---
inclusion: always
---

# Linera-Specific Development Patterns

## Application Structure

```rust
// src/lib.rs
use linera_sdk::{
    base::{ChainId, Owner, Timestamp},
    Contract, Service,
};

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ApplicationState {
    pub owner: Owner,
    pub data: BTreeMap<String, String>,
    pub created_at: Timestamp,
}
```

## Contract Operations

### Define Operations

```rust
#[derive(Debug, Serialize, Deserialize)]
pub enum Operation {
    RequestPrediction { symbol: String, timeframe: String },
    UpdatePrediction { id: u64, result: PredictionResult },
    CancelPrediction { id: u64 },
}

#[derive(Debug, Serialize, Deserialize)]
pub enum Message {
    PredictionCompleted { id: u64, result: PredictionResult },
}
```

### Implement Contract

```rust
impl Contract for OracleContract {
    type Message = Message;
    type InstantiationArgument = Owner;
    type Parameters = ();

    async fn instantiate(&mut self, owner: Self::InstantiationArgument) {
        self.state.owner = owner;
        self.state.created_at = Timestamp::now();
    }

    async fn execute_operation(&mut self, operation: Self::Operation) -> Self::Response {
        match operation {
            Operation::RequestPrediction { symbol, timeframe } => {
                self.handle_prediction_request(symbol, timeframe).await
            }
            Operation::UpdatePrediction { id, result } => {
                self.handle_prediction_update(id, result).await
            }
            Operation::CancelPrediction { id } => {
                self.handle_prediction_cancel(id).await
            }
        }
    }

    async fn execute_message(&mut self, message: Self::Message) {
        match message {
            Message::PredictionCompleted { id, result } => {
                self.handle_prediction_completed(id, result).await
            }
        }
    }
}
```

## Service Queries

### Define Queries

```rust
#[derive(Debug, Serialize, Deserialize)]
pub enum Query {
    GetPrediction { id: u64 },
    GetPredictions { symbol: Option<String>, limit: u32 },
    GetStats,
}

#[derive(Debug, Serialize, Deserialize)]
pub enum QueryResponse {
    Prediction(Option<PredictionResult>),
    Predictions(Vec<PredictionResult>),
    Stats(Statistics),
}
```

### Implement Service

```rust
impl Service for OracleService {
    type Query = Query;
    type QueryResponse = QueryResponse;

    async fn handle_query(&self, query: Self::Query) -> Self::QueryResponse {
        match query {
            Query::GetPrediction { id } => {
                let prediction = self.state.predictions.get(&id).cloned();
                QueryResponse::Prediction(prediction)
            }
            Query::GetPredictions { symbol, limit } => {
                let predictions = self.get_filtered_predictions(symbol, limit);
                QueryResponse::Predictions(predictions)
            }
            Query::GetStats => {
                let stats = self.calculate_statistics();
                QueryResponse::Stats(stats)
            }
        }
    }
}
```

## GraphQL Integration

### Query Linera Chain

```javascript
const { GraphQLClient } = require('graphql-request');

const client = new GraphQLClient(process.env.LINERA_GRAPHQL_URL);

async function queryChainState(chainId) {
  const query = `
    query {
      chain(chainId: "${chainId}") {
        executionState {
          system {
            balance
            timestamp
            description
          }
        }
      }
    }
  `;
  
  return await client.request(query);
}

async function executeOperation(chainId, operation) {
  const mutation = `
    mutation {
      executeOperation(
        chainId: "${chainId}"
        operation: ${JSON.stringify(operation)}
      ) {
        hash
      }
    }
  `;
  
  return await client.request(mutation);
}
```

### Subscribe to Events

```javascript
const { createClient } = require('graphql-ws');
const WebSocket = require('ws');

const wsClient = createClient({
  url: process.env.LINERA_WS_URL,
  webSocketImpl: WebSocket,
});

function subscribeToChain(chainId, callback) {
  return wsClient.subscribe(
    {
      query: `
        subscription {
          notifications(chainId: "${chainId}") {
            reason
            chainId
            height
          }
        }
      `,
    },
    {
      next: callback,
      error: (err) => console.error('Subscription error:', err),
      complete: () => console.log('Subscription complete'),
    }
  );
}
```

## Cross-Chain Communication

```rust
// Send message to another chain
pub async fn send_cross_chain_message(
    &mut self,
    target_chain: ChainId,
    message: Message,
) -> Result<(), OracleError> {
    self.runtime
        .send_message(target_chain, message)
        .await
        .map_err(|e| OracleError::CrossChainError(e.to_string()))?;
    
    Ok(())
}

// Handle incoming cross-chain message
async fn execute_message(&mut self, message: Self::Message) {
    match message {
        Message::PredictionCompleted { id, result } => {
            // Update local state with cross-chain result
            self.state.predictions.insert(id, result);
        }
    }
}
```

## State Management Best Practices

```rust
use std::collections::BTreeMap;

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct OracleState {
    // Use BTreeMap for ordered, deterministic iteration
    pub predictions: BTreeMap<u64, PredictionResult>,
    
    // Counter for generating IDs
    pub next_id: u64,
    
    // Metadata
    pub total_requests: u64,
    pub successful_predictions: u64,
    pub failed_predictions: u64,
    
    // Timestamps
    pub created_at: Timestamp,
    pub last_updated: Timestamp,
}

impl OracleState {
    pub fn new(owner: Owner) -> Self {
        Self {
            predictions: BTreeMap::new(),
            next_id: 1,
            total_requests: 0,
            successful_predictions: 0,
            failed_predictions: 0,
            created_at: Timestamp::now(),
            last_updated: Timestamp::now(),
        }
    }
    
    pub fn add_prediction(&mut self, result: PredictionResult) -> u64 {
        let id = self.next_id;
        self.predictions.insert(id, result);
        self.next_id = self.next_id.saturating_add(1);
        self.total_requests = self.total_requests.saturating_add(1);
        self.last_updated = Timestamp::now();
        id
    }
}
```

## Error Handling

```rust
use thiserror::Error;

#[derive(Error, Debug, Serialize, Deserialize)]
pub enum OracleError {
    #[error("Invalid prediction request: {0}")]
    InvalidRequest(String),
    
    #[error("Prediction not found: {0}")]
    NotFound(u64),
    
    #[error("Unauthorized: {0}")]
    Unauthorized(String),
    
    #[error("Rate limit exceeded")]
    RateLimitExceeded,
    
    #[error("Cross-chain communication error: {0}")]
    CrossChainError(String),
    
    #[error("Internal error: {0}")]
    Internal(String),
}

// Use in contract
fn validate_request(&self, request: &PredictionRequest) -> Result<(), OracleError> {
    if request.symbol.is_empty() {
        return Err(OracleError::InvalidRequest("Symbol cannot be empty".into()));
    }
    
    if request.symbol.len() > 10 {
        return Err(OracleError::InvalidRequest("Symbol too long".into()));
    }
    
    Ok(())
}
```

## Testing Patterns

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use linera_sdk::test::*;

    #[tokio::test]
    async fn test_prediction_request() {
        let mut contract = OracleContract::default();
        
        let operation = Operation::RequestPrediction {
            symbol: "BTC".to_string(),
            timeframe: "1h".to_string(),
        };
        
        let response = contract.execute_operation(operation).await;
        assert!(response.is_ok());
    }
    
    #[tokio::test]
    async fn test_invalid_request() {
        let mut contract = OracleContract::default();
        
        let operation = Operation::RequestPrediction {
            symbol: "".to_string(),
            timeframe: "1h".to_string(),
        };
        
        let response = contract.execute_operation(operation).await;
        assert!(response.is_err());
    }
}
```
