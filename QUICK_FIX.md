# 🔧 Quick Fix - Start Services Manually

## ❌ Problem
- Oracle service timeout
- Linera GraphQL not running

## ✅ Solution: Start Services Manually

### Step 1: Start Linera Service

```bash
# Terminal 1: Start Linera
linera service --port 8080

# Keep this terminal open!
# You should see: "GraphQL API listening on http://localhost:8080/graphql"
```

### Step 2: Start AI Engine

```bash
# Terminal 2: Start AI Engine
cd ai-engine
source venv/bin/activate
python main.py

# Keep this terminal open!
# You should see: "AI Engine running on http://localhost:5001"
```

### Step 3: Start Oracle Service

```bash
# Terminal 3: Start Oracle
cd linera-integration/oracle-client
node server.js

# Keep this terminal open!
# You should see: "Server running on: http://localhost:3002"
```

### Step 4: Run Integration Tests

```bash
# Terminal 4: Run tests
cd linera-integration/oracle-client
node full-integration.js
```

---

## 🚀 Alternative: Simple Test Without Full Integration

### Option 1: Test AI Engine Only

```bash
# Start AI Engine
cd ai-engine
source venv/bin/activate
python main.py

# In another terminal, test:
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{
    "model_type": "price_prediction",
    "data": {"symbol": "BTC", "timeframe": "1h"}
  }'

# Expected: JSON with prediction
```

### Option 2: Test Oracle Service Only

```bash
# Start Oracle
cd linera-integration/oracle-client
node server.js

# In another terminal, test:
curl http://localhost:3002/health

# Expected: {"status": "healthy"}
```

### Option 3: Build Smart Contract

```bash
# Build contract
cd linera-integration
cargo build --release --target wasm32-unknown-unknown

# Check build artifacts
ls -lh target/wasm32-unknown-unknown/release/*.wasm

# Expected: 2 WASM files
```

---

## 📝 Prerequisites Check

### Check if Linera is installed:

```bash
linera --version
```

**If not installed:**
```bash
# Install Linera CLI
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera
sudo mv linera /usr/local/bin/
```

### Check if wallet exists:

```bash
linera wallet show
```

**If wallet doesn't exist:**
```bash
# Initialize wallet
linera wallet init --with-new-chain
```

---

## 🎯 Simplified Testing Flow

### Test 1: AI Engine (No blockchain needed)

```bash
# 1. Start AI Engine
cd ai-engine
source venv/bin/activate
python main.py &

# 2. Test predictions
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type": "price_prediction", "data": {}}'

# 3. Test risk analysis
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type": "risk_analysis", "data": {}}'

# 4. Test fraud detection
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type": "fraud_detection", "data": {}}'
```

### Test 2: Smart Contract Build

```bash
# Build contract
cd linera-integration
cargo build --release --target wasm32-unknown-unknown

# Verify build
ls -lh target/wasm32-unknown-unknown/release/*.wasm

# Expected output:
# smart_contract_2_linera.wasm
# smart_contract_2_service.wasm
```

### Test 3: Frontend Demo

```bash
# Open frontend
cd frontend
open index.html

# Or use Python server
python3 -m http.server 8000

# Then open: http://localhost:8000
```

---

## 🔍 Troubleshooting

### Issue: "linera: command not found"

**Solution:**
```bash
# Install from source
git clone https://github.com/linera-io/linera-protocol.git
cd linera-protocol
cargo install --path linera-service

# Or download binary
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera
sudo mv linera /usr/local/bin/
```

### Issue: "Port already in use"

**Solution:**
```bash
# Find process using port
lsof -i :8080  # Linera
lsof -i :5001  # AI Engine
lsof -i :3002  # Oracle

# Kill process
kill -9 <PID>
```

### Issue: "Python venv not found"

**Solution:**
```bash
cd ai-engine
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Issue: "Node modules not found"

**Solution:**
```bash
cd linera-integration/oracle-client
npm install
```

---

## ✅ What You Can Test Right Now

### Without Linera (No blockchain needed):

1. **AI Engine** ✅
   ```bash
   cd ai-engine
   source venv/bin/activate
   python main.py
   ```

2. **Smart Contract Build** ✅
   ```bash
   cd linera-integration
   cargo build --release --target wasm32-unknown-unknown
   ```

3. **Frontend Demo** ✅
   ```bash
   cd frontend
   open index.html
   ```

4. **Oracle Service** ✅
   ```bash
   cd linera-integration/oracle-client
   node server.js
   ```

### With Linera (Blockchain required):

1. **Install Linera CLI** ⏳
2. **Initialize Wallet** ⏳
3. **Deploy Contract** ⏳
4. **Full Integration** ⏳

---

## 🎯 Recommended Next Steps

### Option A: Test Without Blockchain (Quick)

```bash
# 1. Test AI Engine
cd ai-engine && source venv/bin/activate && python main.py &

# 2. Test predictions
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type": "price_prediction", "data": {}}'

# 3. Open frontend
cd ../frontend && open index.html
```

**Time:** 2 minutes  
**Result:** See AI predictions working

### Option B: Build Smart Contract (Medium)

```bash
# 1. Build contract
cd linera-integration
cargo build --release --target wasm32-unknown-unknown

# 2. Check artifacts
ls -lh target/wasm32-unknown-unknown/release/*.wasm
```

**Time:** 5 minutes  
**Result:** WASM files ready for deployment

### Option C: Full Linera Integration (Advanced)

```bash
# 1. Install Linera CLI
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera && sudo mv linera /usr/local/bin/

# 2. Initialize wallet
linera wallet init --with-new-chain

# 3. Start Linera service
linera service --port 8080 &

# 4. Deploy contract
cd linera-integration
linera publish-and-create \
  target/wasm32-unknown-unknown/release/*.wasm
```

**Time:** 15 minutes  
**Result:** Full blockchain integration

---

## 📞 Need Help?

### Quick Links:
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** - Detailed troubleshooting
- **[PANDUAN_LENGKAP.md](./PANDUAN_LENGKAP.md)** - Complete guide (Indonesian)
- **[QUICK_START_LINERA.md](./QUICK_START_LINERA.md)** - Quick start guide

### Support:
- GitHub Issues: https://github.com/IdcuqS07/smart-contract-2.0/issues
- Discussions: https://github.com/IdcuqS07/smart-contract-2.0/discussions

---

## 🎉 Summary

**You can test RIGHT NOW without Linera:**
- ✅ AI Engine predictions
- ✅ Smart contract build
- ✅ Frontend demo
- ✅ Oracle service

**For full blockchain integration:**
- ⏳ Install Linera CLI
- ⏳ Initialize wallet
- ⏳ Deploy contract

**Choose your path and start testing! 🚀**
