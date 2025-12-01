# 🚀 Full Linera Integration Guide

Complete guide untuk mengintegrasikan Smart Contract 2.0 dengan Linera blockchain.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Build & Deploy](#build--deploy)
4. [Testing](#testing)
5. [Architecture](#architecture)
6. [API Reference](#api-reference)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

```bash
# 1. Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown

# 2. Linera CLI
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera
sudo mv linera /usr/local/bin/

# 3. Node.js (v18+)
# Download from https://nodejs.org/

# 4. Python 3.8+
python3 --version
```

### Verify Installation

```bash
rustc --version
cargo --version
linera --version
node --version
python3 --version
```

---

## Installation

### 1. Clone Repository

```bash
git clone https://github.com/IdcuqS07/smart-contract-2.0.git
cd smart-contract-2.0
```

### 2. Install Dependencies

```bash
# Install Node.js dependencies
cd linera-integration/oracle-client
npm install
cd ../..

# Install Python dependencies
cd ai-engine
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cd ..
```

---

## Build & Deploy

### Quick Start (Automated)

```bash
# Full deployment in one command
./linera-integration/scripts/full-deploy.sh
```

### Manual Deployment

#### Step 1: Build Smart Contract

```bash
cd linera-integration

# Clean previous builds
cargo clean

# Build for WASM
cargo build --release --target wasm32-unknown-unknown
```

#### Step 2: Initialize Linera Wallet

```bash
# Create new wallet with chain
linera wallet init --with-new-chain

# Check wallet
linera wallet show
```

#### Step 3: Start Linera Service

```bash
# Start local node
linera service --port 8080

# In another terminal, verify
curl http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chains { list } }"}'
```

#### Step 4: Deploy Contract

```bash
cd linera-integration

# Deploy contract and service
linera publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_service.wasm \
  --json-argument "null"

# Save the Application ID from output
```

#### Step 5: Configure Services

Create `linera-integration/deployment-config.json`:

```json
{
  "applicationId": "YOUR_APPLICATION_ID",
  "chainId": "YOUR_CHAIN_ID",
  "graphqlEndpoint": "http://localhost:8080/graphql",
  "wsEndpoint": "ws://localhost:8080/ws",
  "aiEngineUrl": "http://localhost:5001"
}
```

---

## Testing

### Start All Services

```bash
# Start everything
./scripts/start-full-integration.sh

# Services will run on:
# - AI Engine: http://localhost:5001
# - Linera: http://localhost:8080
# - Oracle: http://localhost:3001
```

### Run Integration Tests

```bash
cd linera-integration/oracle-client
node full-integration.js
```

### Test Individual Components

#### Test AI Engine

```bash
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{
    "model_type": "price_prediction",
    "data": {"symbol": "BTC", "timeframe": "1h"}
  }'
```

#### Test Linera GraphQL

```bash
# Query chains
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chains { list } }"}'

# Query contract
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { application(chainId: \"YOUR_CHAIN\", id: \"YOUR_APP\") { contract(id: 1) { id creator contract_type } } }"
  }'
```

#### Test Oracle Client

```bash
cd linera-integration/oracle-client
node test.js
```

### Stop All Services

```bash
./scripts/stop-all-services.sh
```

---

## Architecture

### System Overview

```
┌─────────────┐
│   Frontend  │
│  (Browser)  │
└──────┬──────┘
       │
       ├──────────────┐
       │              │
       v              v
┌─────────────┐  ┌──────────────┐
│   Oracle    │  │   Linera     │
│   Service   │◄─┤   GraphQL    │
└──────┬──────┘  └──────┬───────┘
       │                │
       v                v
┌─────────────┐  ┌──────────────┐
│ AI Engine   │  │   Smart      │
│  (Python)   │  │  Contract    │
└─────────────┘  └──────────────┘
```

### Data Flow

1. **User Request** → Frontend sends prediction request
2. **Oracle Processing** → Oracle receives and validates request
3. **AI Prediction** → AI Engine generates prediction
4. **Blockchain Submission** → Oracle submits to Linera
5. **Smart Contract** → Contract validates and stores
6. **Auto-Execution** → Contract executes if threshold met
7. **Event Emission** → Events broadcast to subscribers
8. **Frontend Update** → UI updates with results

### Smart Contract Operations

```rust
pub enum Operation {
    // Create new adaptive contract
    CreateAdaptiveContract {
        contract_type: String,
        threshold: u64,
    },
    
    // Submit AI prediction
    SubmitAIPrediction {
        contract_id: u64,
        prediction_type: String,
        value: i64,
        confidence: u8,
    },
    
    // Authorize oracle
    AuthorizeOracle {
        oracle_address: String,
    },
}
```

---

## API Reference

### Oracle Client API

#### Create Contract

```javascript
const oracle = new LineraOracleClient(config);

const result = await oracle.createAdaptiveContract(
  'price_prediction',  // contract type
  50000               // threshold
);

// Returns: { success, contractId, hash }
```

#### Submit Prediction

```javascript
const result = await oracle.requestAndSubmitPrediction(
  contractId,          // contract ID
  'price_prediction',  // model type
  { symbol: 'BTC' }   // data
);

// Returns: { success, prediction, blockchain }
```

#### Query Contract

```javascript
const contract = await oracle.getContract(contractId);

// Returns: {
//   id, creator, contract_type, threshold,
//   is_active, created_at, last_updated
// }
```

#### Query Predictions

```javascript
const prediction = await oracle.getLatestPrediction(contractId);

// Returns: {
//   timestamp, prediction_type, value,
//   confidence, oracle
// }
```

### GraphQL Queries

#### Get Contract

```graphql
query GetContract($chainId: ChainId!, $appId: ApplicationId!, $id: Int!) {
  application(chainId: $chainId, id: $appId) {
    contract(id: $id) {
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

#### Get Predictions

```graphql
query GetPredictions($chainId: ChainId!, $appId: ApplicationId!, $contractId: Int!) {
  application(chainId: $chainId, id: $appId) {
    predictions(contract_id: $contractId) {
      timestamp
      prediction_type
      value
      confidence
      oracle
    }
  }
}
```

### GraphQL Mutations

#### Create Contract

```graphql
mutation CreateContract(
  $chainId: ChainId!,
  $appId: ApplicationId!,
  $type: String!,
  $threshold: Int!
) {
  executeOperation(
    chainId: $chainId,
    applicationId: $appId,
    operation: {
      CreateAdaptiveContract: {
        contract_type: $type,
        threshold: $threshold
      }
    }
  ) {
    hash
  }
}
```

#### Submit Prediction

```graphql
mutation SubmitPrediction(
  $chainId: ChainId!,
  $appId: ApplicationId!,
  $contractId: Int!,
  $type: String!,
  $value: Int!,
  $confidence: Int!
) {
  executeOperation(
    chainId: $chainId,
    applicationId: $appId,
    operation: {
      SubmitAIPrediction: {
        contract_id: $contractId,
        prediction_type: $type,
        value: $value,
        confidence: $confidence
      }
    }
  ) {
    hash
  }
}
```

---

## Troubleshooting

### Common Issues

#### 1. Linera CLI Not Found

```bash
# Install Linera
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera
sudo mv linera /usr/local/bin/
```

#### 2. Build Errors

```bash
# Update Rust
rustup update

# Add WASM target
rustup target add wasm32-unknown-unknown

# Clean and rebuild
cargo clean
cargo build --release --target wasm32-unknown-unknown
```

#### 3. Service Not Starting

```bash
# Check if port is in use
lsof -i :8080  # Linera
lsof -i :5001  # AI Engine
lsof -i :3001  # Oracle

# Kill process
kill -9 <PID>
```

#### 4. GraphQL Connection Error

```bash
# Verify Linera is running
curl http://localhost:8080/graphql

# Check logs
tail -f logs/linera.log
```

#### 5. AI Engine Not Responding

```bash
# Check Python environment
source ai-engine/venv/bin/activate
python --version

# Install dependencies
pip install -r ai-engine/requirements.txt

# Check logs
tail -f logs/ai-engine.log
```

### Debug Mode

Enable debug logging:

```bash
# Linera
RUST_LOG=debug linera service --port 8080

# AI Engine
LOG_LEVEL=DEBUG python ai-engine/main.py

# Oracle
DEBUG=* node linera-integration/oracle-client/server.js
```

### Check Service Health

```bash
# AI Engine
curl http://localhost:5001/health

# Oracle
curl http://localhost:3001/health

# Linera
curl http://localhost:8080/graphql \
  -d '{"query": "{ chains { list } }"}'
```

---

## Performance Metrics

### Expected Performance

- **Transaction Finality**: < 1 second
- **GraphQL Query**: < 100ms
- **AI Prediction**: < 3 seconds
- **End-to-End Flow**: < 5 seconds

### Monitoring

```bash
# Watch logs in real-time
tail -f logs/*.log

# Monitor system resources
top
htop
```

---

## Next Steps

1. **Deploy to Testnet**: Use `./scripts/deploy-testnet.sh`
2. **Add More Models**: Extend AI Engine with new models
3. **Improve UI**: Enhance frontend with React/Vue
4. **Add Monitoring**: Setup Prometheus/Grafana
5. **Security Audit**: Review and test security

---

## Resources

- [Linera Documentation](https://linera.dev)
- [Linera SDK](https://docs.rs/linera-sdk)
- [GraphQL Spec](https://graphql.org)
- [Project Repository](https://github.com/IdcuqS07/smart-contract-2.0)

---

## Support

- **Issues**: https://github.com/IdcuqS07/smart-contract-2.0/issues
- **Discussions**: https://github.com/IdcuqS07/smart-contract-2.0/discussions

---

**Made with ❤️ for Linera Blockchain**
