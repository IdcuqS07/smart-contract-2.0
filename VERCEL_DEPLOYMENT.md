# 🚀 Deploy Smart Contract 2.0 ke Vercel

## ⚠️ Catatan Penting

Smart Contract 2.0 memiliki arsitektur hybrid:
- ✅ **Frontend, AI Engine, Oracle** → Bisa di Vercel
- ❌ **Blockchain Node** → Harus pakai testnet publik (Sepolia, Mumbai, dll)

## 📋 Persiapan

### 1. Deploy Smart Contract ke Testnet

Pilih salah satu testnet:
- **Ethereum Sepolia** (recommended)
- **Polygon Mumbai**
- **BSC Testnet**

#### Deploy ke Sepolia:

```bash
# 1. Update hardhat.config.js
# Tambahkan network sepolia

# 2. Dapatkan Sepolia ETH dari faucet:
# https://sepoliafaucet.com/

# 3. Deploy
npx hardhat run scripts/deploy.js --network sepolia
```

Catat **CONTRACT_ADDRESS** dan **ORACLE_ADDRESS** yang muncul.

### 2. Setup Vercel Project

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Link project
vercel link
```

### 3. Set Environment Variables di Vercel

Di Vercel Dashboard → Settings → Environment Variables, tambahkan:

```
RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
CONTRACT_ADDRESS=0x... (dari deployment)
ORACLE_PRIVATE_KEY=0x... (private key oracle)
```

**Cara dapat RPC_URL:**
1. Buat akun di [Infura.io](https://infura.io) atau [Alchemy.com](https://alchemy.com)
2. Buat project baru
3. Copy endpoint URL untuk Sepolia

## 🚀 Deploy ke Vercel

### Option 1: Via CLI

```bash
vercel --prod
```

### Option 2: Via GitHub

1. Push code ke GitHub:
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/username/smart-contract-2.0.git
git push -u origin main
```

2. Import di Vercel:
   - Buka [vercel.com](https://vercel.com)
   - Click "Import Project"
   - Pilih repository GitHub
   - Set environment variables
   - Deploy!

## 📁 Struktur File untuk Vercel

```
smart-contract-2.0/
├── api/
│   ├── oracle.js          # Oracle serverless function
│   └── ai-predict.js      # AI Engine serverless function
├── frontend/
│   └── index-vercel.html  # Frontend (rename ke index.html)
├── vercel.json            # Vercel configuration
└── package.json           # Dependencies
```

## 🔧 Update Frontend untuk Production

Rename file:
```bash
mv frontend/index-vercel.html frontend/index.html
```

Frontend akan otomatis detect API URL dari `window.location.origin`.

## ✅ Testing Deployment

Setelah deploy, test endpoints:

```bash
# Test AI Engine
curl https://your-app.vercel.app/api/ai/health

# Test Oracle
curl https://your-app.vercel.app/api/oracle/health

# Test Prediction
curl -X POST https://your-app.vercel.app/api/ai/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type":"price_prediction","data":{"prices":[100,105,110]}}'
```

## 🎯 Workflow Lengkap

1. **Deploy Smart Contract** ke Sepolia testnet
2. **Set Environment Variables** di Vercel
3. **Deploy ke Vercel** via CLI atau GitHub
4. **Test** semua endpoints
5. **Buka** https://your-app.vercel.app

## 💡 Tips

### Free Tier Limits:
- Vercel Free: 100GB bandwidth/month
- Infura Free: 100k requests/day
- Alchemy Free: 300M compute units/month

### Optimasi:
- Cache AI predictions untuk mengurangi compute
- Implement rate limiting
- Use Vercel Edge Functions untuk latency rendah

### Security:
- **JANGAN** commit private key ke Git
- Gunakan Vercel Environment Variables
- Enable CORS hanya untuk domain Anda

## 🐛 Troubleshooting

**Error: "Module not found"**
```bash
# Pastikan package.json memiliki "type": "module"
# Dan gunakan import/export syntax
```

**Error: "Function timeout"**
```bash
# Vercel free tier: 10s timeout
# Upgrade ke Pro untuk 60s timeout
```

**Blockchain connection failed**
```bash
# Verify RPC_URL valid
# Check Infura/Alchemy quota
# Pastikan network benar (sepolia, not localhost)
```

## 📚 Resources

- [Vercel Docs](https://vercel.com/docs)
- [Sepolia Faucet](https://sepoliafaucet.com/)
- [Infura](https://infura.io)
- [Alchemy](https://alchemy.com)

## 🎉 Done!

Aplikasi Smart Contract 2.0 Anda sekarang live di internet! 🌐
