# 🚀 Quick Deploy ke Vercel

## Langkah Cepat (5 Menit)

### 1️⃣ Install Vercel CLI
```bash
npm i -g vercel
```

### 2️⃣ Login ke Vercel
```bash
vercel login
```

### 3️⃣ Deploy!
```bash
vercel --prod
```

### 4️⃣ Set Environment Variables

Di Vercel Dashboard, tambahkan:
- `RPC_URL` → https://sepolia.infura.io/v3/YOUR_KEY
- `CONTRACT_ADDRESS` → (deploy contract dulu ke Sepolia)
- `ORACLE_PRIVATE_KEY` → (private key oracle)

## 📝 Catatan

**Untuk production**, Anda perlu:
1. Deploy smart contract ke **Sepolia testnet** (bukan localhost)
2. Dapatkan **Infura/Alchemy API key** untuk RPC
3. Set environment variables di Vercel

**Untuk demo tanpa blockchain:**
- Langsung deploy saja
- AI Engine akan tetap berfungsi
- Blockchain submission akan skip (demo mode)

## 📚 Dokumentasi Lengkap

Lihat **VERCEL_DEPLOYMENT.md** untuk panduan detail.

## ✅ Hasil

Setelah deploy, aplikasi akan live di:
```
https://your-app.vercel.app
```

Semua fitur AI akan langsung berfungsi! 🎉
