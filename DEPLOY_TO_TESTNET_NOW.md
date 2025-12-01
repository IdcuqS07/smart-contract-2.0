# 🚀 Deploy Smart Contract 2.0 ke Linera Testnet Conway

**Status:** Ready to Deploy  
**Estimated Time:** 30-40 minutes  
**Date:** November 30, 2025

---

## ✅ Pre-Deployment Checklist

### Already Complete:
- ✅ Smart contract code complete (v0.15.6)
- ✅ Compilation successful
- ✅ All operations implemented
- ✅ GraphQL API ready
- ✅ State management working
- ✅ Rust toolchain installed
- ✅ Linera protocol repository cloned

### What We're Doing Now:
- ⏳ Installing Linera CLI (in progress)
- ⏳ Initializing wallet
- ⏳ Deploying to testnet

---

## 📋 Step-by-Step Deployment

### Step 1: Install Linera CLI (30 min)

**Option A: From Source (Recommended)**
```bash
# Already in progress
cd /Users/idcuq/linera-protocol
cargo install --path linera-service

# This will install:
# - linera (CLI tool)
# - linera-proxy
# - linera-server
```

**Option B: Pre-built Binary**
```bash
# If source build fails, use pre-built
curl -L https://github.com/linera-io/linera-protocol/releases/download/v0.15.6/linera-macos -o ~/.cargo/bin/linera
chmod +x ~/.cargo/bin/linera
```

**Verify Installation:**
```bash
linera --version
# Expected: linera 0.15.6
```

---

### Step 2: Initialize Wallet (2 min)

**Create New Wallet:**
```bash
# Initialize with testnet faucet
linera wallet init \
  --with-new-chain \
  --faucet https://faucet.testnet-conway.linera.net

# This will:
# - Create a new wallet
# - Generate keypair
# - Request tokens from faucet
# - Create initial chain
```

**Expected Output:**
```
✓ Wallet initialized
✓ Chain created: e476187f6ddfeb9d588c7b45d3df334d5501d6499b3f9ad5595cae86cce16a65
✓ Balance: 1000000 tokens
```

**Verify Wallet:**
```bash
linera wallet show
```

---

### Step 3: Build Smart Contract (3 min)

```bash
cd ~/Documents/Smart\ Contract\ 2.0/linera-integration

# Build for WASM
cargo build --release --target wasm32-unknown-unknown

# Verify build
ls -lh target/wasm32-unknown-unknown/release/*.wasm
```

**Expected Output:**
```
smart_contract_2_linera_contract.wasm
smart_contract_2_linera_service.wasm
```

---

### Step 4: Publish Application (2 min)

```bash
# Publish bytecode to chain
linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm

# This will:
# - Upload contract bytecode
# - Upload service bytecode
# - Create application instance
# - Return application ID
```

**Expected Output:**
```
✓ Bytecode published
✓ Application created
Application ID: e476187f6ddfeb9d588c7b45d3df334d5501d6499b3f9ad5595cae86cce16a65010000000000000000000000
```

**Save Application ID:**
```bash
export APP_ID="<your-application-id>"
echo $APP_ID > .linera-app-id
```

---

### Step 5: Start GraphQL Service (1 min)

```bash
# Start local service node
linera service --port 8080 &

# Service will be available at:
# http://localhost:8080
```

**Test GraphQL Endpoint:**
```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ contractCounter }"
  }'
```

**Expected Response:**
```json
{
  "data": {
    "contractCounter": 0
  }
}
```

---

### Step 6: Test Operations (5 min)

**1. Authorize Oracle:**
```bash
linera project execute \
  --application $APP_ID \
  --operation '{"AuthorizeOracle": {"oracle_address": "your-oracle-address"}}'
```

**2. Create Adaptive Contract:**
```bash
linera project execute \
  --application $APP_ID \
  --operation '{
    "CreateAdaptiveContract": {
      "contract_type": "PricePrediction",
      "threshold": 1000
    }
  }'
```

**3. Submit AI Prediction:**
```bash
linera project execute \
  --application $APP_ID \
  --operation '{
    "SubmitAIPrediction": {
      "contract_id": 1,
      "prediction_type": "BTC_PRICE",
      "value": 50000,
      "confidence": 85
    }
  }'
```

**4. Query Contract:**
```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ contract(id: 1) { id creator contractType threshold isActive } }"
  }'
```

---

## 🔗 Integration with AI Engine

### Update Oracle Service:

**File: `linera-integration/oracle-client/linera-oracle.js`**

```javascript
const LINERA_GRAPHQL_URL = 'http://localhost:8080/graphql';
const APPLICATION_ID = process.env.LINERA_APP_ID;

async function submitPredictionToLinera(contractId, prediction) {
  const mutation = `
    mutation {
      submitPrediction(
        contractId: ${contractId}
        predictionType: "${prediction.type}"
        value: ${prediction.value}
        confidence: ${prediction.confidence}
      )
    }
  `;
  
  const response = await fetch(LINERA_GRAPHQL_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ query: mutation })
  });
  
  return response.json();
}
```

### Update Environment Variables:

```bash
# .env
LINERA_GRAPHQL_URL=http://localhost:8080/graphql
LINERA_APP_ID=<your-application-id>
LINERA_CHAIN_ID=<your-chain-id>
```

---

## 📊 Deployment Verification

### Checklist:

- [ ] Linera CLI installed
- [ ] Wallet initialized
- [ ] Tokens received from faucet
- [ ] Smart contract built
- [ ] Application published
- [ ] GraphQL service running
- [ ] Operations tested
- [ ] Oracle integrated
- [ ] Frontend connected

### Verification Commands:

