# ✅ Smart Contract 2.0 - Test Checklist

**Print halaman ini dan centang setiap item saat testing!**

---

## 📋 Pre-Testing Checklist

### Software Requirements
- [ ] Node.js v18+ installed (`node --version`)
- [ ] Python 3.8+ installed (`python3 --version`)
- [ ] npm installed (`npm --version`)
- [ ] pip installed (`pip3 --version`)
- [ ] Browser modern (Chrome/Firefox/Safari)

### Project Setup
- [ ] Dependencies installed (`npm install`)
- [ ] Python venv created (`python3 -m venv venv`)
- [ ] Python packages installed (`./venv/bin/pip install -r ai-engine/requirements.txt`)
- [ ] All files present (check README.md)

---

## 🚀 Service Startup Checklist

### Terminal 1: Blockchain
- [ ] Command: `npm run node`
- [ ] Status: ✅ "Started HTTP and WebSocket JSON-RPC server"
- [ ] URL: http://localhost:8545

### Terminal 2: Deploy Contracts
- [ ] Command: `npm run deploy`
- [ ] Status: ✅ Contract addresses displayed
- [ ] Note CONTRACT_ADDRESS: `_______________________`

### Terminal 3: AI Engine
- [ ] Command: `./venv/bin/python ai-engine/main.py`
- [ ] Status: ✅ "Running on http://127.0.0.1:5001"
- [ ] URL: http://localhost:5001

### Terminal 4: Oracle Service
- [ ] Command: `node oracle-service/server.js`
- [ ] Status: ✅ "Oracle Service running on port 3002"
- [ ] URL: http://localhost:3002

### Terminal 5: Frontend
- [ ] Command: `cd frontend && python3 -m http.server 8080`
- [ ] Status: ✅ "Serving HTTP on :: port 8080"
- [ ] URL: http://localhost:8080

---

## 🧪 Service Verification

### Test Page (http://localhost:8080/test.html)
- [ ] Test AI Engine → ✅ Green
- [ ] Test Oracle Service → ✅ Green
- [ ] Test Full Flow → ✅ Green

### Manual URL Check
- [ ] http://localhost:8080 → Frontend loads
- [ ] http://localhost:5001/health → {"status":"healthy"}
- [ ] http://localhost:3002/health → {"status":"healthy"}

---

## 🎯 Functional Testing

### Test 1: Create Contract
- [ ] Open http://localhost:8080
- [ ] Tipe Kontrak: `insurance`
- [ ] Threshold: `7000`
- [ ] Click "Buat Kontrak"
- [ ] Result: ✅ Contract ID displayed
- [ ] Note Contract ID: `_______`

### Test 2: Price Prediction
- [ ] Contract ID: (from above)
- [ ] Model: "Prediksi Harga"
- [ ] Input Data: (leave empty)
- [ ] Click "Request Prediksi"
- [ ] Result: ✅ Prediction + Confidence shown
- [ ] Confidence: _____%

### Test 3: Risk Analysis
- [ ] Contract ID: (same)
- [ ] Model: "Analisis Risiko"
- [ ] Input Data: (leave empty)
- [ ] Check "Submit ke Blockchain"
- [ ] Click "Request Prediksi"
- [ ] Result: ✅ Risk Score + Level shown
- [ ] Risk Score: _____
- [ ] Risk Level: LOW / MEDIUM / HIGH

### Test 4: Fraud Detection
- [ ] Contract ID: (same)
- [ ] Model: "Deteksi Fraud"
- [ ] Input Data: (leave empty)
- [ ] Click "Request Prediksi"
- [ ] Result: ✅ Fraud Score shown
- [ ] Fraud Score: _____
- [ ] Status: SAFE / FRAUD DETECTED

---

## 📊 Custom Input Testing

### Test 5: Custom Price Data
```json
{"prices": [100, 105, 110, 115, 120]}
```
- [ ] Input above data
- [ ] Result: ✅ Prediction > 120
- [ ] Actual: _____

### Test 6: Low Risk Scenario
```json
{"amount": 1000, "history_score": 95, "volatility": 0.1}
```
- [ ] Input above data
- [ ] Result: ✅ Risk Score < 30
- [ ] Actual: _____

### Test 7: High Risk Scenario
```json
{"amount": 100000, "history_score": 30, "volatility": 0.9}
```
- [ ] Input above data
- [ ] Result: ✅ Risk Score > 70
- [ ] Actual: _____

### Test 8: Fraud Detection - Normal
```json
{"amount": 1500, "user_history": [1000, 1200, 1100], "speed": 2}
```
- [ ] Input above data
- [ ] Result: ✅ Fraud Score < 40
- [ ] Actual: _____

### Test 9: Fraud Detection - Suspicious
```json
{"amount": 50000, "user_history": [1000, 1200], "speed": 20}
```
- [ ] Input above data
- [ ] Result: ✅ Fraud Score > 60
- [ ] Actual: _____

---

## 🔗 Blockchain Integration

### Test 10: Verify On-Chain Data
- [ ] Submit prediction with "Submit ke Blockchain" checked
- [ ] Open terminal: `npx hardhat console --network localhost`
- [ ] Run verification commands
- [ ] Result: ✅ Data matches

---

## ⚡ Performance Testing

### Test 11: Response Time
- [ ] Submit prediction
- [ ] Check Network tab (F12)
- [ ] Response time: _____ms
- [ ] Result: ✅ < 500ms

### Test 12: Multiple Requests
- [ ] Submit 5 predictions quickly
- [ ] Result: ✅ All succeed
- [ ] Any errors? YES / NO

---

## 🌐 Browser Compatibility

### Test 13: Chrome
- [ ] Open in Chrome
- [ ] Create contract: ✅
- [ ] Test prediction: ✅
- [ ] No console errors: ✅

### Test 14: Firefox
- [ ] Open in Firefox
- [ ] Create contract: ✅
- [ ] Test prediction: ✅
- [ ] No console errors: ✅

### Test 15: Safari (Mac only)
- [ ] Open in Safari
- [ ] Create contract: ✅
- [ ] Test prediction: ✅
- [ ] No console errors: ✅

---

## 🐛 Error Handling

### Test 16: Invalid Contract ID
- [ ] Contract ID: `999`
- [ ] Submit prediction
- [ ] Result: ✅ Error handled gracefully

### Test 17: Invalid JSON
- [ ] Input: `{invalid}`
- [ ] Submit
- [ ] Result: ✅ "Invalid JSON format" error

### Test 18: Empty Data
- [ ] Input: `{"prices": []}`
- [ ] Submit
- [ ] Result: ✅ "Insufficient data" error

---

## 📝 Test Summary

**Date:** _______________
**Tester:** _______________
**Environment:** Mac / Windows / Linux

### Results
- Total Tests: 18
- Passed: _____
- Failed: _____
- Success Rate: _____%

### Issues Found
1. _________________________________
2. _________________________________
3. _________________________________

### Notes
_________________________________
_________________________________
_________________________________

### Overall Status
- [ ] ✅ PASS - Ready for production
- [ ] ⚠️ PASS WITH ISSUES - Minor fixes needed
- [ ] ❌ FAIL - Major issues found

---

## 🎉 Sign-Off

**Tested By:** _______________
**Date:** _______________
**Signature:** _______________

---

**Next Steps:**
- [ ] Document issues in GitHub
- [ ] Fix critical bugs
- [ ] Retest failed scenarios
- [ ] Deploy to staging/production
- [ ] Monitor in production

---

**For detailed testing guide, see:** [TESTING_GUIDE.md](TESTING_GUIDE.md)
