# 🚀 Complete Linera Setup Guide

## 🎯 Choose Your Path

### Path A: Local Development (Recommended First)
- ✅ Quick setup (5 minutes)
- ✅ No network required
- ✅ Perfect for testing
- ✅ Unlimited tokens

### Path B: Testnet Conway (For Public Demo)
- ✅ Public accessible
- ✅ Real network
- ✅ Shareable demo
- ✅ Production-like

---

## 🏠 Path A: Local Development Setup

### Step 1: Install Linera CLI

```bash
# Run installation script
./install-linera-now.sh

# Or manual:
cd ~/linera-protocol
cargo install --path linera-service

# Verify
linera --version
```

### Step 2: Initialize Local Wallet

```bash
# Create wallet with local chain
linera wallet init --with-new-chain

# This creates:
# - ~/.config/linera/wallet.json
# - ~/.config/linera/storage.db
# - Local chain with unlimited tokens
```

**Expected output:**
```
✅ Wallet initialized
✅ Chain created: chain_xxxxx
✅ Owner: owner_xxxxx
✅ Balance: 1000000 (local tokens)
```

### Step 3: Check Wallet

```bash
# View wallet details
linera wallet show

# You should see:
# - Chain ID
# - Owner address
# - Balance (local tokens)
```

### Step 4: Start Local Service

```bash
# Start Linera service
linera service --port 8080

# Keep this terminal open!
```

**Expected output:**
```
🚀 Linera service started
📡 GraphQL: http://localhost:8080/graphql
🔌 WebSocket: ws://localhost:8080/ws
```

### Step 5: Test GraphQL

```bash
# In another terminal
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chains { list } }"}'

# Should return your local chain
```

### Step 6: Deploy Smart Contract

```bash
cd linera-integration

# Build
cargo build --release --target wasm32-unknown-unknown

# Deploy
linera publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_service.wasm \
  --json-argument "null"

# Save Application ID!
```

### Step 7: Test Integration

```bash
cd oracle-client
node full-integration.js
```

**Total Time: ~20 minutes**

---

## 🌐 Path B: Testnet Conway Setup

### Step 1: Install Linera CLI

```bash
# Same as Path A
./install-linera-now.sh

# Verify
linera --version
```

### Step 2: Initialize Testnet Wallet

```bash
# Initialize with testnet faucet
linera wallet init --faucet https://faucet.testnet-conway.linera.net

# This connects to Conway testnet
```

**Expected output:**
```
✅ Wallet initialized
✅ Connected to testnet: Conway
✅ Faucet: https://faucet.testnet-conway.linera.net
```

### Step 3: Request Chain & Tokens

```bash
# Request a chain with tokens from faucet
linera wallet request-chain --faucet https://faucet.testnet-conway.linera.net

# This may take a few seconds
```

**Expected output:**
```
✅ Chain requested
✅ Chain ID: chain_xxxxx
✅ Tokens received: 1000000
✅ Owner: owner_xxxxx
```

### Step 4: Check Wallet

```bash
# View wallet details
linera wallet show

# You should see:
# - Testnet chain ID
# - Owner address
# - Token balance
```

### Step 5: Start Testnet Service

```bash
# Start service connected to testnet
linera service --port 8080

# Keep this terminal open!
```

### Step 6: Deploy to Testnet

```bash
cd linera-integration

# Build
cargo build --release --target wasm32-unknown-unknown

# Deploy to testnet
linera publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_service.wasm \
  --json-argument "null"

# Save Application ID!
```

### Step 7: Test on Testnet

```bash
cd oracle-client
node full-integration.js
```

**Total Time: ~25 minutes**

---

## 📊 Detailed Comparison

### Local Development

**Pros:**
- ✅ Instant setup
- ✅ No network dependency
- ✅ Unlimited tokens
- ✅ Fast transactions
- ✅ Perfect for development
- ✅ No faucet needed

**Cons:**
- ❌ Not publicly accessible
- ❌ Can't share demo URL
- ❌ Local only

**Best For:**
- Development
- Testing
- Debugging
- Learning

---

### Testnet Conway

