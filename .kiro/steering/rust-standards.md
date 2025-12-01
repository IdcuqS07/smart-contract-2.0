---
inclusion: always
---

# Rust Standards for Linera Smart Contracts

## Naming Conventions

- **Modules**: `snake_case` (e.g., `oracle_service`, `price_prediction`)
- **Structs/Enums**: `PascalCase` (e.g., `PredictionRequest`, `OracleResponse`)
- **Functions**: `snake_case` (e.g., `process_prediction`, `validate_input`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT`)
- **Type Parameters**: Single uppercase letter or `PascalCase` (e.g., `T`, `TResult`)

## Project Structure

```
linera-integration/
├── src/
│   ├── contract.rs    # Contract logic and operations
│   ├── service.rs     # GraphQL service and queries
│   ├── state.rs       # State management
│   └── lib.rs         # Module exports
├── Cargo.toml
└── README.md
```

## Error Handling

Always use `Result<T, E>` for fallible operations:

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum OracleError {
    #[error("Invalid prediction request: {0}")]
    InvalidRequest(String),
    
    #[error("Oracle service unavailable")]
    ServiceUnavailable,
    
    #[error("Timeout waiting for response")]
    Timeout,
}

// Usage
fn process_request(data: &str) -> Result<Response, OracleError> {
    validate_input(data)?;
    // ... processing
    Ok(response)
}
```

## State Management

- Use `#[derive(Clone, Debug, Serialize, Deserialize)]` for state structs
- Keep state minimal and efficient
- Use `BTreeMap` for ordered collections, `HashMap` for unordered

```rust
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct OracleState {
    pub predictions: BTreeMap<u64, PredictionResult>,
    pub request_count: u64,
    pub last_update: Timestamp,
}
```

## Linera-Specific Patterns

### Contract Operations

```rust
impl Contract for OracleContract {
    type Message = Message;
    type InstantiationArgument = ();
    type Parameters = ();

    async fn instantiate(&mut self, _argument: Self::InstantiationArgument) {
        // Initialize state
    }

    async fn execute_operation(&mut self, operation: Self::Operation) -> Self::Response {
        match operation {
            Operation::RequestPrediction { data } => {
                self.handle_prediction(data).await
            }
        }
    }
}
```

### Service Queries

```rust
impl Service for OracleService {
    async fn handle_query(&self, query: Self::Query) -> Self::QueryResponse {
        match query {
            Query::GetPrediction { id } => {
                self.state.predictions.get(&id).cloned()
            }
        }
    }
}
```

## Security Best Practices

- Validate all inputs before processing
- Use `saturating_add` for arithmetic to prevent overflow
- Implement rate limiting in contract logic
- Never expose private keys or sensitive data

```rust
fn validate_prediction_request(req: &PredictionRequest) -> Result<(), OracleError> {
    if req.data.is_empty() {
        return Err(OracleError::InvalidRequest("Empty data".into()));
    }
    if req.data.len() > MAX_DATA_SIZE {
        return Err(OracleError::InvalidRequest("Data too large".into()));
    }
    Ok(())
}
```

## Testing Standards

- Unit tests in same file with `#[cfg(test)]`
- Integration tests in `tests/` directory
- Use `tokio::test` for async tests

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_prediction_request() {
        let contract = OracleContract::default();
        let result = contract.process_prediction(test_data()).await;
        assert!(result.is_ok());
    }
}
```

## Documentation

- Add doc comments for all public items
- Include examples in doc comments
- Document error conditions

```rust
/// Processes a prediction request from the AI oracle.
///
/// # Arguments
/// * `data` - The input data for prediction
///
/// # Returns
/// * `Ok(PredictionResult)` - Successful prediction
/// * `Err(OracleError)` - If validation fails or service unavailable
///
/// # Example
/// ```
/// let result = contract.process_prediction("BTC,50000").await?;
/// ```
pub async fn process_prediction(&self, data: &str) -> Result<PredictionResult, OracleError> {
    // Implementation
}
```
