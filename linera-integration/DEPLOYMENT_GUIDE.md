# 🚀 Smart Contract 2.0 - Deployment Guide

## ✅ Build Status

The smart contract has been successfully compiled to WebAssembly:
- **WASM File**: `target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm`
- **Size**: ~201 KB
- **Status**: Ready for deployment

## 📋 Prerequisites

1. **Linera CLI installed**
   ```bash
   linera --version
   ```

2. **Wallet configured**
   ```bash
   linera wallet show
   ```

3. **WASM bytecode built**
   ```bash
   cd linera-integration
   cargo build --release --target wasm32-unknown-unknown
   ```

## 🎯 Deployment Options

### Option 1: Deploy to Local Devnet (Recommended for Testing)

Start a local Linera network:

```bash
# Terminal 1: Start devnet
linera net up --testing-prng-seed 37

# Terminal 2: Deploy application
cd linera-integration
linera project publish-and-create .
```

### Option 2: Deploy to Linera Testnet

```bash
cd linera-integration

# Publish and create application
linera project publish-and-create .

# The output will show your Application ID
# Example: e476187f6ddfeb9d588c7b45d3df334d5501d6499b3f9ad5595cae86cce16a65010000000000000000000000
```

### Option 3: Manual Deployment Steps

If `publish-and-create` doesn't work, try manual steps:

```bash
# 1. Publish the module
linera publish-module \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm

# 2. Create application (use the bytecode ID from step 1)
linera create-application <BYTECODE_ID>
```

## 🔧 Start GraphQL Service

After deployment, start the GraphQL service to interact with your contract:

```bash
# Start on port 8080
linera service --port 8080

# Or specify a different port
linera service --port 9000
```

The GraphQL endpoint will be available at: `http://localhost:8080/graphql`

## 📡 Testing the Deployment

### 1. Query All Contracts

```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ contracts { id creator contractType threshold isActive createdAt } }"
  }'
```

### 2. Create a New Contract

```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { createContract(contractType: \"price_prediction\", threshold: 1000) { id creator contractType threshold isActive } }"
  }'
```

### 3. Get Specific Contract

```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ contract(id: 1) { id creator contractType threshold isActive predictions { timestamp predictionType value confidence } } }"
  }'
```

## 🎮 Using the Web Interface

After starting the GraphQL service, you can use the GraphQL Playground:

1. Open browser: `http://localhost:8080/graphql`
2. Try example queries in the playground
3. Explore the schema documentation

## 📝 Application Operations

### Create Adaptive Contract

```graphql
mutation {
  createAdaptiveContract(
    contractType: "price_prediction"
    threshold: 5000
  ) {
    id
    creator
    contractType
    threshold
    isActive
    createdAt
  }
}
```

### Submit AI Prediction

```graphql
mutation {
  submitAIPrediction(
    contractId: 1
    predictionType: "BTC_PRICE"
    value: 50000
    confidence: 85
  ) {
    success
    message
  }
}
```

### Authorize Oracle

```graphql
mutation {
  authorizeOracle(
    oracleAddress: "0xbfb3ef28b659ce0a425e0b65b4db154e364d05866de23fea8de3a3fd994ebb7a"
  ) {
    success
    message
  }
}
```

## 🔍 Monitoring

### Check Application Status

```bash
linera query-application <APPLICATION_ID>
```

### View Chain State

```bash
linera wallet show
```

### Check Blocks

```bash
linera query-chain <CHAIN_ID>
```

## 🐛 Troubleshooting

### Issue: "Not a directory" error

**Solution**: Make sure you're running `linera project publish-and-create` from the project root directory (where Cargo.toml is located), not passing the WASM file path.

```bash
# ❌ Wrong
linera project publish-and-create target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm

# ✅ Correct
cd linera-integration
linera project publish-and-create .
```

### Issue: "Module not found" error

**Solution**: Rebuild the WASM bytecode:

```bash
cargo clean
cargo build --release --target wasm32-unknown-unknown
```

### Issue: GraphQL service won't start

**Solution**: Check if port is already in use:

```bash
# Check port 8080
lsof -i :8080

# Kill process if needed
kill -9 <PID>

# Start on different port
linera service --port 9000
```

### Issue: Wallet not found

**Solution**: Initialize a new wallet:

```bash
linera wallet init --with-new-chain
```

## 📊 Expected Output

### Successful Deployment

```
✅ Application deployed successfully!

Application ID: e476187f6ddfeb9d588c7b45d3df334d5501d6499b3f9ad5595cae86cce16a65010000000000000000000000
Chain ID: 23db34dcbdbf832798b977b48248733e0505abab109466eee41da8fb2171dc3b
```

### GraphQL Service Running

```
GraphQL service running at http://localhost:8080/graphql
WebSocket endpoint: ws://localhost:8080/ws
```

## 🔗 Integration with Oracle Service

After deployment, update your oracle service configuration:

```javascript
// oracle-service/config.js
module.exports = {
  LINERA_GRAPHQL_URL: 'http://localhost:8080/graphql',
  LINERA_WS_URL: 'ws://localhost:8080/ws',
  APPLICATION_ID: 'YOUR_APPLICATION_ID_HERE',
  CHAIN_ID: 'YOUR_CHAIN_ID_HERE'
};
```

## 📚 Next Steps

1. ✅ Deploy smart contract
2. ✅ Start GraphQL service
3. 🔄 Test contract operations
4. 🔄 Integrate with Oracle service
5. 🔄 Connect AI engine
6. 🔄 Deploy frontend
7. 🔄 Full end-to-end testing

## 🎉 Success Criteria

- [x] Smart contract compiles to WASM
- [ ] Application deployed to Linera
- [ ] GraphQL service running
- [ ] Can query contract state
- [ ] Can execute operations
- [ ] Oracle integration working
- [ ] AI predictions flowing through

---

**Status**: Smart contract built and ready for deployment! 🚀
