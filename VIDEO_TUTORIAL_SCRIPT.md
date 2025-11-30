# 🎥 Video Tutorial Script - Smart Contract 2.0

## Video 1: Introduction & Setup (5 menit)

### Scene 1: Opening (30 detik)
```
[Screen: Logo Smart Contract 2.0]

"Halo! Selamat datang di tutorial Smart Contract 2.0.
Smart Contract 2.0 adalah evolusi dari smart contract tradisional
yang mengintegrasikan AI dengan blockchain.

Dalam video ini, kita akan belajar:
- Setup aplikasi
- Membuat kontrak pertama
- Menggunakan AI untuk prediksi
"
```

### Scene 2: Architecture Overview (1 menit)
```
[Screen: Architecture diagram]

"Smart Contract 2.0 terdiri dari 4 komponen utama:

1. Frontend - Interface web untuk user
2. AI Engine - 3 model ML: Price Prediction, Risk Analysis, Fraud Detection
3. Oracle Service - Bridge antara AI dan blockchain
4. Smart Contract - Kontrak di blockchain

Semua komponen ini bekerja sama untuk menciptakan
kontrak yang adaptif dan cerdas."
```

### Scene 3: Installation (2 menit)
```
[Screen: Terminal]

"Mari kita mulai setup. Buka terminal dan jalankan:

Terminal 1:
$ npm run node
[Show output]

Terminal 2:
$ npm run deploy
[Show contract addresses]

Terminal 3:
$ ./venv/bin/python ai-engine/main.py
[Show AI Engine starting]

Terminal 4:
$ node oracle-service/server.js
[Show Oracle connected]

Sekarang buka browser di http://localhost:8080
[Show browser opening]

Dan voila! Aplikasi sudah berjalan!"
```

### Scene 4: Interface Tour (1.5 menit)
```
[Screen: Browser - localhost:8080]

"Mari kita lihat interface-nya.

Di bagian atas, ada section untuk membuat kontrak adaptif.
[Highlight section]

Di tengah, ada 3 model AI yang tersedia:
- Price Prediction untuk prediksi harga
- Risk Analysis untuk analisis risiko
- Fraud Detection untuk deteksi fraud
[Click each card]

Dan di bawah, ada form untuk request prediksi AI.
[Scroll to form]

Mudah kan? Mari kita coba!"
```

---

## Video 2: Membuat Kontrak & Prediksi (7 menit)

### Scene 1: Create Contract (2 menit)
```
[Screen: Browser]

"Langkah pertama, kita buat kontrak adaptif.

Misalnya kita ingin buat kontrak asuransi.
[Type 'insurance' in Tipe Kontrak]

Set threshold ke 7000.
[Type '7000' in Threshold]

Artinya, jika risk score dari AI lebih dari 7000,
kontrak akan otomatis dieksekusi.

Klik 'Buat Kontrak'.
[Click button]

Boom! Kontrak berhasil dibuat dengan ID 1.
[Show success message]

Catat ID ini, kita akan pakai untuk prediksi."
```

### Scene 2: Price Prediction (2 menit)
```
[Screen: Browser - scroll to prediction form]

"Sekarang mari kita coba prediksi harga.

Masukkan Contract ID: 1
[Type '1']

Pilih model 'Prediksi Harga'
[Select from dropdown]

Untuk input data, kita masukkan array harga historis:
[Type in textarea]
{
  "prices": [100, 105, 110, 108, 112]
}

Klik 'Request Prediksi'
[Click button]

Dan... hasil keluar!
[Show result]

Prediksi: 111.67
Confidence: 59%

Artinya AI memprediksi harga akan naik ke sekitar 111.67
dengan confidence level 59%."
```

