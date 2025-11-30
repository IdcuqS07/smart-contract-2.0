# 📖 Tutorial Lengkap Smart Contract 2.0

## 🎯 Apa itu Smart Contract 2.0?

Smart Contract 2.0 adalah evolusi dari smart contract tradisional yang mengintegrasikan **Artificial Intelligence (AI)** dengan **Blockchain**. Kontrak ini tidak hanya mengeksekusi perintah statis, tetapi dapat **beradaptasi** berdasarkan prediksi AI.

### Fitur Utama:
- 🤖 **3 Model AI**: Price Prediction, Risk Analysis, Fraud Detection
- ⛓️ **Blockchain Integration**: Immutable & transparent
- 🔄 **Adaptive Contracts**: Auto-execution berdasarkan AI predictions
- 🌐 **Web Interface**: User-friendly dashboard

---

## 📚 Daftar Isi

1. [Setup & Instalasi](#1-setup--instalasi)
2. [Memahami Interface](#2-memahami-interface)
3. [Membuat Kontrak Adaptif](#3-membuat-kontrak-adaptif)
4. [Menggunakan Model AI](#4-menggunakan-model-ai)
5. [Use Cases & Contoh](#5-use-cases--contoh)
6. [Advanced Features](#6-advanced-features)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Setup & Instalasi

### Option A: Lokal Development (Recommended untuk Learning)

#### Step 1: Install Dependencies
```bash
# Clone atau download project
cd smart-contract-2.0

# Install Node.js dependencies
npm install

# Install Python dependencies
python3 -m venv venv
./venv/bin/pip install -r ai-engine/requirements.txt
```

#### Step 2: Start Services (4 Terminals)

**Terminal 1 - Blockchain:**
```bash
npm run node
```
Output: `Started HTTP and WebSocket JSON-RPC server at http://127.0.0.1:8545/`

**Terminal 2 - Deploy Contracts:**
```bash
npm run deploy
```
Output: Contract addresses (catat ini!)

**Terminal 3 - AI Engine:**
```bash
./venv/bin/python ai-engine/main.py
```
Output: `Running on http://127.0.0.1:5001`

**Terminal 4 - Oracle Service:**
```bash
node oracle-service/server.js
```
Output: `Oracle Service running on port 3002`

**Terminal 5 - Frontend:**
```bash
cd frontend
python3 -m http.server 8080
```

#### Step 3: Buka Browser
```
http://localhost:8080
```

### Option B: Deploy ke Vercel (Recommended untuk Production)

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel --prod
```

Aplikasi akan live di: `https://your-app.vercel.app`

---

## 2. Memahami Interface

### Dashboard Utama

Ketika Anda membuka `http://localhost:8080`, Anda akan melihat:

#### 📝 Section 1: Buat Kontrak Adaptif
- **Tipe Kontrak**: Jenis kontrak (insurance, loan, trading, dll)
- **Threshold Value**: Nilai ambang batas untuk auto-execution
- **Button "Buat Kontrak"**: Membuat kontrak baru di blockchain

#### 🤖 Section 2: Model AI Tersedia
3 kartu model AI:
- **📈 Prediksi Harga**: Prediksi harga aset berdasarkan data historis
- **⚠️ Analisis Risiko**: Evaluasi risiko transaksi
- **🔍 Deteksi Fraud**: Identifikasi aktivitas mencurigakan

#### 🔮 Section 3: Request Prediksi AI
- **Contract ID**: ID kontrak yang sudah dibuat
- **Model Type**: Pilih model AI
- **Input Data**: Data dalam format JSON
- **Submit ke Blockchain**: Checkbox untuk menyimpan hasil on-chain

---

## 3. Membuat Kontrak Adaptif

### Langkah-langkah:

#### Step 1: Tentukan Tipe Kontrak
Contoh tipe kontrak:
- `insurance` - Kontrak asuransi
- `loan` - Kontrak pinjaman
- `trading` - Kontrak trading
- `payment` - Kontrak pembayaran

#### Step 2: Set Threshold
Threshold adalah nilai yang akan memicu auto-execution.

**Contoh:**
- Insurance: Threshold 7000 (risk score > 7000 = claim approved)
- Trading: Threshold 120 (price > 120 = auto sell)
- Loan: Threshold 60 (fraud score > 60 = reject)

#### Step 3: Klik "Buat Kontrak"

**Output:**
```
✅ Kontrak berhasil dibuat!
Contract ID: 1
Type: insurance
Threshold: 7000
```

**Catat Contract ID ini!** Anda akan membutuhkannya untuk request prediksi.

### Contoh Praktis:

**Scenario: Kontrak Asuransi Otomatis**
```
Tipe Kontrak: insurance
Threshold: 7000
```

Artinya: Jika risk score dari AI > 7000, kontrak akan otomatis dieksekusi (claim approved).

---

## 4. Menggunakan Model AI

### Model 1: 📈 Prediksi Harga

**Kegunaan:** Memprediksi harga aset di masa depan berdasarkan data historis.

**Input Data:**
```json
{
  "prices": [100, 105, 110, 108, 112]
}
```

**Cara Menggunakan:**
1. Masukkan Contract ID (contoh: 1)
2. Pilih "Prediksi Harga"
3. Isi Input Data dengan array harga historis
4. Klik "Request Prediksi"

**Output:**
```
✅ Prediksi berhasil!
Prediksi: 111.67
Confidence: 59%
Model: price_prediction
```

**Interpretasi:**
- Harga diprediksi akan naik ke ~111.67
- Confidence 59% = prediksi cukup reliable
- Bisa digunakan untuk auto-trading contracts

### Model 2: ⚠️ Analisis Risiko

**Kegunaan:** Mengevaluasi risiko transaksi atau kontrak.

**Input Data:**
```json
{
  "amount": 5000,
  "history_score": 75,
  "volatility": 0.3
}
```

**Parameter:**
- `amount`: Jumlah transaksi
- `history_score`: Skor riwayat (0-100, higher = better)
- `volatility`: Volatilitas pasar (0-1)

**Cara Menggunakan:**
1. Masukkan Contract ID
2. Pilih "Analisis Risiko"
3. Isi Input Data
4. Centang "Submit ke Blockchain" jika ingin
5. Klik "Request Prediksi"

**Output:**
```
✅ Prediksi berhasil!
Risk Score: 29
Risk Level: LOW
Confidence: 85%
📤 Submitted to blockchain!
```

**Interpretasi:**
- Risk Score 29 = Risiko rendah
- Risk Level: LOW (0-40), MEDIUM (41-70), HIGH (71-100)
- Confidence 85% = prediksi sangat reliable
- Hasil disimpan di blockchain (immutable)

### Model 3: 🔍 Deteksi Fraud

**Kegunaan:** Mendeteksi kemungkinan fraud dalam transaksi.

**Input Data:**
```json
{
  "amount": 10000,
  "user_history": [1000, 1200, 1100],
  "speed": 5
}
```

**Parameter:**
- `amount`: Jumlah transaksi saat ini
- `user_history`: Array transaksi sebelumnya
- `speed`: Kecepatan transaksi (tx per hour)

**Cara Menggunakan:**
1. Masukkan Contract ID
2. Pilih "Deteksi Fraud"
3. Isi Input Data
4. Klik "Request Prediksi"

**Output:**
```
✅ Prediksi berhasil!
Fraud Score: 45
Status: SAFE
Confidence: 65%
```

**Interpretasi:**
- Fraud Score 45 = Tidak terdeteksi fraud
- Status: SAFE (< 60) atau FRAUD DETECTED (> 60)
- Confidence 65% = prediksi cukup reliable

---

## 5. Use Cases & Contoh

### Use Case 1: Asuransi Otomatis

**Scenario:** Asuransi kesehatan yang otomatis approve/reject claim berdasarkan risk analysis.

**Setup:**
```
Tipe Kontrak: insurance
Threshold: 7000
```

**Workflow:**
1. User submit claim
2. AI analyze risk: amount, history, medical records
3. Jika risk score < 7000 → Auto approve
4. Jika risk score > 7000 → Manual review

**Implementasi:**
```json
{
  "contractId": 1,
  "modelType": "risk_analysis",
  "data": {
    "amount": 5000,
    "history_score": 80,
    "volatility": 0.2
  },
  "submitToChain": true
}
```

**Result:**
```
Risk Score: 25 (LOW)
→ Auto Approved! ✅
```

### Use Case 2: Trading Otomatis

**Scenario:** Auto-trading bot yang buy/sell berdasarkan price prediction.

**Setup:**
```
Tipe Kontrak: trading
Threshold: 120
```

**Workflow:**
1. AI predict harga akan naik ke 125
2. Jika prediction > threshold (120) → Auto buy
3. Jika prediction < threshold → Hold/Sell

**Implementasi:**
```json
{
  "contractId": 2,
  "modelType": "price_prediction",
  "data": {
    "prices": [100, 105, 110, 115, 118]
  },
  "submitToChain": true
}
```

**Result:**
```
Prediction: 122.5
→ Auto Buy Executed! ✅
```

### Use Case 3: Payment Verification

**Scenario:** Sistem pembayaran yang otomatis block transaksi mencurigakan.

**Setup:**
```
Tipe Kontrak: payment
Threshold: 60
```

**Workflow:**
1. User initiate payment
2. AI check fraud probability
3. Jika fraud score > 60 → Block transaction
4. Jika fraud score < 60 → Process payment

**Implementasi:**
```json
{
  "contractId": 3,
  "modelType": "fraud_detection",
  "data": {
    "amount": 50000,
    "user_history": [1000, 1200, 1100],
    "speed": 15
  },
  "submitToChain": true
}
```

**Result:**
```
Fraud Score: 75 (HIGH)
→ Transaction Blocked! ⚠️
```

### Use Case 4: Loan Approval

**Scenario:** Sistem pinjaman yang otomatis approve berdasarkan risk & fraud analysis.

**Setup:**
```
Tipe Kontrak: loan
Threshold: 5000
```

**Workflow:**
1. User apply for loan
2. AI analyze risk + fraud
3. Combined score < threshold → Approve
4. Combined score > threshold → Reject

**Implementasi:**

**Step 1: Risk Analysis**
```json
{
  "contractId": 4,
  "modelType": "risk_analysis",
  "data": {
    "amount": 10000,
    "history_score": 85,
    "volatility": 0.15
  }
}
```
Result: Risk Score = 20

**Step 2: Fraud Detection**
```json
{
  "contractId": 4,
  "modelType": "fraud_detection",
  "data": {
    "amount": 10000,
    "user_history": [2000, 2500, 2200],
    "speed": 1
  }
}
```
Result: Fraud Score = 15

**Combined Score:** 20 + 15 = 35 < 5000
**Result:** Loan Approved! ✅

---

## 6. Advanced Features

### 6.1 Submit ke Blockchain

Ketika Anda centang "Submit ke Blockchain":
- Hasil prediksi disimpan on-chain
- Immutable & transparent
- Bisa di-audit kapan saja
- Auto-execution jika threshold tercapai

**Cara Melihat Hasil di Blockchain:**
```bash
# Via Hardhat console
npx hardhat console --network localhost

# Get latest prediction
const contract = await ethers.getContractAt("SmartContract2", "CONTRACT_ADDRESS");
const prediction = await contract.getLatestPrediction(1);
console.log(prediction);
```

### 6.2 Multiple Predictions

Anda bisa request multiple predictions untuk satu kontrak:

```javascript
// Prediction 1: Risk Analysis
Request → Risk Score: 25

// Prediction 2: Fraud Detection  
Request → Fraud Score: 15

// Prediction 3: Price Prediction
Request → Price: 125

// Contract akan track semua predictions
```

### 6.3 Custom Input Data

Anda bisa customize input data sesuai kebutuhan:

**Price Prediction:**
```json
{
  "prices": [100, 105, 110, 108, 112, 115, 118, 120]
}
```
Lebih banyak data = prediksi lebih akurat

**Risk Analysis:**
```json
{
  "amount": 50000,
  "history_score": 90,
  "volatility": 0.1,
  "market_condition": "stable"
}
```

**Fraud Detection:**
```json
{
  "amount": 100000,
  "user_history": [5000, 5500, 5200, 5800],
  "speed": 20,
  "location": "unusual",
  "device": "new"
}
```

### 6.4 Monitoring & Analytics

**Via Browser Console (F12):**
```javascript
// Check all requests
console.log('Monitoring predictions...');

// Network tab shows all API calls
// Console tab shows responses
```

**Via Terminal:**
```bash
# Watch AI Engine logs
tail -f ai-engine.log

# Watch Oracle logs
tail -f oracle.log

# Watch blockchain events
npx hardhat run scripts/watch-events.js
```

---

## 7. Troubleshooting

### Problem 1: "Failed to fetch"

**Solusi:**
1. Hard refresh browser (Cmd+Shift+R atau Ctrl+Shift+R)
2. Check services running: http://localhost:8080/test.html
3. Lihat [FIX_APPLIED.md](FIX_APPLIED.md)

### Problem 2: "Contract not active"

**Solusi:**
```bash
# Create contract first
npx hardhat run scripts/create-contract.js --network localhost
```

### Problem 3: Prediction tidak akurat

**Tips untuk meningkatkan akurasi:**
- Gunakan lebih banyak data historis
- Update model AI dengan data terbaru
- Adjust confidence threshold
- Combine multiple models

### Problem 4: Blockchain connection failed

**Solusi:**
```bash
# Restart blockchain
npm run node

# Redeploy contracts
npm run deploy

# Update CONTRACT_ADDRESS di .env
```

---

## 🎓 Learning Path

### Beginner (1-2 jam)
1. ✅ Setup lokal development
2. ✅ Buat kontrak pertama
3. ✅ Test semua 3 model AI
4. ✅ Pahami output & confidence score

### Intermediate (3-5 jam)
1. ✅ Implement use case sederhana
2. ✅ Submit predictions ke blockchain
3. ✅ Monitor events & logs
4. ✅ Customize input data

### Advanced (1-2 hari)
1. ✅ Deploy ke testnet (Sepolia)
2. ✅ Integrate dengan aplikasi lain
3. ✅ Customize AI models
4. ✅ Build production-ready system

---

## 📚 Resources

### Dokumentasi
- **[README.md](README.md)** - Overview
- **[QUICK_START.md](QUICK_START.md)** - Quick start guide
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Troubleshooting guide

### Deployment
- **[VERCEL_READY.md](VERCEL_READY.md)** - Deploy to Vercel
- **[DEPLOYMENT_OPTIONS.md](DEPLOYMENT_OPTIONS.md)** - Compare options

### Status & Testing
- **[STATUS.md](STATUS.md)** - Current status
- **http://localhost:8080/test.html** - Test page

---

## 🎉 Selamat!

Anda sekarang sudah memahami cara menggunakan Smart Contract 2.0!

**Next Steps:**
1. Explore semua fitur
2. Build use case Anda sendiri
3. Deploy ke production
4. Share dengan komunitas

**Need Help?**
- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Open issue di GitHub
- Join komunitas

---

**Happy Building! 🚀**
