# 🚀 Testnet Deployment - Ready to Deploy

**Date:** November 30, 2025  
**Status:** ✅ **ALL PREREQUISITES COMPLETE**

---

## ✅ What's Ready for Deployment

### 1. Smart Contract Code ✅
```
Location: linera-integration/
Status: Complete & Compiled
SDK Version: v0.15.6 (Latest)
```

**Files:**
- ✅ `src/lib.rs` - ABI definitions
- ✅ `src/state.rs` - State management
- ✅ `src/contract.rs` - Business logic
- ✅ `src/service.rs` - GraphQL API
- ✅ `Cargo.toml` - Dependencies configured

### 2. WASM Binaries ✅
```
Location: target/wasm32-unknown-unknown/release/
Status: Built & Ready
```

**Files:**
- ✅ `smart_contract_2_linera.wasm` (21KB) - Contract
- ✅ `smart_contract_2_linera_service.wasm` (2.0MB) - Service

**Verification:**
```bash
$ ls -lh linera-integration/target/wasm32-unknown-unknown/release/*.wasm
-rwxr-xr-x  21K smart_contract_2_linera.wasm
-rwxr-xr-x  2.0M smart_contract_2_linera_service.wasm
```

### 3. Deployment Scripts ✅
```
Location: scripts/
Status: Ready to Execute
```

**Scripts:**
- ✅ `deploy-with-docker.sh` - Docker-based deployment
- ✅ `quick-deploy.sh` - Quick deployment
- ✅ `deploy-testnet.sh` - Full testnet deployment

---

## 🔧 Deployment Options

### Option 1: Manual Deployment (Recommended)

**Prerequisites:**
- Linera CLI installed
- Rust toolchain
- Internet connection

**Steps:**

**1. Install Linera CLI:**
```bash
# From source (currently in progress)
cd /Users/idcuq/linera-protocol
cargo install --path linera-service

# OR download pre-built binary
curl -L https://github.com/linera-io/linera-protocol/releases/download/v0.15.6/linera-macos \
  -o ~/.cargo/bin/linera
chmod +x ~/.cargo/bin/linera

# Verify
linera --version
```

**2. Initialize Wallet:**
```bash
linera wallet init --with-new-chain \
  --faucet https://faucet.testnet-conway.linera.net

# Check balance
linera wallet show
```

**3. Deploy Smart Contract:**
```bash
cd linera-integration

linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm
```

**4. Start GraphQL Service:**
```bash
linera service --port 8080
```

**5. Test Deployment:**
```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ contractCounter }"}'
```

**Expected Output:**
```json
{
  "data": {
    "contractCounter": 0
  }
}
```

---

### Option 2: Docker Deployment

**Prerequisites:**
- Docker installed & running
- WASM files built

**Steps:**

**1. Pull Linera Image:**
```bash
docker pull linera/linera:v0.15.6
```

**2. Run Deployment:**
```bash
./scripts/deploy-with-docker.sh
```

**3. Verify:**
```bash
docker ps | grep linera
curl http://localhost:8080/graphql
```

---

### Option 3: Automated Script

**Prerequisites:**
- Linera CLI installed
- WASM files ready

**Steps:**

**1. Run Script:**
```bash
./scripts/quick-deploy.sh
```

**2. Follow Prompts:**
- Script will initialize wallet
- Deploy contract
- Start service
- Run tests

---

## 📊 Deployment Checklist

### Pre-Deployment:
- [x] Smart contract code complete
- [x] Code compiled successfully
- [x] WASM files generated
- [x] Deployment scripts ready
- [x] Documentation complete
- [ ] Linera CLI installed (in progress)

### During Deployment:
- [ ] Wallet initialized
- [ ] Tokens received from faucet
- [ ] Contract bytecode published
- [ ] Application created
- [ ] Service started
- [ ] GraphQL endpoint accessible

### Post-Deployment:
- [ ] Test contract creation
- [ ] Test prediction submission
- [ ] Test oracle authorization
- [ ] Verify GraphQL queries
- [ ] Update frontend config
- [ ] Document deployment info

---

## 🎯 Expected Timeline

### Current Status:
```
⏳ Linera CLI Installation: In Progress
   Started: ~11:03 PM
   Estimated: 30-60 minutes
   Status: cargo install running
```

### Deployment Timeline:
```
Step 1: CLI Installation    - 30-60 min (in progress)
Step 2: Wallet Init         - 2 min
Step 3: Deploy Contract     - 5 min
Step 4: Start Service       - 1 min
Step 5: Testing             - 5 min
-------------------------------------------
Total:                      - 40-75 min
```

---

## 🔗 Integration After Deployment

### 1. Update Frontend Config:

