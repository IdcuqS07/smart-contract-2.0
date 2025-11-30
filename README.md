# Smart Contract 2.0 - AI-Enhanced Blockchain Contracts

Implementasi Smart Contract 2.0 yang mengintegrasikan AI dengan blockchain untuk kontrak yang adaptif dan kontekstual, berdasarkan paper "Smart Contract 2.0 — Arsitektur & Desain Teknis untuk Kontrak Benar-Benar Cerdas" oleh Idcuq Sant.

## 🎯 Fitur Utama

- ✅ **3 Model AI**: Price Prediction, Risk Analysis, Fraud Detection
- ✅ **Hybrid Architecture**: On-chain contracts + Off-chain AI
- ✅ **Oracle Integration**: Bridge antara AI dan blockchain
- ✅ **Adaptive Contracts**: Auto-execution berdasarkan AI predictions
- ✅ **Web Interface**: User-friendly dashboard

## 🚀 Quick Start

### 🌐 Deploy ke Vercel (Recommended - 2 menit)

```bash
npm i -g vercel
vercel --prod
```

✅ Gratis, cepat, dan langsung live di internet!

📖 **Panduan:** [README_VERCEL.md](README_VERCEL.md) | [DEPLOY_CHECKLIST.md](DEPLOY_CHECKLIST.md)

### 💻 Local Development

```bash
# 1. Install & compile
npm install && npm run compile

# 2. Start services (4 terminals)
npm run node                           # Terminal 1: Blockchain
npm run deploy                         # Terminal 2: Deploy contracts
./venv/bin/python ai-engine/main.py   # Terminal 3: AI Engine
node oracle-service/server.js          # Terminal 4: Oracle

# 3. Open browser
open http://localhost:8080
```

📖 **Panduan:** [QUICK_START.md](QUICK_START.md)

### 📋 Pilihan Deployment Lainnya

Lihat [DEPLOYMENT_OPTIONS.md](DEPLOYMENT_OPTIONS.md) untuk:
- Deploy ke VPS/Cloud
- Production setup
- Perbandingan biaya & fitur

## 📁 Struktur Proyek

```
smart-contract-2.0/
├── contracts/              # Smart contracts (Solidity)
│   ├── SmartContract2.sol
│   └── IntelligentLayer.sol
├── ai-engine/             # AI models (Python)
│   └── main.py
├── oracle-service/        # Oracle bridge (Node.js)
│   └── server.js
├── api/                   # Vercel serverless functions
│   ├── oracle.js
│   └── ai-predict.js
├── frontend/              # Web interface
│   └── index.html
└── scripts/               # Deployment scripts
```

## 🏗️ Arsitektur

```
User → Frontend → Oracle Service → AI Engine
                       ↓
                Smart Contract (Blockchain)
```

**On-Chain**: Smart contracts, immutable logic, event emission
**Off-Chain**: AI processing, data analysis, predictions

## 🛠️ Teknologi

### Blockchain
- **Ethereum**: Solidity, Hardhat, Ethers.js
- **Linera**: Rust, GraphQL, WebAssembly ⚡ NEW!

### AI & Backend
- **AI Engine**: Python, Flask, NumPy
- **Oracle**: Node.js, Express, GraphQL

### Frontend & Deployment
- **Frontend**: HTML, CSS, JavaScript
- **Deployment**: Vercel (Serverless)

## 📚 Dokumentasi

📖 **[DOCS_INDEX.md](DOCS_INDEX.md)** - Index lengkap semua dokumentasi

**🔗 Linera Integration (NEW!):**
- **[LINERA_INTEGRATION.md](LINERA_INTEGRATION.md)** ⚡ - Linera integration guide
- **[linera-integration/README.md](linera-integration/README.md)** - Technical docs

**Tutorial & Learning:**
- **[TUTORIAL.md](TUTORIAL.md)** ⭐ - Tutorial lengkap step-by-step
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Cheat sheet & quick reference
- **[VIDEO_TUTORIAL_SCRIPT.md](VIDEO_TUTORIAL_SCRIPT.md)** - Script untuk video tutorial

**Quick Links:**
- **[VERCEL_READY.md](VERCEL_READY.md)** - Siap deploy ke Vercel!
- **[QUICK_START.md](QUICK_START.md)** - Local development
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture
- **[DEPLOYMENT_OPTIONS.md](DEPLOYMENT_OPTIONS.md)** - Compare deployment options

## 🧪 Testing

```bash
# Run unit tests
npm test

# Test AI Engine
curl http://localhost:5001/health

# Test Oracle
curl http://localhost:3002/health
```

## 🌐 Live Demo

Setelah deploy ke Vercel, aplikasi akan tersedia di:
```
https://your-app.vercel.app
```

## 📄 License

MIT

## 👤 Author

Idcuq Sant - Smart Contract 2.0 Concept & Implementation