### Scene 3: Risk Analysis (2 menit)
```
[Screen: Browser]

"Sekarang kita coba analisis risiko.

Contract ID tetap 1.
Pilih 'Analisis Risiko'.
[Select model]

Input data untuk risk analysis:
[Type]
{
  "amount": 5000,
  "history_score": 75,
  "volatility": 0.3
}

Kali ini, kita centang 'Submit ke Blockchain'
agar hasil disimpan on-chain.
[Check checkbox]

Klik 'Request Prediksi'.
[Click]

Hasilnya:
Risk Score: 29
Risk Level: LOW
Confidence: 85%
Dan submitted to blockchain!

Karena risk score (29) lebih kecil dari threshold (7000),
kontrak tidak auto-execute. Tapi hasil sudah tersimpan
di blockchain secara immutable."
```

### Scene 4: Fraud Detection (1 menit)
```
[Screen: Browser]

"Terakhir, fraud detection.

Pilih 'Deteksi Fraud'.
Input data:
{
  "amount": 10000,
  "user_history": [1000, 1200, 1100],
  "speed": 5
}

Request prediksi.
[Click]

Fraud Score: 45
Status: SAFE

Transaksi aman, tidak terdeteksi fraud!"
```

---

## Video 3: Use Cases & Advanced (10 menit)

### Scene 1: Insurance Use Case (3 menit)
```
[Screen: Whiteboard/Slides]

"Mari kita lihat use case nyata: Asuransi Otomatis.

Scenario:
- User submit claim asuransi kesehatan
- AI analyze risk berdasarkan amount, history, medical records
- Jika risk score < 7000 → Auto approve
- Jika risk score > 7000 → Manual review

[Screen: Browser - Demo]

Buat kontrak:
Type: insurance
Threshold: 7000

Test Case 1: Low Risk
[Input data with low risk]
Result: Risk Score 25 → Auto Approved!

Test Case 2: High Risk
[Input data with high risk]
Result: Risk Score 85 → Manual Review Required

Dengan Smart Contract 2.0, proses approval
bisa otomatis dan transparan!"
```

### Scene 2: Trading Bot Use Case (3 menit)
```
[Screen: Trading chart animation]

"Use case kedua: Auto-Trading Bot.

Scenario:
- Bot monitor harga crypto/saham
- AI predict harga akan naik/turun
- Jika prediction > threshold → Auto buy
- Jika prediction < threshold → Hold/Sell

[Screen: Browser - Demo]

Buat kontrak:
Type: trading
Threshold: 120

Input historical prices:
[100, 105, 110, 115, 118]

AI Prediction: 122.5
Confidence: 65%

Karena 122.5 > 120 (threshold),
kontrak auto-execute BUY order!

[Show transaction on blockchain]

Semua tercatat di blockchain,
fully transparent dan auditable."
```

### Scene 3: Payment Verification (2 menit)
```
[Screen: Payment flow diagram]

"Use case ketiga: Payment Verification.

Scenario:
- User initiate payment
- AI check fraud probability
- Jika fraud score > 60 → Block
- Jika fraud score < 60 → Process

[Screen: Browser - Demo]

Kontrak:
Type: payment
Threshold: 60

Test suspicious transaction:
Amount: 50000 (unusual)
Speed: 15 tx/hour (too fast)

Result: Fraud Score 75
→ Transaction BLOCKED!

Sistem otomatis protect user dari fraud!"
```

### Scene 4: Advanced Features (2 menit)
```
[Screen: Browser + Terminal split]

"Beberapa advanced features:

1. Multiple Predictions
   Satu kontrak bisa punya banyak predictions
   [Show multiple requests]

2. Blockchain Verification
   Semua hasil bisa di-verify on-chain
   [Show hardhat console]

3. Custom Models
   Anda bisa customize AI models
   [Show ai-engine/main.py]

4. Event Monitoring
   Monitor semua events real-time
   [Show logs]

Untuk tutorial lebih detail,
check TUTORIAL.md di repository!"
```

---

## Video 4: Deploy to Production (5 menit)

