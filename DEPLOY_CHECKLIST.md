# ✅ Deployment Checklist

## 🎯 Deploy ke Vercel - Langkah demi Langkah

### ☑️ Persiapan (5 menit)

- [ ] Install Vercel CLI: `npm i -g vercel`
- [ ] Login Vercel: `vercel login`
- [ ] Buat akun Infura/Alchemy (untuk RPC)

### ☑️ Deploy Smart Contract ke Testnet (10 menit)

**Option A: Sepolia (Ethereum Testnet)**
- [ ] Dapatkan Sepolia ETH: https://sepoliafaucet.com/
- [ ] Update `.env`: `SEPOLIA_RPC_URL` dan `DEPLOYER_PRIVATE_KEY`
- [ ] Deploy: `npm run deploy:sepolia`
- [ ] Catat `CONTRACT_ADDRESS` yang muncul

**Option B: Skip (Demo Mode)**
- [ ] Langsung deploy ke Vercel
- [ ] AI akan tetap berfungsi
- [ ] Blockchain submission akan di-skip

### ☑️ Deploy ke Vercel (2 menit)

```bash
vercel --prod
```

### ☑️ Set Environment Variables di Vercel

Di Vercel Dashboard → Settings → Environment Variables:

**Untuk Production dengan Blockchain:**
- [ ] `RPC_URL` = `https://sepolia.infura.io/v3/YOUR_KEY`
- [ ] `CONTRACT_ADDRESS` = `0x...` (dari deployment)
- [ ] `ORACLE_PRIVATE_KEY` = `0x...` (private key)

**Untuk Demo Mode:**
- [ ] Skip semua environment variables
- [ ] AI tetap berfungsi tanpa blockchain

### ☑️ Testing (2 menit)

- [ ] Buka `https://your-app.vercel.app`
- [ ] Test AI Prediction (Price, Risk, Fraud)
- [ ] Verify hasil muncul dengan confidence score
- [ ] (Optional) Test blockchain submission

### ☑️ Done! 🎉

Aplikasi Smart Contract 2.0 sudah live!

---

## 🚨 Troubleshooting

**"Module not found"**
→ Pastikan `package.json` memiliki `"type": "module"`

**"Function timeout"**
→ Vercel free tier: 10s timeout (cukup untuk AI predictions)

**"Blockchain connection failed"**
→ Verify RPC_URL dan CONTRACT_ADDRESS di environment variables

**"CORS error"**
→ Sudah di-handle di API functions, refresh browser

---

## 💡 Tips

- **Free Tier**: Vercel Free + Infura Free = Cukup untuk demo & testing
- **Demo Mode**: Deploy tanpa blockchain tetap berfungsi untuk AI
- **Production**: Gunakan Sepolia testnet (gratis) untuk full features
- **Monitoring**: Check Vercel Dashboard untuk logs & analytics

---

## 📞 Support

Jika ada masalah, check:
1. Vercel deployment logs
2. Browser console (F12)
3. API endpoint: `/api/ai/health` dan `/api/oracle/health`
