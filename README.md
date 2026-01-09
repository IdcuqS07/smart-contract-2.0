# Smart Contract 2.0 - AI-Enhanced Smart Contracts on Aleo

Implementasi Smart Contract 2.0 yang mengintegrasikan AI dengan Aleo blockchain untuk kontrak yang adaptif, cerdas, dan privacy-preserving, berdasarkan paper "Smart Contract 2.0 — Arsitektur & Desain Teknis untuk Kontrak Benar-Benar Cerdas" oleh Idcuq Sant.

## 🌐 Live Demo

**Demo URL:** https://smartcontract2-aleo.vercel.app

**Current Status:**
- ✅ **AI Engine:** Fully functional with 3 ML models
- ✅ **Oracle Service:** Ready for Aleo integration  
- ✅ **Frontend:** Complete UI/UX with beautiful interface
- ✅ **Smart Contract:** Complete Leo code ready for deployment
- 🚀 **Blockchain:** Ready to deploy to Aleo Testnet

**What's Working:**
- Real AI predictions (Price Prediction, Risk Analysis, Fraud Detection)
- Beautiful responsive user interface
- Complete workflow demonstration
- API endpoints functional
- Zero-knowledge privacy features

**What's Next:**
- Deploy contract to Aleo Testnet
- Connect frontend to Aleo blockchain
- Full end-to-end integration with privacy

## 🎯 Fitur Utama

- 🔐 **Zero-Knowledge Privacy**: Private AI predictions dengan ZK proofs
- 🤖 **3 Model AI**: Price Prediction, Risk Analysis, Fraud Detection
- ⚡ **Fast Execution**: Sub-second finality dengan Aleo
- 💰 **Cost Efficient**: Low fees dengan efficient ZK circuits
- 🛡️ **Privacy-First**: Semua data dan komputasi private
- 📚 **Complete Documentation**: Tutorial lengkap dan examples

## 🚀 Quick Start

### 💻 Local Development with Aleo

```bash
# 1. Install Leo CLI
curl -L https://raw.githubusercontent.com/AleoHQ/leo/testnet3/install.sh | bash

# 2. Build & Deploy
cd aleo-integration
leo build
./deploy.sh

# 3. Start services (2 terminals)
./venv/bin/python ai-engine/main.py   # Terminal 1: AI Engine
node oracle-service.js                 # Terminal 2: Oracle Service

# 4. Test contract
./test.sh
```

📖 **Panduan:** [aleo-integration/README.md](aleo-integration/README.md)

### 🌐 Deploy ke Vercel (Frontend & API)

```bash
npm i -g vercel
vercel --prod
```

� **Panduan:** [VERCEL_READY.md](VERCEL_READY.md)

## 📁 Struktur Proyek

```
smart-contract-2.0/
├── aleo-integration/      # Aleo smart contracts (Leo)
│   ├── src/main.leo
│   ├── oracle-service.js
│   └── deploy.sh
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
- **Aleo**: Leo, Zero-Knowledge Proofs ⚡
- **Smart Contracts**: Leo programming language
- **Privacy**: Zero-knowledge execution

### AI & Backend
- **AI Engine**: Python, Flask, NumPy
- **Oracle**: Node.js, GraphQL Client
- **Real-Time**: WebSocket subscriptions

### Frontend & Deployment
- **Frontend**: HTML, CSS, JavaScript
- **Deployment**: Vercel (Serverless)

## 📚 Dokumentasi

📖 **[DOCS_INDEX.md](DOCS_INDEX.md)** - Index lengkap semua dokumentasi

**🔗 Aleo Integration (NEW!):**
- **[aleo-integration/README.md](aleo-integration/README.md)** ⚡ - Aleo integration guide
- **[aleo-integration/deploy.sh](aleo-integration/deploy.sh)** - Deployment script

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
