# 🛠️ Linera Development Guide

Complete guide untuk development dengan Linera SDK v0.15.6

## 📋 Prerequisites

✅ Rust toolchain installed
✅ wasm32-unknown-unknown target
✅ Linera SDK v0.15.6
✅ linera-storage-server

## 🚀 Quick Start

### 1. Start Local Network

```bash
linera net up
```

Output akan menampilkan:
- Validator endpoints
- Faucet URL
- Default chain IDs
- Wallet location

### 2. Build Smart Contract

```bash
cd linera-integration
cargo build --release --target wasm32-unknown-unknown
```

### 3. Deploy Contract

```bash
# Using quick start script
./scripts/quick-start.sh

# Or manually
linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm
```

### 4. Start GraphQL Service

```bash
linera service --port 8080
```

## 📁 Project Structure

```
linera-integration/
├── src/
│   ├── contract.rs      # Contract operations
│   ├── service.rs       # GraphQL service
│   ├── state.rs         # State management
│   └── lib.rs           # Module exports
├── scripts/
│   ├── quick-start.sh   # Quick deployment
│   └── deploy.sh        # Full deployment
├── Cargo.toml           # Dependencies
└── README.md            # Documentation
```

## 🔧 Development Workflow

### 1. Make Changes

Edit your contract code in `src/contract.rs`:

```rust
impl Contract for OracleContract {
    async fn execute_operation(&mut self, operation: Operation) -> Response {
        match operation {
            Operation::RequestPrediction { data } => {
                // Your logic here
            }
        }
    }
}
```

### 2. Build

```bash
cargo build --release --target wasm32-unknown-unknown
```

### 3. Test Locally

```bash
# Run unit tests
cargo test

# Run with test features
cargo test --features test
```

### 4. Deploy

```bash
linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm
```

### 5. Query via GraphQL

```bash
# Start service
linera service --port 8080

# Query in browser
open http://localhost:8080/graphql
```

## 📊 GraphQL Queries

### Get Chain State

```graphql
query {
  chain(chainId: "YOUR_CHAIN_ID") {
    executionState {
      system {
        balance
        timestamp
      }
    }
  }
}
```

### Execute Operation

```graphql
mutation {
  executeOperation(
    chainId: "YOUR_CHAIN_ID"
    operation: {
      requestPrediction: {
        data: "BTC,50000"
      }
    }
  ) {
    hash
  }
}
```

### Subscribe to Events

```graphql
subscription {
  notifications(chainId: "YOUR_CHAIN_ID") {
    reason
    chainId
    height
  }
}
```

## 🧪 Testing

### Unit Tests

```bash
cargo test
```

### Integration Tests

```bash
cargo test --features test
```

### Local Network Testing

```bash
# Terminal 1: Start network
linera net up

# Terminal 2: Deploy and test
cd linera-integration
./scripts/quick-start.sh

# Terminal 3: Start service
linera service --port 8080
```

## 🔍 Debugging

### Check Wallet

```bash
linera wallet show
```

### Check Chain State

```bash
linera query-balance
```

### View Logs

```bash
# With debug logging
RUST_LOG=debug linera service --port 8080

# With trace logging
RUST_LOG=trace linera service --port 8080
```

## 📦 Common Commands

### Wallet Management

```bash
# Show wallet
linera wallet show

# Get default chain
linera wallet default-chain

# Set default chain
linera wallet set-default-chain <CHAIN_ID>
```

### Chain Operations

```bash
# Query balance
linera query-balance

# Transfer tokens
linera transfer <AMOUNT> --to <CHAIN_ID>

# Create new chain
linera open-chain
```

### Application Management

```bash
# List applications
linera query-applications

# Get application details
linera query-application <APP_ID>
```

## 🐛 Troubleshooting

### Error: linera-storage-server not found

**Solution:**
```bash
cargo install --path /path/to/linera-protocol/linera-storage-service
```

### Error: Network not running

**Solution:**
```bash
linera net up
```

### Error: WASM build failed

**Solution:**
```bash
# Add wasm32 target
rustup target add wasm32-unknown-unknown

# Clean and rebuild
cargo clean
cargo build --release --target wasm32-unknown-unknown
```

### Error: Cannot connect to GraphQL

**Solution:**
```bash
# Check if service is running
ps aux | grep linera-service

# Restart service
linera service --port 8080
```

## 🎯 Best Practices

### 1. State Management

```rust
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct OracleState {
    // Use BTreeMap for deterministic ordering
    pub predictions: BTreeMap<u64, PredictionResult>,
    
    // Use saturating arithmetic
    pub counter: u64,
}

impl OracleState {
    pub fn increment(&mut self) {
        self.counter = self.counter.saturating_add(1);
    }
}
```

### 2. Error Handling

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum OracleError {
    #[error("Invalid request: {0}")]
    InvalidRequest(String),
    
    #[error("Not found: {0}")]
    NotFound(u64),
}
```

### 3. Input Validation

```rust
fn validate_request(data: &str) -> Result<(), OracleError> {
    if data.is_empty() {
        return Err(OracleError::InvalidRequest("Empty data".into()));
    }
    if data.len() > MAX_SIZE {
        return Err(OracleError::InvalidRequest("Data too large".into()));
    }
    Ok(())
}
```

### 4. Testing

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_operation() {
        let mut contract = OracleContract::default();
        let result = contract.execute_operation(operation).await;
        assert!(result.is_ok());
    }
}
```

## 📚 Resources

- [Linera Documentation](https://linera.dev)
- [Linera SDK Docs](https://docs.rs/linera-sdk)
- [GitHub Repository](https://github.com/linera-io/linera-protocol)
- [Discord Community](https://discord.gg/linera)

## 🔄 Update Workflow

### Update Linera SDK

```bash
# Update to latest version
cargo update -p linera-sdk

# Or specify version in Cargo.toml
linera-sdk = { git = "https://github.com/linera-io/linera-protocol.git", tag = "v0.15.6" }
```

### Rebuild After Update

```bash
cargo clean
cargo build --release --target wasm32-unknown-unknown
```

## 🎉 Next Steps

1. ✅ Setup complete
2. 📝 Write your contract logic
3. 🧪 Test thoroughly
4. 🚀 Deploy to testnet
5. 🌐 Deploy to mainnet

---

**Version:** Linera SDK v0.15.6
**Updated:** December 1, 2025
**Status:** Production Ready
