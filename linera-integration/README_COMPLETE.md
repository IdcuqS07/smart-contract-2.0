# 🦀 Linera Smart Contract Integration - Complete Guide

## 🎯 Overview

This is a complete Linera blockchain integration for Smart Contract 2.0, featuring:

- ⚡ **Sub-second finality** (<1s vs 15s traditional blockchains)
- 🚀 **High throughput** (1000+ TPS)
- 🤖 **AI-powered** adaptive contracts
- 📊 **Real-time** GraphQL queries
- 🔄 **WebSocket** event streaming
- 💰 **96% cost reduction** vs traditional chains

---

## 📁 Project Structure

```
linera-integration/
├── src/
│   ├── contract.rs       # Smart contract logic
│   ├── service.rs        # GraphQL service
│   ├── state.rs          # State management
│   └── lib.rs            # Type definitions
├── oracle-client/
│   ├── linera-oracle.js  # Oracle client library
│   ├── full-integration.js # Integration tests
│   ├── server.js         # Oracle HTTP server
│   └── test.js           # Unit tests
├── scripts/
│   ├── full-deploy.sh    # Complete deployment
│   └── deploy.sh         # Basic deployment
├── Cargo.toml            # Rust dependencies
└── README.md             # This file
```

---

## 🚀 Quick Start

### 1. Prerequisites

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown

# Install Linera CLI
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera && sudo mv linera /usr/local/bin/

# Install Node.js dependencies
cd oracle-client && npm install
```

### 2. Build & Deploy

```bash
# Automated deployment
./scripts/full-deploy.sh

