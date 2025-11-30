# 🚀 START HERE - Deploy Smart Contract 2.0 ke VPS

## 📍 Informasi VPS Anda

```
IP Address: 143.198.205.88
Status: Ready to Deploy
```

---

## ⚡ 2 Langkah Deploy

### Langkah 1: Deploy Backend ke VPS (15-20 menit)

```bash
# 1. SSH ke VPS Anda
ssh root@143.198.205.88

# 2. Clone repository
git clone https://github.com/IdcuqS07/smart-contract-2.0.git
cd smart-contract-2.0

# 3. Jalankan script deployment
chmod +x scripts/deploy-to-vps.sh
./scripts/deploy-to-vps.sh
```

Script akan otomatis:
- ✅ Install semua dependencies (Rust, Node.js, Python)
- ✅ Install Linera SDK
- ✅ Setup AI Engine
- ✅ Setup Oracle Service
- ✅ Deploy smart contract
- ✅ Configure Nginx
- ✅ Start semua services dengan PM2

### Langkah 2: Update Frontend (2-3 menit)

```bash
# Di komputer lokal Anda
cd smart-contract-2.0

# Jalankan script update frontend
chmod +x scripts/update-frontend-vps.sh
./scripts/update-frontend-vps.sh
```

Script akan otomatis:
- ✅ Update config untuk connect ke VPS
- ✅ Commit changes ke Git
- ✅ Deploy ke Vercel

---

## 🎯 Setelah Deploy

### URL Aplikasi Anda:

**Frontend (Vercel):**
```
https://smartcontract2-linera-eight.vercel.app/
```

**Backend (VPS):**
```
AI Engine:      http://143.198.205.88/api/ai
Oracle Service: http://143.198.205.88/api/oracle
GraphQL:        http://143.198.205.88/graphql
WebSocket:      ws://143.198.205.88/ws
```

---

## ✅ Verifikasi

### Di VPS:
```bash
# Check status services
pm2 status

# Test endpoints
curl http://143.198.205.88/api/ai/health
curl http://143.198.205.88/api/oracle/health
```

### Di Browser:
1. Buka: https://smartcontract2-linera-eight.vercel.app/
2. Lihat status indicators (harus ✅ LIVE semua)
3. Test "Get Prediction" button
4. Test "Create Contract" button

---

## 📚 Dokumentasi Lengkap

Jika butuh detail lebih:

1. **DEPLOY_NOW.md** - Panduan lengkap deploy
2. **DEPLOYMENT_CHECKLIST_VPS.md** - Checklist step-by-step
3. **VPS_DEPLOYMENT_GUIDE.md** - Technical guide detail
4. **VPS_QUICK_START.md** - Quick reference
5. **DEPLOY_TO_MY_VPS.md** - Instruksi spesifik VPS Anda

---

## 🚨 Troubleshooting

### Service tidak jalan?
```bash
pm2 logs
pm2 restart all
```

### Frontend tidak connect?
```bash
# Check VPS backend
ssh root@143.198.205.88
pm2 status
```

### Butuh bantuan?
Lihat file **TROUBLESHOOTING.md**

---

## 💡 Yang Akan Anda Dapatkan

### Sebelum Deploy:
- ❌ Backend hanya di localhost
- ❌ Tidak accessible dari internet
- ❌ Demo mode saja

### Setelah Deploy:
- ✅ Backend live di VPS 24/7
- ✅ Accessible dari mana saja
- ✅ Real AI predictions
- ✅ Real blockchain transactions
- ✅ Production ready!

---

## 🎉 Siap Deploy?

**Langkah 1:** SSH ke VPS dan jalankan `./scripts/deploy-to-vps.sh`  
**Langkah 2:** Di local, jalankan `./scripts/update-frontend-vps.sh`  
**Langkah 3:** Test dan celebrate! 🎊

---

**Total waktu: ~25-30 menit**  
**Biaya: ~$6/bulan (VPS)**  
**Hasil: Aplikasi fully live!** 🚀

---

*Semua file sudah di-push ke GitHub*  
*Repository: https://github.com/IdcuqS07/smart-contract-2.0*