```bash
# Check wallet
linera wallet show

# Check application
linera project info --application $APP_ID

# Check service
curl http://localhost:8080/health

# Check GraphQL
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ contractCounter }"}'
```

---

## 🌐 Public Testnet Access

### Make Service Publicly Accessible:

**Option 1: ngrok (Quick)**
```bash
# Install ngrok
brew install ngrok

# Expose local service
ngrok http 8080

# Use ngrok URL in frontend
# https://xxxx-xx-xx-xxx-xxx.ngrok.io
```

**Option 2: Deploy to Cloud**
```bash
# Deploy service to cloud provider
# Update LINERA_GRAPHQL_URL in Vercel
vercel env add LINERA_GRAPHQL_URL
# Enter: https://your-linera-service.com/graphql
```

---

## 🎯 Expected Results

### After Successful Deployment:

**1. Application Info:**
```
Application ID: e476187f...
Chain ID: e476187f...
Owner: <your-address>
Status: Active
```

**2. GraphQL Endpoint:**
```
URL: http://localhost:8080/graphql
Status: Running
Queries: Available
Mutations: Available
```

**3. Smart Contract:**
```
Contracts Created: 0
Predictions Submitted: 0
Oracles Authorized: 1
Status: Ready
```

**4. Integration:**
```
AI Engine: ✅ Connected
Oracle Service: ✅ Connected
Frontend: ✅ Connected
Blockchain: ✅ Deployed
```

---

## 🐛 Troubleshooting

### Common Issues:

**1. Linera CLI Installation Fails:**
```bash
# Check Rust version
rustc --version  # Should be 1.75+

# Update Rust
rustup update

# Try again
cargo install --path linera-service --force
```

**2. Wallet Init Fails:**
```bash
# Check network connectivity
curl https://faucet.testnet-conway.linera.net

# Try with different faucet
linera wallet init --with-new-chain --faucet https://faucet.linera.net
```

**3. Build Fails:**
```bash
# Clean and rebuild
cargo clean
cargo build --release --target wasm32-unknown-unknown

# Check for errors
cargo check
```

**4. Service Won't Start:**
```bash
# Check port availability
lsof -i :8080

# Use different port
linera service --port 8081
```

**5. GraphQL Errors:**
```bash
# Check service logs
linera service --port 8080 --verbose

# Verify application ID
linera project info --application $APP_ID
```

---

## 📝 Post-Deployment Tasks

### 1. Update Documentation:
```bash
# Update README with deployment info
echo "Application ID: $APP_ID" >> DEPLOYMENT_INFO.md
echo "Chain ID: $(linera wallet show | grep 'Chain ID')" >> DEPLOYMENT_INFO.md
echo "GraphQL URL: http://localhost:8080/graphql" >> DEPLOYMENT_INFO.md
```

### 2. Update Frontend:
```javascript
// frontend/config.js
export const LINERA_CONFIG = {
  graphqlUrl: 'http://localhost:8080/graphql',
  applicationId: 'your-app-id',
  chainId: 'your-chain-id'
};
```

### 3. Test End-to-End:
```bash
# Run integration tests
npm run test:integration

# Test AI prediction flow
npm run test:ai-flow

# Test oracle submission
npm run test:oracle
```

### 4. Monitor Deployment:
```bash
# Watch service logs
linera service --port 8080 --verbose

# Monitor transactions
linera wallet show --watch

# Check application state
watch -n 5 'curl -s http://localhost:8080/graphql -d "{\"query\":\"{contractCounter}\"}"'
```

---

## 🎉 Success Criteria

### Deployment is successful when:

- ✅ Linera CLI installed and working
- ✅ Wallet initialized with tokens
- ✅ Smart contract deployed to testnet
- ✅ GraphQL service running
- ✅ Can create contracts via GraphQL
- ✅ Can submit predictions
- ✅ Oracle can interact with contract
- ✅ Frontend can query data
- ✅ All operations working

---

## 📊 Current Status

**Installation:** ⏳ In Progress  
**Estimated Completion:** 30 minutes  
**Next Step:** Wait for Linera CLI installation to complete

**Command Running:**
```bash
cargo install --path /Users/idcuq/linera-protocol/linera-service
```

**Once Complete:**
1. Verify installation: `linera --version`
2. Initialize wallet: `linera wallet init --with-new-chain --faucet https://faucet.testnet-conway.linera.net`
3. Deploy contract: Follow steps above

---

## 🚀 Quick Deploy Script

**File: `scripts/deploy-to-testnet.sh`**

```bash
#!/bin/bash
set -e

echo "🚀 Deploying Smart Contract 2.0 to Linera Testnet Conway..."

# Step 1: Build
echo "📦 Building smart contract..."
cd linera-integration
cargo build --release --target wasm32-unknown-unknown

# Step 2: Publish
echo "📤 Publishing to testnet..."
APP_ID=$(linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm \
  | grep "Application ID" | awk '{print $3}')

echo "✅ Application deployed: $APP_ID"
echo $APP_ID > .linera-app-id

# Step 3: Start service
echo "🌐 Starting GraphQL service..."
linera service --port 8080 &
sleep 5

# Step 4: Test
echo "🧪 Testing deployment..."
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ contractCounter }"}' \
  | jq .

echo "✅ Deployment complete!"
echo "📊 Application ID: $APP_ID"
echo "🌐 GraphQL URL: http://localhost:8080/graphql"
```

---

**Status:** ⏳ **INSTALLATION IN PROGRESS**  
**Next:** Wait for completion, then run deployment script

**Live Demo:** https://smartcontract2-linera.vercel.app  
**Repository:** https://github.com/IdcuqS07/smart-contract-2.0
