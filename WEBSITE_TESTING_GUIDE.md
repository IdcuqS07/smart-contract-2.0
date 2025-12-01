# 🌐 Website Testing Guide

Panduan lengkap untuk test Smart Contract 2.0 di browser

---

## 🚀 Quick Start

### Website URL
```
https://smartcontract2-linera-eight.vercel.app/
```

### Backend API
```
http://143.198.205.88
```

---

## 📝 Test Scenario 1: Create Adaptive Contract

### Step-by-Step:

1. **Buka website** di browser
2. **Scroll** ke section "📝 Create Adaptive Contract"
3. **Isi form**:
   ```
   Contract Type: insurance
   Threshold Value: 50000
   ```
4. **Klik** "Create Contract"
5. **Lihat response**:
   ```
   ✅ Contract Created!
   Contract ID: 1
   Type: insurance
   Threshold: 50000
   Status: Active
   ```

### Test Cases:

#### ✅ Valid Insurance Contract
```
Input:
  Contract Type: insurance
  Threshold: 50000

Expected:
  ✅ Success message
  Contract ID generated
  Status: Active
```

#### ✅ Valid Loan Contract
```
Input:
  Contract Type: loan
  Threshold: 25000

Expected:
  ✅ Success message
  Different Contract ID
  Status: Active
```

#### ✅ Valid Escrow Contract
```
Input:
  Contract Type: escrow
  Threshold: 100000

Expected:
  ✅ Success message
  Contract created
```

#### ❌ Empty Fields
```
Input:
  Contract Type: [empty]
  Threshold: [empty]

Expected:
  ❌ Error: "Please fill all fields"
```

---

## 🤖 Test Scenario 2: Get AI Prediction

### Step-by-Step:

1. **Scroll** ke section "🤖 Get AI Prediction"
2. **Isi form**:
   ```
   Symbol: BTC
   Timeframe: 1h
   ```
3. **Klik** "Get Prediction"
4. **Lihat response**:
   ```
   ✅ Prediction Result
   Predicted Price: $51,400
   Confidence: 50%
   Model: price_prediction
   ```

### Test Cases:

#### ✅ BTC 1 Hour
```
Input:
  Symbol: BTC
  Timeframe: 1h

Expected:
  ✅ Price prediction
  Confidence score
  Timestamp
```

#### ✅ ETH 4 Hours
```
Input:
  Symbol: ETH
  Timeframe: 4h

Expected:
  ✅ Different prediction
  Valid confidence
```

#### ❌ Invalid Symbol
```
Input:
  Symbol: X
  Timeframe: 1h

Expected:
  ❌ Error or low confidence
```

---

## 🔍 Test Scenario 3: Full Integration Flow

### Complete Workflow:

1. **Create Contract**
   ```
   POST /api/oracle/request
   Body: {"contractType":"insurance","threshold":50000}
   ```
   → Get Contract ID (e.g., 1)

2. **Request Prediction**
   ```
   POST /api/oracle/predict
   Body: {
     "contractId": 1,
     "modelType": "price_prediction",
     "data": {"prices": [50000, 51000, 49500, 52000, 51500]}
   }
   ```
   → Get Prediction ID (e.g., 1)

3. **View Contract with Prediction**
   ```
   GET /api/oracle/contract/1
   ```
   → See predictions array: [1]

4. **Get Latest Prediction**
   ```
   GET /api/oracle/prediction/latest/1
   ```
   → See full prediction result

---

## 🧪 Browser Console Testing

### Open Developer Tools (F12)

#### Test 1: Create Contract
```javascript
fetch('http://143.198.205.88/api/oracle/request', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    contractType: 'insurance',
    threshold: 50000
  })
})
.then(r => r.json())
.then(console.log);
```

#### Test 2: Get AI Prediction
```javascript
fetch('http://143.198.205.88/api/ai/predict', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    model_type: 'price_prediction',
    data: { prices: [50000, 51000, 49500, 52000, 51500] }
  })
})
.then(r => r.json())
.then(console.log);
```

