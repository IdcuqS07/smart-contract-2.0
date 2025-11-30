# ✅ Status Aplikasi Smart Contract 2.0

## 🟢 Service Status - SEMUA BERJALAN! (CORS FIXED ✅)

| Service | Port | Status | CORS | URL |
|---------|------|--------|------|-----|
| 🌐 Frontend | 8080 | ✅ Running | N/A | http://localhost:8080 |
| 🤖 AI Engine | 5001 | ✅ Running | ✅ Enabled | http://localhost:5001 |
| 🔗 Oracle | 3002 | ✅ Running | ✅ Enabled | http://localhost:3002 |
| ⛓️ Blockchain | 8545 | ✅ Running | N/A | http://localhost:8545 |

**⚠️ PENTING:** Jika baru saja restart service, **hard refresh browser** (Cmd+Shift+R atau Ctrl+Shift+R)

## 🎯 Cara Menggunakan

### 1. Buka Aplikasi Utama
**http://localhost:8080**

### 2. Test Koneksi (Jika Ada Masalah)
**http://localhost:8080/test.html**

Test page akan menunjukkan status setiap service.

### 3. Gunakan Aplikasi

#### Buat Kontrak:
1. Isi "Tipe Kontrak" (contoh: insurance)
2. Isi "Threshold" (contoh: 1000)
3. Klik "Buat Kontrak"
4. Catat Contract ID

#### Request Prediksi AI:
1. Masukkan Contract ID
2. Pilih Model AI:
   - 📈 Prediksi Harga
   - ⚠️ Analisis Risiko
   - 🔍 Deteksi Fraud
3. (Optional) Isi data JSON
4. Centang "Submit ke Blockchain" jika ingin
5. Klik "Request Prediksi"

## 🧪 Test Manual via Terminal

```bash
# Test AI Engine
curl http://localhost:5001/health

# Test Prediksi
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type":"price_prediction","data":{"prices":[100,105,110]}}'

# Test Oracle
curl http://localhost:3002/health

# Test Full Flow
curl -X POST http://localhost:3002/request-prediction \
  -H "Content-Type: application/json" \
  -d '{"contractId":1,"modelType":"risk_analysis","data":{"amount":5000},"submitToChain":false}'
```

## 🔧 Jika Ada Masalah

### Browser Tidak Bisa Connect?

1. **Buka Test Page**: http://localhost:8080/test.html
2. **Check Browser Console**: Tekan F12, lihat tab Console
3. **Lihat Panduan**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

### Service Tidak Berjalan?

```bash
# Check status
curl http://localhost:5001/health  # AI
curl http://localhost:3002/health  # Oracle
curl http://localhost:8080         # Frontend

# Restart jika perlu (lihat TROUBLESHOOTING.md)
```

## 🚀 Deploy ke Internet

Jika ingin aplikasi bisa diakses dari internet:

```bash
vercel --prod
```

Lihat: [VERCEL_READY.md](VERCEL_READY.md)

## 📊 Contoh Penggunaan

### Example 1: Price Prediction
```json
{
  "contractId": 1,
  "modelType": "price_prediction",
  "data": {
    "prices": [100, 105, 110, 108, 112]
  }
}
```

**Expected Result:**
- Prediction: ~111.67
- Confidence: 58-65%

### Example 2: Risk Analysis
```json
{
  "contractId": 1,
  "modelType": "risk_analysis",
  "data": {
    "amount": 5000,
    "history_score": 75,
    "volatility": 0.3
  }
}
```

**Expected Result:**
- Risk Score: 20-40
- Risk Level: LOW/MEDIUM
- Confidence: 85%

### Example 3: Fraud Detection
```json
{
  "contractId": 1,
  "modelType": "fraud_detection",
  "data": {
    "amount": 10000,
    "user_history": [1000, 1200, 1100],
    "speed": 5
  }
}
```

**Expected Result:**
- Fraud Score: 30-60
- Is Fraud: false/true
- Confidence: 65-80%

## 🎉 Selamat!

Aplikasi Smart Contract 2.0 Anda sudah berjalan dengan sempurna! 🚀

**Next Steps:**
- Explore fitur-fitur AI
- Test berbagai skenario
- Deploy ke Vercel untuk production
- Customize sesuai kebutuhan

---

**Need Help?** Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
