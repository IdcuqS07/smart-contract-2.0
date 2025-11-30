# 🧪 Panduan Testing Integrasi Linera via Browser

Panduan lengkap untuk menguji integrasi Smart Contract 2.0 dengan Linera blockchain melalui browser.

## 🚀 Quick Start

### 1. Start Semua Services

```bash
./scripts/start-services-dev.sh
```

Script ini akan otomatis:
- ✅ Install dependencies Python & Node.js
- ✅ Start AI Engine (port 5001)
- ✅ Start Oracle Service (port 3002)
- ✅ Start Frontend Server (port 8080)
- ✅ Membuka browser test page

### 2. Verifikasi Services

Browser akan otomatis membuka `http://localhost:8080/test.html`

Atau jalankan test script:
```bash
./scripts/test-integration.sh
```

### 3. Stop Services

```bash
./scripts/stop-all-services.sh
```

---

## 📊 Service Status

Setelah services berjalan, Anda dapat mengakses:

| Service | URL | Deskripsi |
|---------|-----|-----------|
| **AI Engine** | http://localhost:5001 | Machine Learning models |
| **Oracle Service** | http://localhost:3002 | Bridge AI ↔ Blockchain |
| **Frontend** | http://localhost:8080 | User interface |
| **Test Page** | http://localhost:8080/test.html | Service diagnostics |

---

## 🧪 Testing Scenarios

### Scenario 1: Test Service Health

**URL:** `http://localhost:8080/test.html` (Basic Test)
**URL:** `http://localhost:8080/test-advanced.html` (Advanced Test - Recommended)

**Expected Results:**
- ✅ AI Engine: Connected (green)
- ✅ Oracle Service: Connected (green)
- ✅ Available Models: 3 models listed

**Advanced Test Features:**
- Real-time service status monitoring
- Interactive AI prediction testing
- Test statistics tracking
- Beautiful UI with detailed results

**Screenshot:**
```
Service Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ AI Engine: Connected
✅ Oracle Service: Connected
✅ Available Models: 
   • price_prediction
   • risk_analysis
   • fraud_detection
```

---

### Scenario 2: Test AI Prediction (Manual)

**Method 1: Using curl**

```bash
# Test Price Prediction
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{
    "model_type": "price_prediction",
    "data": {
      "symbol": "BTC",
      "timeframe": "1h",
      "features": [50000, 1000000, 0.02]
    }
  }'
```

**Expected Response:**
```json
{
  "model": "price_prediction",
  "prediction": 51234.56,
  "confidence": 85,
  "timestamp": "2025-11-30T16:52:59.123Z"
}
```

**Method 2: Using Browser Console**

Buka `http://localhost:8080/test.html` dan jalankan di console:

```javascript
fetch('http://localhost:5001/predict', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    model_type: 'price_prediction',
    data: {
      symbol: 'BTC',
      timeframe: '1h',
      features: [50000, 1000000, 0.02]
    }
  })
})
.then(r => r.json())
.then(data => console.log('✅ Prediction:', data));
```

---

### Scenario 3: Test Oracle Service

**Test Oracle Health:**
```bash
curl http://localhost:3002/health
```

**Expected Response:**
```json
{
  "status": "healthy",
  "service": "Linera Oracle Service",
  "version": "1.0.0",
  "config": {
    "graphqlEndpoint": "http://localhost:8080/graphql",
    "aiEngineUrl": "http://localhost:5001"
  }
}
```

---

### Scenario 4: Full Integration Test (dengan Linera)

**Prerequisites:**
- Linera CLI installed
- Local Linera network running

**Steps:**

1. **Start Linera Network**
```bash
cd linera-integration
linera net up
```

2. **Deploy Contract**
```bash
./scripts/deploy.sh
```

3. **Create Adaptive Contract via Oracle**
```bash
curl -X POST http://localhost:3002/contract/create \
  -H "Content-Type: application/json" \
  -d '{
    "contractType": "price_prediction",
    "threshold": 80
  }'
```

4. **Request AI Prediction & Submit to Blockchain**
```bash
curl -X POST http://localhost:3002/prediction/request \
  -H "Content-Type: application/json" \
  -d '{
    "contractId": 1,
    "modelType": "price_prediction",
    "data": {
      "symbol": "BTC",
      "timeframe": "1h",
      "features": [50000, 1000000, 0.02]
    }
  }'
```

---

## 🎯 Verification Checklist

### ✅ Basic Services
- [ ] AI Engine responds to `/health`
- [ ] AI Engine returns 3 models at `/models`
- [ ] Oracle Service responds to `/health`
- [ ] Frontend loads at port 8080
- [ ] Test page shows all services connected

### ✅ AI Predictions
- [ ] Price Prediction returns valid data
- [ ] Risk Analysis returns risk score
- [ ] Fraud Detection returns fraud score
- [ ] All predictions include confidence scores

### ✅ Oracle Integration
- [ ] Oracle can communicate with AI Engine
- [ ] Oracle endpoints respond correctly
- [ ] CORS headers allow browser requests

### ✅ Linera Integration (Optional)
- [ ] Linera network is running
- [ ] Contract deployed successfully
- [ ] Can create adaptive contracts
- [ ] Can submit predictions to blockchain
- [ ] Can query contract state

---

## 🐛 Troubleshooting

### Problem: Services tidak start

**Solution:**
```bash
# Check logs
cat logs/ai-engine.log
cat logs/oracle.log
cat logs/frontend.log

# Kill stuck processes
./scripts/stop-all-services.sh

# Restart
./scripts/start-services-dev.sh
```

### Problem: Port already in use

**Solution:**
```bash
# Kill processes on specific ports
lsof -ti:5001 | xargs kill -9  # AI Engine
lsof -ti:3002 | xargs kill -9  # Oracle
lsof -ti:8080 | xargs kill -9  # Frontend
```

### Problem: CORS errors in browser

**Solution:**
- AI Engine sudah include `flask-cors`
- Oracle Service sudah include `cors` middleware
- Pastikan services restart setelah update

### Problem: Linera not installed

**Solution:**
```bash
# Install Linera CLI
curl -sSf https://get.linera.io | bash

# Verify installation
linera --version
```

---

## 📝 Logs Location

Semua logs disimpan di folder `logs/`:

```
logs/
├── ai-engine.log      # AI Engine output
├── oracle.log         # Oracle Service output
├── frontend.log       # Frontend server output
└── pids.txt          # Process IDs (auto-generated)
```

**View logs in real-time:**
```bash
tail -f logs/ai-engine.log
tail -f logs/oracle.log
```

---

## 🎓 Next Steps

Setelah semua test berhasil:

1. **Explore API Documentation**
   - Read `TUTORIAL.md` for detailed guides
   - Check `EXAMPLES.md` for code samples

2. **Deploy to Production**
   - Follow `DEPLOYMENT.md` for production setup
   - Use `VERCEL_DEPLOYMENT.md` for Vercel deployment

3. **Integrate with Your App**
   - Use Oracle API endpoints
   - Subscribe to blockchain events
   - Build custom UI

---

## 📞 Support

Jika mengalami masalah:
1. Check `TROUBLESHOOTING.md`
2. Review logs di folder `logs/`
3. Run `./scripts/test-integration.sh` untuk diagnostics
4. Open issue di GitHub repository

---

**Happy Testing! 🚀**
