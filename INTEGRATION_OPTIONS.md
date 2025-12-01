# 🎯 Linera Integration - 2 Options

## Option 1: Mock Mode (Quick Demo) ⚡

**Keuntungan:**
- ✅ Tidak perlu install Linera CLI
- ✅ Bisa test sekarang juga (5 menit)
- ✅ Simulate full blockchain behavior
- ✅ Perfect untuk demo & development

**Cara Pakai:**

```bash
# Run full integration test dengan mock
./test-full-integration-mock.sh
```

**Atau manual:**

```bash
# Terminal 1: Start Mock Linera
cd linera-integration
node mock-linera-service.js

# Terminal 2: Test integration
# (AI Engine sudah running)
```

**Hasil:**
- ✅ See complete flow working
- ✅ Contract creation
- ✅ AI predictions
- ✅ Blockchain submission
- ✅ Auto-execution

---

## Option 2: Real Linera (Production) 🚀

**Keuntungan:**
- ✅ Real blockchain integration
- ✅ Production ready
- ✅ Testnet deployment
- ✅ Full Linera features

**Cara Install:**

### Step 1: Install Linera CLI

**Option A: From Binary (Fastest)**
```bash
# Download latest release
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera

# Make executable
chmod +x linera

# Move to PATH
sudo mv linera /usr/local/bin/

# Verify
linera --version
```

**Option B: From Source (Latest)**
```bash
# Clone repository
git clone https://github.com/linera-io/linera-protocol.git
cd linera-protocol

# Install
cargo install --path linera-service

# Verify
linera --version
```

### Step 2: Initialize Wallet

```bash
# Create new wallet with chain
linera wallet init --with-new-chain

# Check wallet
linera wallet show
```

### Step 3: Start Linera Service

```bash
# Start local node
linera service --port 8080

# Keep this terminal open!
```

### Step 4: Deploy Contract

```bash
# In another terminal
cd linera-integration

# Build contract
cargo build --release --target wasm32-unknown-unknown

# Deploy
linera publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_service.wasm
```

### Step 5: Test Integration

```bash
cd oracle-client
node full-integration.js
```

---

## 🎯 Recommendation

### For Quick Demo (NOW):
**Use Option 1 (Mock Mode)**

```bash
# One command to test everything!
./test-full-integration-mock.sh
```

**Time:** 5 minutes  
**Result:** See full integration working

---

### For Production (LATER):
**Use Option 2 (Real Linera)**

**Time:** 30 minutes  
**Result:** Real blockchain deployment

---

## 📊 Comparison

| Feature | Mock Mode | Real Linera |
|---------|-----------|-------------|
| Setup Time | 5 min | 30 min |
| Installation | None | Linera CLI |
| Blockchain | Simulated | Real |
| Testing | ✅ Perfect | ✅ Perfect |
| Demo | ✅ Great | ✅ Great |
| Production | ❌ No | ✅ Yes |
| Testnet | ❌ No | ✅ Yes |

---

## 🚀 Quick Start

### Test Mock Mode NOW:

```bash
# Make sure AI Engine is running
curl http://localhost:5001/health

# Run full integration test
./test-full-integration-mock.sh
```

**Expected Output:**
```
✅ AI Engine is running
✅ Mock Linera Service running
✅ Contract created successfully!
✅ AI Prediction received!
✅ Prediction submitted to blockchain!
✅ Contract status retrieved!
✅ Predictions retrieved!
🎉 Integration Test Complete!
```

---

## 📝 What Mock Mode Tests

### Complete Flow:
1. **Create Contract** → Mock blockchain stores it
2. **Request AI Prediction** → Real AI Engine responds
3. **Submit to Blockchain** → Mock blockchain validates
4. **Check Auto-Execution** → Mock checks threshold
5. **Query Results** → Mock returns data

### What's Real:
- ✅ AI Engine (100% real)
- ✅ Oracle Client (100% real)
- ✅ Business Logic (100% real)
- ✅ API Calls (100% real)

### What's Mocked:
- 🔄 Blockchain storage (in-memory)
- 🔄 Transaction finality (instant)
- 🔄 Consensus (simulated)

---

## 💡 Best Approach

### Phase 1: Demo & Development (NOW)
**Use Mock Mode:**
```bash
./test-full-integration-mock.sh
```

**Benefits:**
- Quick testing
- No installation needed
- Perfect for demos
- Fast iteration

### Phase 2: Testing & Validation (NEXT)
**Install Real Linera:**
```bash
# Install CLI
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera
sudo mv linera /usr/local/bin/

# Deploy
cd linera-integration
./scripts/full-deploy.sh
```

**Benefits:**
- Real blockchain
- Testnet deployment
- Production validation

### Phase 3: Production (FUTURE)
**Deploy to Mainnet:**
- Full security audit
- Performance testing
- Production deployment

---

## 🎉 Summary

**You have 2 options:**

### Option 1: Mock Mode (Recommended NOW) ⚡
```bash
./test-full-integration-mock.sh
```
- ✅ Works immediately
- ✅ No installation
- ✅ Perfect for demo
- ✅ Full flow testing

### Option 2: Real Linera (For Production) 🚀
```bash
# Install Linera CLI
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera
sudo mv linera /usr/local/bin/

# Deploy
cd linera-integration
./scripts/full-deploy.sh
```
- ✅ Real blockchain
- ✅ Production ready
- ✅ Testnet deployment

---

## 🎯 My Recommendation

**Start with Mock Mode to see everything working:**

```bash
./test-full-integration-mock.sh
```

**Then install Real Linera when ready for production.**

---

**Ready to test? Run the mock integration now! 🚀**