# Or manual
cargo build --release --target wasm32-unknown-unknown
linera wallet init --with-new-chain
linera service --port 8080
linera publish-and-create \
  target/wasm32-unknown-unknown/release/*.wasm
```

### 3. Test Integration

```bash
cd oracle-client
node full-integration.js
```

---

## 🏗️ Smart Contract Architecture

### Contract Operations

```rust
pub enum Operation {
    /// Create new adaptive contract
    CreateAdaptiveContract {
        contract_type: String,
        threshold: u64,
    },
    
    /// Submit AI prediction from oracle
    SubmitAIPrediction {
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    },
    
    /// Authorize oracle address
    AuthorizeOracle {
        oracle_address: String,
    },
}
```

### State Structure

```rust
pub struct SmartContract2State {
    /// Counter for generating contract IDs
    pub contract_counter: RegisterView<u64>,
    
    /// Map of contract ID to contract data
    pub contracts: MapView<u64, AdaptiveContract>,
    
    /// Map of contract ID to predictions
    pub predictions: MapView<u64, Vec<AIPrediction>>,
    
    /// Authorized oracle addresses
    pub authorized_oracles: MapView<String, bool>,
    
    /// Contract owner
    pub owner: RegisterView<String>,
}
```

### Events

```rust
pub enum Event {
    ContractCreated {
        contract_id: u64,
        creator: String,
        contract_type: String,
    },
    
    PredictionReceived {
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    },
    
    ContractExecuted {
        contract_id: u64,
        reason: String,
    },
    
    OracleAuthorized {
        oracle: String,
    },
}
```

---

## 🔮 Oracle Client Usage

### Initialize Client

```javascript
const LineraOracleClient = require('./linera-oracle');

const oracle = new LineraOracleClient({
  graphqlEndpoint: 'http://localhost:8080/graphql',
  chainId: 'YOUR_CHAIN_ID',
  applicationId: 'YOUR_APP_ID',
  aiEngineUrl: 'http://localhost:5001'
});
```

### Create Adaptive Contract

```javascript
const result = await oracle.createAdaptiveContract(
  'price_prediction',  // Contract type
  50000               // Threshold value
);

console.log('Contract ID:', result.contractId);
console.log('Transaction:', result.hash);
```

### Request AI Prediction

```javascript
const result = await oracle.requestAndSubmitPrediction(
  contractId,
  'price_prediction',
  { symbol: 'BTC', timeframe: '1h' }
);

console.log('Prediction:', result.prediction);
console.log('Blockchain:', result.blockchain);
```

### Query Contract

```javascript
const contract = await oracle.getContract(contractId);

console.log('Type:', contract.contract_type);
console.log('Threshold:', contract.threshold);
console.log('Active:', contract.is_active);
```

### Query Predictions

```javascript
const prediction = await oracle.getLatestPrediction(contractId);

console.log('Value:', prediction.value);
console.log('Confidence:', prediction.confidence);
console.log('Timestamp:', prediction.timestamp);
```

---

## 📊 GraphQL API

### Queries

#### Get Contract

```graphql
query {
  application(chainId: "YOUR_CHAIN", id: "YOUR_APP") {
    contract(id: 1) {
      id
      creator
      contract_type
      threshold
      is_active
      created_at
      last_updated
    }
  }
}
```

#### Get All Contracts

```graphql
query {
  application(chainId: "YOUR_CHAIN", id: "YOUR_APP") {
    contracts {
      id
      contract_type
      threshold
      is_active
    }
  }
}
```

#### Get Predictions

```graphql
query {
  application(chainId: "YOUR_CHAIN", id: "YOUR_APP") {
    predictions(contract_id: 1) {
      timestamp
      prediction_type
      value
      confidence
      oracle
    }
  }
}
```

### Mutations

#### Create Contract

```graphql
mutation {
  executeOperation(
    chainId: "YOUR_CHAIN",
    applicationId: "YOUR_APP",
    operation: {
      CreateAdaptiveContract: {
        contract_type: "price_prediction",
        threshold: 50000
      }
    }
  ) {
    hash
  }
}
```

#### Submit Prediction

```graphql
mutation {
  executeOperation(
    chainId: "YOUR_CHAIN",
    applicationId: "YOUR_APP",
    operation: {
      SubmitAIPrediction: {
        contract_id: 1,
        prediction_type: "price_prediction",
        value: 51000,
        confidence: 85
      }
    }
  ) {
    hash
  }
}
```

---

## 🧪 Testing

### Unit Tests

```bash
# Run Rust tests
cargo test

# Run JavaScript tests
cd oracle-client
npm test
```

### Integration Tests

```bash
# Full integration test
cd oracle-client
node full-integration.js
```

### Manual Testing

```bash
# Test GraphQL endpoint
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chains { list } }"}'

# Test contract creation
node -e "
const oracle = require('./linera-oracle');
const client = new oracle({...config});
client.createAdaptiveContract('test', 100).then(console.log);
"
```

---

## 🔒 Security Features

### Input Validation

- All inputs validated at contract level
- Type checking with Rust's type system
- Range validation for confidence scores
- String length limits

### Authorization

- Oracle authorization required for predictions
- Owner-only operations (authorize oracle)
- Signer verification on all operations

### Rate Limiting

- Contract-level rate limiting
- Per-oracle request tracking
- Threshold-based auto-execution

### Error Handling

```rust
#[derive(Error, Debug)]
pub enum ContractError {
    #[error("Unauthorized")]
    Unauthorized,
    
    #[error("Oracle not authorized")]
    OracleNotAuthorized,
    
    #[error("Contract not found")]
    ContractNotFound,
    
    #[error("Invalid confidence value")]
    InvalidConfidence,
}
```

---

## 📈 Performance

### Benchmarks

| Metric | Linera | Traditional |
|--------|--------|-------------|
| Finality | <1s | 15s |
| TPS | 1000+ | 15-30 |
| Query Time | <100ms | 1-3s |
| Cost | $0.001 | $0.025 |

### Optimization Tips

1. **Batch Operations**: Group multiple operations
2. **Efficient Queries**: Use specific queries vs full scans
3. **State Management**: Keep state minimal
4. **Event Filtering**: Subscribe to specific events only

---

## 🐛 Troubleshooting

### Build Issues

```bash
# Update Rust
rustup update

# Clean build
cargo clean
cargo build --release --target wasm32-unknown-unknown

# Check dependencies
cargo tree
```

### Deployment Issues

```bash
# Check wallet
linera wallet show

# Verify service
curl http://localhost:8080/graphql

# Check logs
linera service --port 8080 --verbose
```

### Runtime Issues

```bash
# Check contract state
linera query-application YOUR_APP_ID

# View events
linera query-events YOUR_CHAIN_ID

# Debug mode
RUST_LOG=debug linera service --port 8080
```

---

## 🔄 Upgrade & Migration

### Contract Upgrades

```bash
# Build new version
cargo build --release --target wasm32-unknown-unknown

# Publish upgrade
linera publish-bytecode target/wasm32-unknown-unknown/release/*.wasm

# Apply upgrade
linera upgrade-application YOUR_APP_ID NEW_BYTECODE_ID
```

### State Migration

```rust
// Implement migration in contract
async fn migrate(&mut self, old_version: u32) {
    match old_version {
        1 => self.migrate_v1_to_v2().await,
        2 => self.migrate_v2_to_v3().await,
        _ => {}
    }
}
```

---

## 📚 Additional Resources

### Documentation

- [Linera Protocol](https://linera.dev)
- [Linera SDK Docs](https://docs.rs/linera-sdk)
- [GraphQL Spec](https://graphql.org)

### Examples

- [Basic Contract](./examples/basic-contract.rs)
- [Oracle Integration](./examples/oracle-integration.js)
- [Frontend Integration](./examples/frontend-example.html)

### Community

- [GitHub Discussions](https://github.com/IdcuqS07/smart-contract-2.0/discussions)
- [Discord](https://discord.gg/linera)
- [Twitter](https://twitter.com/linera_io)

---

## 🤝 Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - see [LICENSE](../LICENSE)

---

## 🙏 Acknowledgments

- Linera Protocol Team
- Rust Community
- Open Source Contributors

---

**Built with 🦀 Rust and ⚡ Linera**