**Pros:**
- ✅ Publicly accessible
- ✅ Real network behavior
- ✅ Shareable demo
- ✅ Production-like
- ✅ Community testing

**Cons:**
- ❌ Requires network
- ❌ Need faucet tokens
- ❌ Network latency
- ❌ Faucet rate limits

**Best For:**
- Public demos
- Community testing
- Pre-production testing
- Hackathon submissions

---

## 🎯 Recommended Workflow

### Phase 1: Local Development (NOW)

```bash
# Quick local setup
linera wallet init --with-new-chain
linera service --port 8080

# Deploy and test locally
cd linera-integration
cargo build --release --target wasm32-unknown-unknown
linera publish-and-create target/wasm32-unknown-unknown/release/*.wasm

# Test
cd oracle-client && node full-integration.js
```

**Time:** 20 minutes  
**Result:** Working local deployment

---

### Phase 2: Testnet Deployment (LATER)

```bash
# Setup testnet
linera wallet init --faucet https://faucet.testnet-conway.linera.net
linera wallet request-chain --faucet https://faucet.testnet-conway.linera.net

# Deploy to testnet
linera service --port 8080
cd linera-integration
linera publish-and-create target/wasm32-unknown-unknown/release/*.wasm

# Share demo!
```

**Time:** 25 minutes  
**Result:** Public testnet deployment

---

## 🔧 Configuration Files

### Local Development Config

```json
{
  "applicationId": "YOUR_LOCAL_APP_ID",
  "chainId": "YOUR_LOCAL_CHAIN_ID",
  "graphqlEndpoint": "http://localhost:8080/graphql",
  "wsEndpoint": "ws://localhost:8080/ws",
  "aiEngineUrl": "http://localhost:5001",
  "network": "local"
}
```

### Testnet Config

```json
{
  "applicationId": "YOUR_TESTNET_APP_ID",
  "chainId": "YOUR_TESTNET_CHAIN_ID",
  "graphqlEndpoint": "http://localhost:8080/graphql",
  "wsEndpoint": "ws://localhost:8080/ws",
  "aiEngineUrl": "http://localhost:5001",
  "network": "testnet-conway",
  "faucet": "https://faucet.testnet-conway.linera.net"
}
```

---

## 🐛 Troubleshooting

### Issue: Faucet Request Failed

**Solution:**
```bash
# Try again (rate limited)
linera wallet request-chain --faucet https://faucet.testnet-conway.linera.net

# Or use local for now
linera wallet init --with-new-chain
```

### Issue: Network Connection Error

**Solution:**
```bash
# Check internet connection
ping faucet.testnet-conway.linera.net

# Or use local development
linera wallet init --with-new-chain
```

### Issue: Insufficient Tokens

**Solution:**
```bash
# Request more from faucet
linera wallet request-chain --faucet https://faucet.testnet-conway.linera.net

# Or use local (unlimited)
linera wallet init --with-new-chain
```

---

## ✅ Quick Commands

### Local Development

```bash
# Setup
linera wallet init --with-new-chain
linera service --port 8080

# Deploy
cd linera-integration
cargo build --release --target wasm32-unknown-unknown
linera publish-and-create target/wasm32-unknown-unknown/release/*.wasm

# Test
cd oracle-client && node full-integration.js
```

### Testnet Conway

```bash
# Setup
linera wallet init --faucet https://faucet.testnet-conway.linera.net
linera wallet request-chain --faucet https://faucet.testnet-conway.linera.net
linera service --port 8080

# Deploy
cd linera-integration
cargo build --release --target wasm32-unknown-unknown
linera publish-and-create target/wasm32-unknown-unknown/release/*.wasm

# Test
cd oracle-client && node full-integration.js
```

---

## 🎉 Summary

**For Development & Testing:**
```bash
linera wallet init --with-new-chain
```
✅ Quick, easy, unlimited tokens

**For Public Demo:**
```bash
linera wallet init --faucet https://faucet.testnet-conway.linera.net
linera wallet request-chain --faucet https://faucet.testnet-conway.linera.net
```
✅ Public, shareable, production-like

**Recommendation:** Start with local, then deploy to testnet when ready!

---

**Ready to start? Choose your path and let's deploy! 🚀**