### Scene 1: Deploy to Vercel (3 menit)
```
[Screen: Terminal]

"Sekarang mari kita deploy ke production.

Cara termudah adalah pakai Vercel.

Step 1: Install Vercel CLI
$ npm i -g vercel

Step 2: Login
$ vercel login
[Show browser login]

Step 3: Deploy
$ vercel --prod
[Show deployment process]

Tunggu beberapa detik...

Done! Aplikasi live di:
https://smart-contract-20.vercel.app

[Screen: Browser - open deployed app]

Semua fitur AI langsung berfungsi!
Tanpa perlu setup server!"
```

### Scene 2: Deploy to Testnet (2 menit)
```
[Screen: Terminal]

"Untuk full blockchain integration,
deploy smart contract ke testnet.

Step 1: Get Sepolia ETH
[Show faucet website]

Step 2: Update .env
SEPOLIA_RPC_URL=...
DEPLOYER_PRIVATE_KEY=...

Step 3: Deploy
$ npm run deploy:sepolia
[Show deployment]

Contract deployed!
Address: 0x...

Step 4: Update Vercel env vars
[Show Vercel dashboard]

Sekarang aplikasi fully integrated
dengan blockchain testnet!"
```

---

## Video 5: Troubleshooting & Tips (5 menit)

### Scene 1: Common Issues (3 menit)
```
[Screen: Browser with errors]

"Beberapa masalah yang sering terjadi:

1. 'Failed to fetch'
   Solusi: Hard refresh (Cmd+Shift+R)
   [Demo refresh]

2. 'Contract not active'
   Solusi: Create contract first
   [Show creating contract]

3. Services not running
   Solusi: Check test page
   [Open localhost:8080/test.html]
   [Show testing each service]

4. CORS errors
   Sudah fixed! Tapi jika terjadi:
   - Restart services
   - Clear browser cache
   [Demo]

Untuk troubleshooting lengkap,
check TROUBLESHOOTING.md"
```

### Scene 2: Pro Tips (2 menit)
```
[Screen: Tips overlay]

"Pro tips untuk Smart Contract 2.0:

1. Always hard refresh after restart
   [Show keyboard shortcut]

2. Use test page for diagnosis
   [Show test.html]

3. Check browser console for errors
   [Show F12 console]

4. Submit to blockchain for immutability
   [Show checkbox]

5. Combine multiple models for accuracy
   [Show example]

6. Monitor confidence scores
   90%+ = Very reliable
   70-89% = Reliable
   50-69% = Use with caution
   <50% = Need more data

7. Start with demo, then deploy to production
   [Show workflow]

Happy building! 🚀"
```

---

## Closing (30 detik)
```
[Screen: Summary slide]

"Terima kasih sudah menonton!

Anda sekarang sudah bisa:
✅ Setup Smart Contract 2.0
✅ Membuat kontrak adaptif
✅ Menggunakan 3 model AI
✅ Deploy ke production

Resources:
- Full tutorial: TUTORIAL.md
- Quick reference: QUICK_REFERENCE.md
- Documentation: DOCS_INDEX.md

Subscribe untuk tutorial lainnya!
Dan jangan lupa star repository di GitHub!

Sampai jumpa! 👋"
```

---

## 📝 Notes untuk Video Editor

- **Duration:** 5 videos, total ~32 menit
- **Style:** Casual, friendly, educational
- **Graphics:** Use animations untuk architecture & flow
- **Code:** Syntax highlighting untuk code snippets
- **Music:** Upbeat background music (low volume)
- **Captions:** Add Indonesian & English subtitles
- **Chapters:** Add YouTube chapters untuk easy navigation

## 🎬 Recording Checklist

- [ ] Clean desktop/browser
- [ ] Zoom in on important parts
- [ ] Slow down when typing
- [ ] Pause after each result
- [ ] Show success messages clearly
- [ ] Use cursor highlighting
- [ ] Record in 1080p minimum
- [ ] Test audio quality
- [ ] Prepare demo data beforehand
- [ ] Have backup plan if demo fails
