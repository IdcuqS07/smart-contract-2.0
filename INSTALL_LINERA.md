# 🚀 Install Linera CLI - Step by Step

## ✅ Mock Test Results

**Mock integration test completed successfully!**
- ✅ Mock Linera Service: WORKING
- ✅ Contract Creation: SUCCESS
- ✅ Blockchain Storage: WORKING
- ✅ Contract Query: SUCCESS

**Now ready for real Linera integration!**

---

## 📋 Prerequisites

Before installing Linera CLI, ensure you have:

```bash
# Check Rust
rustc --version
# Expected: rustc 1.70+ 

# Check Cargo
cargo --version
# Expected: cargo 1.70+

# If not installed:
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

---

## 🚀 Option 1: Install from Binary (Fastest - 5 min)

### Step 1: Download Linera CLI

```bash
# Download latest release for macOS
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera

# Make executable
chmod +x linera

# Move to PATH
sudo mv linera /usr/local/bin/

# Verify installation
linera --version
```

**Expected output:**
```
linera 0.x.x
```

---

## 🔧 Option 2: Install from Source (Latest - 15 min)

### Step 1: Clone Repository

```bash
# Clone Linera Protocol
git clone https://github.com/linera-io/linera-protocol.git
cd linera-protocol
```

### Step 2: Build and Install

```bash
# Install Linera service
cargo install --path linera-service

# This will take 10-15 minutes
# Coffee break! ☕
```

### Step 3: Verify Installation

```bash
# Check if installed
linera --version

# Should show: linera 0.x.x
```

---

## 🎯 Post-Installation Setup

### Step 1: Initialize Wallet

```bash
# Create new wallet with a chain
linera wallet init --with-new-chain

# This creates:
# - ~/.config/linera/wallet.json
# - ~/.config/linera/storage.db
```

**Expected output:**
```
✅ Wallet initialized
✅ Chain created: chain_xxxxx
✅ Owner: owner_xxxxx
```

### Step 2: Check Wallet

```bash
# View wallet details
linera wallet show

# You should see:
# - Chain ID
# - Owner address
# - Balance
```

### Step 3: Start Linera Service

```bash
# Start local Linera node
linera service --port 8080

# Keep this terminal open!
```

**Expected output:**
```
🚀 Linera service started
📡 GraphQL API: http://localhost:8080/graphql
🔌 WebSocket: ws://localhost:8080/ws
```

### Step 4: Test GraphQL Endpoint

```bash
# In another terminal, test GraphQL
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chains { list } }"}'

# Should return JSON with chain list
```

---

## 🏗️ Deploy Smart Contract

### Step 1: Build Contract

```bash
cd linera-integration

# Build for WASM
cargo build --release --target wasm32-unknown-unknown

# Check build artifacts
ls -lh target/wasm32-unknown-unknown/release/*.wasm
```

**Expected files:**
- `smart_contract_2_linera.wasm`
- `smart_contract_2_service.wasm`

### Step 2: Deploy to Linera

```bash
# Deploy contract and service
linera publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_service.wasm \
  --json-argument "null"

# Save the Application ID from output!
```

**Expected output:**
```
✅ Bytecode published
✅ Application created
📝 Application ID: app_xxxxx
📝 Chain ID: chain_xxxxx
```

### Step 3: Save Configuration

```bash
# Create deployment config
cat > deployment-config.json <<EOF
{
  "applicationId": "YOUR_APP_ID_HERE",
  "chainId": "YOUR_CHAIN_ID_HERE",
  "graphqlEndpoint": "http://localhost:8080/graphql",
  "wsEndpoint": "ws://localhost:8080/ws",
  "aiEngineUrl": "http://localhost:5001"
}
EOF
```

---

## 🧪 Test Full Integration

### Step 1: Start All Services

```bash
# Terminal 1: Linera (already running)
linera service --port 8080

# Terminal 2: AI Engine
cd ai-engine
source venv/bin/activate
python main.py

# Terminal 3: Oracle Service
cd linera-integration/oracle-client
node server.js
```

### Step 2: Run Integration Tests

```bash
# Terminal 4: Run tests
cd linera-integration/oracle-client
node full-integration.js
```

**Expected output:**
```
✅ Scenario 1: Price Prediction - PASS
✅ Scenario 2: Risk Analysis - PASS
✅ Scenario 3: Fraud Detection - PASS
🎉 All integration tests passed!
```

---

## 🐛 Troubleshooting

### Issue: "linera: command not found"

**Solution:**
```bash
# Check if in PATH
echo $PATH

# Add to PATH if needed
export PATH="$HOME/.cargo/bin:$PATH"

# Or reinstall
cargo install --path linera-service --force
```

### Issue: "Wallet not found"

**Solution:**
```bash
# Initialize wallet
linera wallet init --with-new-chain

# Check wallet location
ls -la ~/.config/linera/
```

### Issue: "Port 8080 already in use"

**Solution:**
```bash
# Kill process on port 8080
lsof -ti :8080 | xargs kill -9

# Or use different port
linera service --port 8081
```

### Issue: "Build fails"

**Solution:**
```bash
# Update Rust
rustup update

# Clean and rebuild
cargo clean
cargo build --release --target wasm32-unknown-unknown
```

---

## ✅ Verification Checklist

Before proceeding, verify:

- [ ] Linera CLI installed (`linera --version`)
- [ ] Wallet initialized (`linera wallet show`)
- [ ] Service running (`curl http://localhost:8080/health`)
- [ ] Contract built (`ls target/wasm32-unknown-unknown/release/*.wasm`)
- [ ] Contract deployed (Application ID saved)
- [ ] AI Engine running (`curl http://localhost:5001/health`)
- [ ] Integration tests passing

---

## 🎉 Success!

**If all checks pass, you have:**
- ✅ Linera CLI installed
- ✅ Wallet configured
- ✅ Smart contract deployed
- ✅ Full integration working

**Next steps:**
1. Deploy to testnet
2. Create demo video
3. Share with community

---

## 📚 Additional Resources

### Documentation
- [Linera Documentation](https://linera.dev)
- [Linera SDK](https://docs.rs/linera-sdk)
- [GitHub Repository](https://github.com/linera-io/linera-protocol)

### Community
- [Discord](https://discord.gg/linera)
- [Twitter](https://twitter.com/linera_io)
- [GitHub Discussions](https://github.com/linera-io/linera-protocol/discussions)

---

## 🚀 Quick Commands Reference

```bash
# Install Linera
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera && sudo mv linera /usr/local/bin/

# Initialize
linera wallet init --with-new-chain

# Start service
linera service --port 8080

# Build contract
cd linera-integration
cargo build --release --target wasm32-unknown-unknown

# Deploy
linera publish-and-create target/wasm32-unknown-unknown/release/*.wasm

# Test
cd oracle-client && node full-integration.js
```

---

**Ready to install? Start with Option 1 (Binary) for fastest setup!** 🚀
