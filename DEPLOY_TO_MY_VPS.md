# 🚀 Deploy ke VPS: 143.198.205.88

## 📋 Quick Deploy Instructions

### Step 1: SSH ke VPS Anda

```bash
ssh root@143.198.205.88
```

### Step 2: Create User (jika belum ada)

```bash
# Create user
adduser smartcontract
# Set password when prompted

# Add to sudo group
usermod -aG sudo smartcontract

# Switch to new user
su - smartcontract
```

### Step 3: Clone Repository

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/smart-contract-2.0.git
cd smart-contract-2.0
```

### Step 4: Run Deployment Script

```bash
chmod +x scripts/deploy-to-vps.sh
./scripts/deploy-to-vps.sh
```

**Waktu deploy: ~15-20 menit**

---

## 🌐 Setelah Deploy Selesai

### Your Endpoints:

```
AI Engine:      http://143.198.205.88/api/ai
Oracle Service: http://143.198.205.88/api/oracle
GraphQL:        http://143.198.205.88/graphql
WebSocket:      ws://143.198.205.88/ws
```

---

## 🔍 Verify Deployment

### 1. Check Services Status
```bash
pm2 status
```

### 2. Test Endpoints
```bash
# Test AI Engine
curl http://143.198.205.88/api/ai/health

# Test Oracle Service
curl http://143.198.205.88/api/oracle/health

# Test GraphQL
curl http://143.198.205.88/graphql
```

### 3. Check Logs
```bash
pm2 logs
```

---

## 📝 Update Frontend

Setelah backend live di VPS, update frontend config dan deploy ulang ke Vercel.

File sudah disiapkan di: `frontend/config-vps.js`

---

## 🎯 Next Steps

1. ✅ Deploy backend ke VPS (143.198.205.88)
2. ✅ Verify all services running
3. ✅ Update frontend config
4. ✅ Deploy frontend ke Vercel
5. ✅ Test full integration
6. 🎉 Application fully live!

---

## 🚨 Troubleshooting

### If services not starting:
```bash
pm2 logs
pm2 restart all
```

### If port already in use:
```bash
sudo lsof -i :8080
sudo kill -9 <PID>
```

### Check Nginx:
```bash
sudo nginx -t
sudo systemctl status nginx
sudo systemctl restart nginx
```

---

## 📞 Support

Jika ada masalah, check:
- VPS_DEPLOYMENT_GUIDE.md - Full guide
- VPS_QUICK_START.md - Quick reference
- TROUBLESHOOTING.md - Common issues

---

**Ready to deploy? SSH ke VPS dan jalankan script!** 🚀