**File: `frontend/config.js`**
```javascript
export const LINERA_CONFIG = {
  graphqlUrl: 'http://localhost:8080/graphql',
  applicationId: '<your-app-id>',
  chainId: '<your-chain-id>',
  network: 'testnet-conway'
};
```

### 2. Update Oracle Service:

**File: `linera-integration/oracle-client/linera-oracle.js`**
```javascript
const LINERA_GRAPHQL_URL = 'http://localhost:8080/graphql';
const APPLICATION_ID = process.env.LINERA_APP_ID;

async function submitToLinera(prediction) {
  const mutation = `
    mutation {
      submitPrediction(
        contractId: 1
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

### 3. Update Environment Variables:

**File: `.env`**
```bash
LINERA_GRAPHQL_URL=http://localhost:8080/graphql
LINERA_APP_ID=<your-application-id>
LINERA_CHAIN_ID=<your-chain-id>
LINERA_NETWORK=testnet-conway
```

### 4. Test Integration:

```bash
# Test AI prediction
curl -X POST http://localhost:3000/api/ai/predict \
  -d '{"symbol":"BTC","timeframe":"1h"}'

# Verify it reaches Linera
curl -X POST http://localhost:8080/graphql \
  -d '{"query":"{ predictions(contractId: 1) { value confidence } }"}'
```

---

## 📝 Deployment Information Template

**After successful deployment, save this info:**

```markdown
# Deployment Info

**Date:** [DATE]
**Network:** Linera Testnet Conway

## Application Details:
- Application ID: [APP_ID]
- Chain ID: [CHAIN_ID]
- Owner Address: [OWNER]

## Endpoints:
- GraphQL: http://localhost:8080/graphql
- WebSocket: ws://localhost:8080/ws

## Wallet Info:
- Balance: [BALANCE] tokens
- Public Key: [PUBLIC_KEY]

## Contract Info:
- Contract WASM: 21KB
- Service WASM: 2.0MB
- Deployment Time: [TIME]

## Test Results:
- Contract Creation: ✅
- Prediction Submission: ✅
- Oracle Authorization: ✅
- GraphQL Queries: ✅
```

---

## 🐛 Troubleshooting

### Issue: CLI Installation Slow
**Solution:**
```bash
# Check progress
ps aux | grep "cargo install"

# If stuck, try pre-built binary
curl -L https://github.com/linera-io/linera-protocol/releases/download/v0.15.6/linera-macos \
  -o ~/.cargo/bin/linera
chmod +x ~/.cargo/bin/linera
```

### Issue: Faucet Not Responding
**Solution:**
```bash
# Try alternative faucet
linera wallet init --with-new-chain \
  --faucet https://faucet.linera.net

# Or request tokens manually
curl -X POST https://faucet.testnet-conway.linera.net/request \
  -d '{"address":"<your-address>"}'
```

### Issue: WASM Build Fails
**Solution:**
```bash
# Clean and rebuild
cd linera-integration
cargo clean
cargo build --release --target wasm32-unknown-unknown

# Check for errors
cargo check
```

### Issue: Service Won't Start
**Solution:**
```bash
# Check port availability
lsof -i :8080

# Use different port
linera service --port 8081

# Check logs
linera service --port 8080 --verbose
```

---

## 🎉 Success Indicators

### Deployment is successful when:

1. ✅ CLI installed: `linera --version` works
2. ✅ Wallet created: `linera wallet show` displays info
3. ✅ Contract deployed: Application ID received
4. ✅ Service running: `curl http://localhost:8080/graphql` responds
5. ✅ Queries work: GraphQL returns data
6. ✅ Mutations work: Can create contracts
7. ✅ Integration works: AI predictions reach blockchain

---

## 📊 Current Status

**Installation Progress:**
```
⏳ Linera CLI: Installing (cargo install in progress)
✅ WASM Files: Ready (21KB + 2.0MB)
✅ Scripts: Ready
✅ Documentation: Complete
✅ AI Engine: Live on Vercel
✅ Frontend: Live on Vercel
```

**Next Action:**
```
Wait for Linera CLI installation to complete (~30-60 min)
Then run: linera --version
Then follow deployment steps above
```

---

## 🚀 Quick Start (After CLI Install)

**One-Command Deployment:**
```bash
# Initialize wallet
linera wallet init --with-new-chain --faucet https://faucet.testnet-conway.linera.net

# Deploy
cd linera-integration && \
linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm

# Start service
linera service --port 8080 &

# Test
curl -X POST http://localhost:8080/graphql \
  -d '{"query": "{ contractCounter }"}'
```

---

**Status:** ✅ **READY TO DEPLOY** (Pending CLI Installation)

**Estimated Time to Deployment:** 30-60 minutes  
**Current Blocker:** Linera CLI installation in progress

**Live Demo:** https://smartcontract2-linera.vercel.app  
**Repository:** https://github.com/IdcuqS07/smart-contract-2.0
