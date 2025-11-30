# 🚀 Quick Start - Smart Contract 2.0

## ✅ Status Service

Semua service sudah berjalan di localhost:

| Service | URL | Status |
|---------|-----|--------|
| 🌐 Frontend | http://localhost:8080 | ✅ Running |
| 🤖 AI Engine | http://localhost:5001 | ✅ Running |
| 🔗 Oracle Service | http://localhost:3002 | ✅ Running |
| ⛓️ Blockchain (Hardhat) | http://localhost:8545 | ✅ Running |

## 📝 Smart Contract Addresses

- **SmartContract2**: `0x5FbDB2315678afecb367f032d93F642f64180aa3`
- **IntelligentLayer**: `0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512`
- **Oracle Address**: `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`

## 🎯 Cara Menggunakan

### 1. Buka Frontend
Buka browser dan akses: **http://localhost:8080**

### 2. Buat Kontrak Adaptif
- Isi "Tipe Kontrak" (contoh: insurance, loan)
- Isi "Threshold Value" (contoh: 1000)
- Klik "Buat Kontrak"
- Catat Contract ID yang muncul

### 3. Request Prediksi AI
- Masukkan Contract ID yang sudah dibuat
- Pilih Model AI:
  - **Prediksi Harga**: Untuk prediksi harga aset
  - **Analisis Risiko**: Untuk evaluasi risiko
  - **Deteksi Fraud**: Untuk deteksi aktivitas mencurigakan
- (Optional) Isi Input Data dalam format JSON
- Centang "Submit ke Blockchain" jika ingin hasil disimpan on-chain
- Klik "Request Prediksi"

### 4. Lihat Hasil
Hasil prediksi akan muncul dengan:
- Nilai prediksi/score
- Confidence level (%)
- Model yang digunakan
- Status blockchain submission (jika dicentang)

## 🧪 Test API Langsung

### Test AI Engine
```bash
curl http://localhost:5001/health
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type":"price_prediction","data":{"prices":[100,105,110]}}'
```

### Test Oracle Service
```bash
curl http://localhost:3002/health
```

## 🎨 Contoh Use Case

### 1. Insurance Contract
```
Contract Type: insurance
Threshold: 7000
Model: risk_analysis
Data: {"amount": 5000, "history_score": 75, "volatility": 0.3}
```

### 2. Trading Contract
```
Contract Type: trading
Threshold: 120
Model: price_prediction
Data: {"prices": [100, 105, 110, 108, 112]}
```

### 3. Payment Verification
```
Contract Type: payment
Threshold: 60
Model: fraud_detection
Data: {"amount": 10000, "user_history": [1000, 1200], "speed": 5}
```

## 🛑 Stop Services

Jika ingin menghentikan semua service, tekan `Ctrl+C` di terminal masing-masing atau gunakan Kiro untuk stop processes.

## 📚 Dokumentasi Lengkap

- **ARCHITECTURE.md** - Arsitektur sistem lengkap
- **DEPLOYMENT.md** - Panduan deployment detail
- **README.md** - Overview proyek

## 🎉 Selamat Mencoba!

Aplikasi Smart Contract 2.0 Anda sudah siap digunakan!
