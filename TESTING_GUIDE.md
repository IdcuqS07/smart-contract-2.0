# 🧪 Panduan Testing Smart Contract 2.0

## ✅ Checklist Persiapan

Sebelum mulai testing, pastikan Anda sudah menyiapkan:

### 1. Hardware & Software Requirements

**Minimum:**
- [ ] Computer/Laptop (Mac/Windows/Linux)
- [ ] RAM: 4GB minimum (8GB recommended)
- [ ] Storage: 2GB free space
- [ ] Internet connection (untuk download dependencies)

**Software:**
- [ ] Node.js v18+ ([Download](https://nodejs.org))
- [ ] Python 3.8+ ([Download](https://python.org))
- [ ] Git (optional, untuk clone repo)
- [ ] Browser modern (Chrome/Firefox/Safari)
- [ ] Text editor (VS Code recommended)

### 2. Verifikasi Instalasi

```bash
# Check Node.js
node --version
# Expected: v18.x.x atau lebih tinggi

# Check npm
npm --version
# Expected: 9.x.x atau lebih tinggi

# Check Python
python3 --version
# Expected: Python 3.8.x atau lebih tinggi

# Check pip
pip3 --version
# Expected: pip 20.x.x atau lebih tinggi
```

---

## 🚀 Quick Start Testing (10 Menit)

### Step 1: Persiapan Project (2 menit)

```bash
# Jika belum ada project
cd smart-contract-2.0

# Install Node.js dependencies
npm install

# Setup Python virtual environment
python3 -m venv venv

# Install Python dependencies
./venv/bin/pip install -r ai-engine/requirements.txt
```

**Expected Output:**
```
✅ added 621 packages
✅ Successfully installed flask-3.0.0 flask-cors-6.0.1 numpy-2.3.4
```

### Step 2: Start Services (3 menit)

**Terminal 1 - Blockchain:**
```bash
npm run node
```
**Wait for:** `Started HTTP and WebSocket JSON-RPC server at http://127.0.0.1:8545/`

**Terminal 2 - Deploy Contracts:**
```bash
npm run deploy
```
**Wait for:** Contract addresses displayed
**Action:** Catat `CONTRACT_ADDRESS` yang muncul

**Terminal 3 - AI Engine:**
```bash
./venv/bin/python ai-engine/main.py
```
**Wait for:** `Running on http://127.0.0.1:5001`

**Terminal 4 - Oracle Service:**
```bash
node oracle-service/server.js
```
**Wait for:** `Oracle Service running on port 3002`

**Terminal 5 - Frontend:**
```bash
cd frontend
python3 -m http.server 8080
```
**Wait for:** `Serving HTTP on :: port 8080`

### Step 3: Verify Services (2 menit)

**Open Test Page:**
```
http://localhost:8080/test.html
```

**Click All Test Buttons:**
- [ ] Test AI Engine → Should show ✅ "AI Engine Connected!"
- [ ] Test Oracle Service → Should show ✅ "Oracle Service Connected!"
- [ ] Test Full Flow → Should show ✅ "Full Flow Working!"

**If all green ✅ → Ready to test!**

### Step 4: First Test (3 menit)

**Open Main App:**
```
http://localhost:8080
```

**Test 1: Create Contract**
1. Tipe Kontrak: `insurance`
2. Threshold: `7000`
3. Click "Buat Kontrak"
4. **Expected:** ✅ "Kontrak berhasil dibuat! Contract ID: 1"

**Test 2: AI Prediction**
1. Contract ID: `1`
2. Model: "Analisis Risiko"
3. Leave Input Data empty (will use default)
4. Check "Submit ke Blockchain"
5. Click "Request Prediksi"
6. **Expected:** ✅ Risk Score, Confidence, "Submitted to blockchain!"

**🎉 If both tests pass → Installation successful!**

---

## 🧪 Testing Scenarios

### Scenario 1: Basic Functionality Test

**Objective:** Test semua 3 model AI

**Test 1.1: Price Prediction**
```
Contract ID: 1
Model: Prediksi Harga
Input Data: (leave empty or use default)
Submit to Chain: ✓
```
**Expected Result:**
- Prediction: ~111.67
- Confidence: 50-70%
- Status: ✅ Success

**Test 1.2: Risk Analysis**
```
Contract ID: 1
Model: Analisis Risiko
Input Data: (leave empty)
Submit to Chain: ✓
```
**Expected Result:**
- Risk Score: 20-40
- Risk Level: LOW/MEDIUM
- Confidence: 80-90%
- Status: ✅ Success

**Test 1.3: Fraud Detection**
```
Contract ID: 1
Model: Deteksi Fraud
Input Data: (leave empty)
Submit to Chain: ✓
```
**Expected Result:**
- Fraud Score: 30-60
- Is Fraud: false/true
- Confidence: 60-80%
- Status: ✅ Success

**✅ Pass Criteria:** All 3 models return results with confidence > 50%

---

### Scenario 2: Custom Input Test

**Objective:** Test dengan custom data

**Test 2.1: Price Prediction - Bullish Trend**
```json
{
  "prices": [100, 105, 110, 115, 120]
}
```
**Expected:** Prediction > 120 (upward trend)

**Test 2.2: Risk Analysis - Low Risk**
```json
{
  "amount": 1000,
  "history_score": 95,
  "volatility": 0.1
}
```
**Expected:** Risk Score < 30 (LOW)

**Test 2.3: Risk Analysis - High Risk**
```json
{
  "amount": 100000,
  "history_score": 30,
  "volatility": 0.9
}
```
**Expected:** Risk Score > 70 (HIGH)

**Test 2.4: Fraud Detection - Normal**
```json
{
  "amount": 1500,
  "user_history": [1000, 1200, 1100, 1300],
  "speed": 2
}
```
**Expected:** Fraud Score < 40 (SAFE)

**Test 2.5: Fraud Detection - Suspicious**
```json
{
  "amount": 50000,
  "user_history": [1000, 1200, 1100],
  "speed": 20
}
```
**Expected:** Fraud Score > 60 (FRAUD DETECTED)

**✅ Pass Criteria:** Results match expected ranges

---

### Scenario 3: Threshold & Auto-Execution Test

**Objective:** Test auto-execution ketika threshold tercapai

**Setup:**
```
Create new contract:
Tipe: trading
Threshold: 100
```

**Test 3.1: Below Threshold**
```json
{
  "prices": [80, 82, 85, 83, 87]
}
```
**Expected:** 
- Prediction: ~88-90
- Contract Status: Still Active (no auto-execution)

**Test 3.2: Above Threshold**
```json
{
  "prices": [95, 98, 102, 105, 108]
}
```
**Expected:**
- Prediction: ~110-115
- Contract Status: Executed (threshold reached)

**✅ Pass Criteria:** Contract auto-executes when prediction > threshold

---

### Scenario 4: Blockchain Integration Test

**Objective:** Verify data tersimpan di blockchain

**Test 4.1: Submit Prediction**
```
1. Create contract (ID: 1)
2. Submit prediction with "Submit ke Blockchain" checked
3. Note the transaction hash (if shown)
```

**Test 4.2: Verify On-Chain (Terminal)**
```bash
npx hardhat console --network localhost

# In console:
const contract = await ethers.getContractAt("SmartContract2", "0x5FbDB2315678afecb367f032d93F642f64180aa3");
const prediction = await contract.getLatestPrediction(1);
console.log(prediction);
```

**Expected Output:**
```javascript
[
  timestamp: BigNumber,
  predictionType: "risk_analysis",
  value: 29,
  confidence: 85,
  oracle: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
]
```

**✅ Pass Criteria:** Data on-chain matches submitted prediction

---

### Scenario 5: Performance Test

**Objective:** Test response time & reliability

**Test 5.1: Response Time**
```bash
# Test AI Engine
time curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type":"price_prediction","data":{"prices":[100,105,110]}}'
```
**Expected:** < 200ms

**Test 5.2: Multiple Requests**
```bash
# Send 10 requests
for i in {1..10}; do
  curl -s -X POST http://localhost:5001/predict \
    -H "Content-Type: application/json" \
    -d '{"model_type":"price_prediction","data":{"prices":[100,105,110]}}' &
done
wait
```
**Expected:** All requests succeed

**Test 5.3: Concurrent Predictions**
```
Open 3 browser tabs
Submit predictions simultaneously from all tabs
```
**Expected:** All succeed without errors

**✅ Pass Criteria:** 
- Response time < 500ms
- 100% success rate
- No errors in console

---

### Scenario 6: Error Handling Test

**Objective:** Test error handling

**Test 6.1: Invalid Contract ID**
```
Contract ID: 999 (doesn't exist)
Model: Any
```
**Expected:** Error message (graceful handling)

**Test 6.2: Invalid JSON**
```json
{invalid json}
```
**Expected:** "Invalid JSON format" error

**Test 6.3: Missing Required Fields**
```json
{
  "prices": []
}
```
**Expected:** "Insufficient data" error

**Test 6.4: Extreme Values**
```json
{
  "amount": 999999999999,
  "history_score": 0,
  "volatility": 100
}
```
**Expected:** Handles gracefully, returns max risk score

**✅ Pass Criteria:** All errors handled gracefully, no crashes

---

### Scenario 7: Browser Compatibility Test

**Objective:** Test di berbagai browser

**Test Matrix:**

| Browser | Version | Status |
|---------|---------|--------|
| Chrome | Latest | [ ] Pass |
| Firefox | Latest | [ ] Pass |
| Safari | Latest | [ ] Pass |
| Edge | Latest | [ ] Pass |

**Test Steps:**
1. Open http://localhost:8080 in each browser
2. Create contract
3. Test all 3 AI models
4. Check console for errors

**✅ Pass Criteria:** Works in all major browsers

---

## 📊 Test Results Template

```markdown
## Test Results - [Date]

### Environment
- OS: [Mac/Windows/Linux]
- Node.js: [version]
- Python: [version]
- Browser: [name + version]

### Scenario 1: Basic Functionality
- [ ] Price Prediction: PASS/FAIL
- [ ] Risk Analysis: PASS/FAIL
- [ ] Fraud Detection: PASS/FAIL

### Scenario 2: Custom Input
- [ ] Bullish Trend: PASS/FAIL
- [ ] Low Risk: PASS/FAIL
- [ ] High Risk: PASS/FAIL
- [ ] Normal Transaction: PASS/FAIL
- [ ] Suspicious Transaction: PASS/FAIL

### Scenario 3: Threshold Test
- [ ] Below Threshold: PASS/FAIL
- [ ] Above Threshold: PASS/FAIL

### Scenario 4: Blockchain Integration
- [ ] Submit to Chain: PASS/FAIL
- [ ] Verify On-Chain: PASS/FAIL

### Scenario 5: Performance
- [ ] Response Time: [X]ms
- [ ] Multiple Requests: PASS/FAIL
- [ ] Concurrent: PASS/FAIL

### Scenario 6: Error Handling
- [ ] Invalid Contract: PASS/FAIL
- [ ] Invalid JSON: PASS/FAIL
- [ ] Missing Fields: PASS/FAIL
- [ ] Extreme Values: PASS/FAIL

### Scenario 7: Browser Compatibility
- [ ] Chrome: PASS/FAIL
- [ ] Firefox: PASS/FAIL
- [ ] Safari: PASS/FAIL
- [ ] Edge: PASS/FAIL

### Issues Found
1. [Issue description]
2. [Issue description]

### Overall Result
- Total Tests: [X]
- Passed: [X]
- Failed: [X]
- Success Rate: [X]%
```

---

## 🐛 Common Issues & Solutions

### Issue 1: Services Won't Start

**Symptoms:** Error saat start service

**Solutions:**
```bash
# Check ports
lsof -i :5001
lsof -i :3002
lsof -i :8080
lsof -i :8545

# Kill conflicting processes
kill -9 [PID]

# Restart services
```

### Issue 2: "Failed to fetch"

**Symptoms:** Error di browser console

**Solutions:**
1. Hard refresh: Cmd+Shift+R (Mac) / Ctrl+Shift+R (Win)
2. Check services: http://localhost:8080/test.html
3. Clear browser cache
4. Restart browser

### Issue 3: Predictions Not Accurate

**Symptoms:** Confidence < 50% atau hasil aneh

**Solutions:**
- Use more data points (for price prediction)
- Check input data format
- Verify data ranges are reasonable
- Try different scenarios

### Issue 4: Blockchain Connection Failed

**Symptoms:** "Contract not active" error

**Solutions:**
```bash
# Restart blockchain
npm run node

# Redeploy contracts
npm run deploy

# Create contract first
# Then submit predictions
```

---

## 📚 Testing Resources

**Documentation:**
- [TUTORIAL.md](TUTORIAL.md) - Full tutorial
- [EXAMPLES.md](EXAMPLES.md) - Copy-paste examples
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Fix issues

**Test Tools:**
- Test Page: http://localhost:8080/test.html
- Browser Console: F12
- Network Tab: F12 → Network
- Hardhat Console: `npx hardhat console`

**Sample Data:**
- [EXAMPLES.md](EXAMPLES.md) - 20+ examples
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Quick examples

---

## ✅ Testing Checklist

Before reporting "Testing Complete":

- [ ] All services start successfully
- [ ] Test page shows all green ✅
- [ ] Can create contracts
- [ ] All 3 AI models work
- [ ] Custom input works
- [ ] Blockchain submission works
- [ ] Threshold auto-execution works
- [ ] Error handling works
- [ ] Performance acceptable (< 500ms)
- [ ] Works in multiple browsers
- [ ] No console errors
- [ ] Documentation clear

---

## 🎉 Next Steps After Testing

**If All Tests Pass:**
1. ✅ Mark as "Production Ready"
2. 📝 Document any findings
3. 🚀 Deploy to Vercel/testnet
4. 📊 Monitor in production
5. 🎓 Share with team/community

**If Tests Fail:**
1. 📋 Document failures
2. 🔍 Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
3. 🐛 Report issues
4. 🔧 Fix and retest

---

**Happy Testing! 🧪**
