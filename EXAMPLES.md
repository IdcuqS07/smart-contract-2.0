# 💡 Contoh Praktis Smart Contract 2.0

## 📋 Copy-Paste Examples

Contoh-contoh ini bisa langsung di-copy dan paste ke aplikasi!

---

## 1. 📈 Price Prediction Examples

### Example 1.1: Crypto Trading
```json
{
  "prices": [45000, 46500, 47200, 46800, 48000]
}
```
**Use Case:** Prediksi harga Bitcoin
**Expected:** Price ~48500, Confidence 60-70%

### Example 1.2: Stock Market
```json
{
  "prices": [150, 152, 155, 153, 157, 160, 158]
}
```
**Use Case:** Prediksi harga saham
**Expected:** Price ~160-162, Confidence 65-75%

### Example 1.3: Commodity
```json
{
  "prices": [80, 82, 85, 83, 87, 90, 88, 92]
}
```
**Use Case:** Prediksi harga emas/minyak
**Expected:** Price ~92-95, Confidence 70-80%

---

## 2. ⚠️ Risk Analysis Examples

### Example 2.1: Low Risk Insurance
```json
{
  "amount": 3000,
  "history_score": 90,
  "volatility": 0.1
}
```
**Use Case:** Asuransi kesehatan - pasien dengan riwayat baik
**Expected:** Risk Score 15-25 (LOW), Auto-approve

### Example 2.2: Medium Risk Loan
```json
{
  "amount": 15000,
  "history_score": 60,
  "volatility": 0.5
}
```
**Use Case:** Pinjaman - peminjam dengan riwayat sedang
**Expected:** Risk Score 40-60 (MEDIUM), Manual review

### Example 2.3: High Risk Investment
```json
{
  "amount": 50000,
  "history_score": 40,
  "volatility": 0.8
}
```
**Use Case:** Investasi berisiko tinggi
**Expected:** Risk Score 70-90 (HIGH), Reject atau extra verification

### Example 2.4: Micro Loan (Safe)
```json
{
  "amount": 500,
  "history_score": 85,
  "volatility": 0.2
}
```
**Use Case:** Pinjaman mikro - peminjam terpercaya
**Expected:** Risk Score 10-20 (LOW), Instant approval

---

## 3. 🔍 Fraud Detection Examples

### Example 3.1: Normal Transaction
```json
{
  "amount": 1500,
  "user_history": [1000, 1200, 1100, 1300],
  "speed": 2
}
```
**Use Case:** Transaksi normal sesuai pola
**Expected:** Fraud Score 10-30 (SAFE)

### Example 3.2: Suspicious Amount
```json
{
  "amount": 50000,
  "user_history": [1000, 1200, 1100],
  "speed": 5
}
```
**Use Case:** Transaksi jauh lebih besar dari biasanya
**Expected:** Fraud Score 50-70 (WARNING)

### Example 3.3: High Speed Attack
```json
{
  "amount": 10000,
  "user_history": [2000, 2500, 2200],
  "speed": 25
}
```
**Use Case:** Banyak transaksi dalam waktu singkat
**Expected:** Fraud Score 70-90 (FRAUD DETECTED)

### Example 3.4: New User - Large Transaction
```json
{
  "amount": 100000,
  "user_history": [],
  "speed": 1
}
```
**Use Case:** User baru langsung transaksi besar
**Expected:** Fraud Score 60-80 (SUSPICIOUS)

---

## 4. 🎯 Complete Use Case Examples

### Use Case 1: Insurance Claim System

**Step 1: Create Contract**
```
Tipe Kontrak: insurance
Threshold: 7000
```

**Step 2: Low Risk Claim (Auto-Approve)**
```json
{
  "contractId": 1,
  "modelType": "risk_analysis",
  "data": {
    "amount": 2000,
    "history_score": 95,
    "volatility": 0.1
  },
  "submitToChain": true
}
```
**Result:** Risk Score 12 → ✅ Auto Approved

**Step 3: High Risk Claim (Manual Review)**
```json
{
  "contractId": 1,
  "modelType": "risk_analysis",
  "data": {
    "amount": 50000,
    "history_score": 50,
    "volatility": 0.7
  },
  "submitToChain": true
}
```
**Result:** Risk Score 78 → ⚠️ Manual Review Required

---

### Use Case 2: Crypto Trading Bot

**Step 1: Create Contract**
```
Tipe Kontrak: trading
Threshold: 50000
```

**Step 2: Predict Price**
```json
{
  "contractId": 2,
  "modelType": "price_prediction",
  "data": {
    "prices": [48000, 49000, 50500, 49800, 51000]
  },
  "submitToChain": true
}
```
**Result:** Prediction 51500 → ✅ Above threshold, Auto BUY

