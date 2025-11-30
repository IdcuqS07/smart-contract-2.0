# Smart Contract 2.0 - AI-Enhanced Smart Contracts on Linera

Implementasi Smart Contract 2.0 yang mengintegrasikan AI dengan Linera blockchain untuk kontrak yang adaptif, cerdas, dan ultra-cepat, berdasarkan paper "Smart Contract 2.0 — Arsitektur & Desain Teknis untuk Kontrak Benar-Benar Cerdas" oleh Idcuq Sant.

## 🌐 Live Demo

**Demo URL:** https://smartcontract2-linera-xor3ogqe9-idcuq-santosos-projects.vercel.app

**Current Status:**
- ✅ **AI Engine:** Fully functional with 3 ML models
- ✅ **Oracle Service:** Ready for blockchain integration  
- ✅ **Frontend:** Complete UI/UX with beautiful interface
- ✅ **Smart Contract:** Complete Rust code ready for deployment
- ⏳ **Blockchain:** Ready to deploy to Linera Testnet Conway

**What's Working:**
- Real AI predictions (Price Prediction, Risk Analysis, Fraud Detection)
- Beautiful responsive user interface
- Complete workflow demonstration
- API endpoints functional
- Local testing successful

**What's Next:**
- Deploy contract to Linera Testnet Conway (when CLI available)
- Connect frontend to real blockchain
- Full end-to-end integration on testnet

## 🎯 Fitur Utama

- ⚡ **Ultra-Low Latency**: Sub-second finality dengan Linera (<1s)
- 🤖 **3 Model AI**: Price Prediction, Risk Analysis, Fraud Detection
- 🚀 **High Scalability**: 1000+ TPS dengan microchains
- 💰 **Cost Efficient**: 96% lebih murah dari blockchain tradisional
- 🔄 **Real-Time Events**: GraphQL queries & WebSocket subscriptions
- 📚 **Complete Documentation**: Tutorial lengkap dan examples

## 🚀 Quick Start

### 💻 Local Development with Linera

```bash
# 1. Install Rust & Linera
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown
cargo install linera-service --git https://github.com/linera-io/linera-protocol.git

# 2. Build & Deploy
cd linera-integration
./scripts/deploy.sh

# 3. Start services (3 terminals)
linera service --port 8080             # Terminal 1: Linera node
./venv/bin/python ai-engine/main.py   # Terminal 2: AI Engine
cd oracle-client && node test.js       # Terminal 3: Test

# 4. Open browser
open http://localhost:8080/graphql
```

📖 **Panduan:** [LINERA_INTEGRATION.md](LINERA_INTEGRATION.md)

### 🌐 Deploy ke Vercel (Frontend & API)

```bash
npm i -g vercel
vercel --prod
```

� **Panduan:** [VERCEL_READY.md](VERCEL_READY.md)

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
- **Linera**: Rust, GraphQL, WebAssembly ⚡
- **Smart Contracts**: Rust dengan Linera SDK
- **Microchains**: Isolated execution per contract

### AI & Backend
- **AI Engine**: Python, Flask, NumPy
- **Oracle**: Node.js, GraphQL Client
- **Real-Time**: WebSocket subscriptions

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