#### Test 3: Get All Contracts
```javascript
fetch('http://143.198.205.88/api/oracle/contracts')
  .then(r => r.json())
  .then(console.log);
```

---

## 📊 Expected Behavior

### Visual Feedback

#### Loading State
- Button text changes to "Creating..." or "Loading..."
- Button becomes disabled
- Cursor shows loading spinner

#### Success State
- Green success message appears
- Result data displayed
- Button re-enabled

#### Error State
- Red error message appears
- Error details shown
- Button re-enabled

### Network Activity

Open **Network Tab** in DevTools:

1. **Request sent** to VPS
   ```
   POST http://143.198.205.88/api/oracle/request
   Status: 200 OK
   ```

2. **Response received**
   ```json
   {
     "success": true,
     "data": { ... }
   }
   ```

3. **Time**: Should be < 2 seconds

---

## 🎯 Performance Benchmarks

### Expected Response Times

| Endpoint | Expected Time | Status |
|----------|--------------|--------|
| Health Check | < 100ms | ✅ |
| Create Contract | < 500ms | ✅ |
| AI Prediction | < 2s | ✅ |
| Get Contract | < 200ms | ✅ |
| Get All Contracts | < 300ms | ✅ |

### Load Testing

Test with multiple requests:
```javascript
// Create 10 contracts
for (let i = 0; i < 10; i++) {
  fetch('http://143.198.205.88/api/oracle/request', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      contractType: 'insurance',
      threshold: 50000 + (i * 1000)
    })
  })
  .then(r => r.json())
  .then(data => console.log(`Contract ${i+1}:`, data));
}
```

---

## 🐛 Troubleshooting

### Issue: Button Not Responding
**Solution**: 
- Check browser console for errors (F12)
- Verify network connection
- Refresh page

### Issue: "Connection Error"
**Solution**:
- Check VPS status: `curl http://143.198.205.88/api/oracle/health`
- Verify CORS settings
- Check firewall

### Issue: Slow Response
**Solution**:
- Check VPS load
- Verify AI Engine is running
- Check network latency

### Issue: Invalid Response
**Solution**:
- Verify input format
- Check required fields
- Review API documentation

---

## ✅ Success Checklist

Before marking as complete, verify:

- [ ] Health endpoints return 200 OK
- [ ] Can create contracts successfully
- [ ] AI predictions return valid data
- [ ] Contract IDs increment correctly
- [ ] Predictions linked to contracts
- [ ] Error handling works
- [ ] Loading states display
- [ ] Success messages show
- [ ] Network requests visible in DevTools
- [ ] Response times acceptable

---

## 🎬 Demo Script

**For Presentation:**

```
"Mari saya demonstrasikan Smart Contract 2.0 yang sudah live.

[Open website]
Ini adalah interface kami yang deployed di Vercel.

[Scroll to Create Contract]
Pertama, saya akan membuat adaptive contract.
Saya pilih type 'insurance' dengan threshold 50,000.

[Click Create Contract]
Seperti yang Anda lihat, contract berhasil dibuat dengan ID unik.
Backend kami di VPS memproses request ini secara real-time.

[Scroll to AI Prediction]
Sekarang saya akan request AI prediction untuk Bitcoin.

[Click Get Prediction]
AI Engine kami menganalisis data dan memberikan prediksi harga
dengan confidence score.

[Open DevTools Network]
Di sini Anda bisa lihat semua request ke backend VPS kami
yang berjalan dengan response time < 2 detik.

Semua ini berjalan di production environment yang fully operational."
```

---

## 📖 Additional Resources

- **API Documentation**: `API_ENDPOINTS.md`
- **Deployment Status**: `ORACLE_DEPLOYMENT_SUCCESS.md`
- **VPS Guide**: `VPS_DEPLOYMENT_SUCCESS.md`

---

**Happy Testing!** 🚀

All systems are operational and ready for demonstration.