**Step 3: Monitor & Sell**
```json
{
  "contractId": 2,
  "modelType": "price_prediction",
  "data": {
    "prices": [51500, 52000, 51800, 51500, 51000]
  },
  "submitToChain": true
}
```
**Result:** Prediction 50500 → ⚠️ Below threshold, Auto SELL

---

### Use Case 3: E-commerce Payment Verification

**Step 1: Create Contract**
```
Tipe Kontrak: payment
Threshold: 65
```

**Step 2: Normal Payment (Process)**
```json
{
  "contractId": 3,
  "modelType": "fraud_detection",
  "data": {
    "amount": 500,
    "user_history": [400, 450, 480, 520],
    "speed": 1
  },
  "submitToChain": true
}
```
**Result:** Fraud Score 15 → ✅ Payment Processed

**Step 3: Suspicious Payment (Block)**
```json
{
  "contractId": 3,
  "modelType": "fraud_detection",
  "data": {
    "amount": 10000,
    "user_history": [400, 450, 480],
    "speed": 20
  },
  "submitToChain": true
}
```
**Result:** Fraud Score 85 → ❌ Payment Blocked

---

### Use Case 4: Loan Approval System

**Step 1: Create Contract**
```
Tipe Kontrak: loan
Threshold: 5000
```

**Step 2: Check Risk**
```json
{
  "contractId": 4,
  "modelType": "risk_analysis",
  "data": {
    "amount": 20000,
    "history_score": 80,
    "volatility": 0.25
  },
  "submitToChain": false
}
```
**Result:** Risk Score 28

**Step 3: Check Fraud**
```json
{
  "contractId": 4,
  "modelType": "fraud_detection",
  "data": {
    "amount": 20000,
    "user_history": [5000, 5500, 5200, 5800],
    "speed": 1
  },
  "submitToChain": false
}
```
**Result:** Fraud Score 20

**Step 4: Combined Decision**
```
Combined Score: 28 + 20 = 48
Threshold: 5000
Result: 48 < 5000 → ✅ Loan Approved!
```

---

## 5. 🧪 Testing Scenarios

### Scenario 1: Stress Test (High Volume)
```bash
# Test 1: Low risk
curl -X POST http://localhost:3002/request-prediction \
  -H "Content-Type: application/json" \
  -d '{"contractId":1,"modelType":"risk_analysis","data":{"amount":1000,"history_score":90,"volatility":0.1}}'

# Test 2: Medium risk
curl -X POST http://localhost:3002/request-prediction \
  -H "Content-Type: application/json" \
  -d '{"contractId":1,"modelType":"risk_analysis","data":{"amount":10000,"history_score":60,"volatility":0.5}}'

# Test 3: High risk
curl -X POST http://localhost:3002/request-prediction \
  -H "Content-Type: application/json" \
  -d '{"contractId":1,"modelType":"risk_analysis","data":{"amount":100000,"history_score":30,"volatility":0.9}}'
```

### Scenario 2: Edge Cases

**Empty History:**
```json
{
  "amount": 5000,
  "user_history": [],
  "speed": 1
}
```

**Single Price:**
```json
{
  "prices": [100]
}
```
**Expected:** Error - Insufficient data

**Extreme Values:**
```json
{
  "amount": 999999999,
  "history_score": 0,
  "volatility": 1.0
}
```
**Expected:** Risk Score 100 (MAX)

---

## 6. 📊 Benchmark Data

### Performance Expectations

| Model | Avg Response Time | Confidence Range |
|-------|------------------|------------------|
| Price Prediction | 50-100ms | 50-80% |
| Risk Analysis | 30-80ms | 70-90% |
| Fraud Detection | 40-90ms | 60-85% |

### Accuracy Guidelines

| Confidence | Accuracy | Recommendation |
|-----------|----------|----------------|
| 90-100% | Very High | Trust completely |
| 70-89% | High | Use with monitoring |
| 50-69% | Medium | Combine with other data |
| < 50% | Low | Need more training data |

---

## 7. 🎨 Custom Examples

### Create Your Own!

**Template:**
```json
{
  "contractId": YOUR_CONTRACT_ID,
  "modelType": "MODEL_TYPE",
  "data": {
    // Your custom data here
  },
  "submitToChain": true/false
}
```

**Tips:**
- Start with simple data
- Gradually add complexity
- Test edge cases
- Monitor confidence scores
- Adjust threshold based on results

---

## 📚 More Resources

- **[TUTORIAL.md](TUTORIAL.md)** - Full tutorial
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick reference
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Fix issues

---

**Copy, paste, and start experimenting! 🚀**
