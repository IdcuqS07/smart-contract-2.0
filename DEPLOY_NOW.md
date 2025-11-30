# 🚀 DEPLOY NOW - Complete Guide

## 📋 Your VPS Information

```
IP Address: 143.198.205.88
Provider: DigitalOcean (assumed)
OS: Ubuntu 22.04 LTS (recommended)
```

---

## ⚡ Quick Deploy (2 Steps)

### Step 1: Deploy Backend ke VPS

```bash
# SSH ke VPS
ssh root@143.198.205.88

# Clone repository
git clone https://github.com/YOUR_USERNAME/smart-contract-2.0.git
cd smart-contract-2.0

# Run deployment script
chmod +x scripts/deploy-to-vps.sh
./scripts/deploy-to-vps.sh
```

**Waktu: ~15-20 menit**

### Step 2: Update & Deploy Frontend

```bash
# Di komputer lokal Anda
cd smart-contract-2.0

# Update frontend untuk connect ke VPS
chmod +x scripts/update-frontend-vps.sh
./scripts/update-frontend-vps.sh
```

**Waktu: ~2-3 menit**

---

## 🎯 Setelah Deploy

### Your Live URLs:

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

## ✅ Verification Checklist

### On VPS:
```bash
# Check services
pm2 status

# Check logs
pm2 logs

# Test endpoints
curl http://143.198.205.88/api/ai/health
curl http://143.198.205.88/api/oracle/health
curl http://143.198.205.88/graphql
```

### On Browser:
1. Open: https://smartcontract2-linera-eight.vercel.app/
2. Check status indicators (should show ✅ LIVE)
3. Try "Get Prediction" button
4. Try "Create Contract" button

---

## 📊 Architecture After Deployment

```
┌─────────────────────────────────────────────────┐
│                   Internet                       │
└────────────┬────────────────────────────────────┘
             │
    ┌────────┴────────┐
    │                 │
    ▼                 ▼
┌─────────┐      ┌──────────────────┐
│ Vercel  │      │  VPS (143...)    │
│Frontend │◄─────┤  - AI Engine     │
└─────────┘      │  - Oracle        │
                 │  - Linera        │
                 │  - GraphQL       │
                 └──────────────────┘
```

---

## 🔧 Useful Commands

### On VPS:

```bash
# Check service status
pm2 status

# View logs
pm2 logs
pm2 logs ai-engine
pm2 logs oracle-service

# Restart services
pm2 restart all
pm2 restart ai-engine

# Stop services
pm2 stop all

# Check Nginx
sudo systemctl status nginx
sudo nginx -t

# Check ports
sudo lsof -i :8080
sudo lsof -i :5000
sudo lsof -i :3000

# Monitor resources
htop
df -h
free -m
```

### On Local:

```bash
# Update frontend
./scripts/update-frontend-vps.sh

# Deploy to Vercel
cd frontend
vercel --prod

# Push to GitHub
git add .
git commit -m "Update"
git push
```

---

## 🚨 Troubleshooting

### Backend tidak jalan?

```bash
# SSH ke VPS
ssh root@143.198.205.88

# Check logs
pm2 logs

# Restart services
pm2 restart all

# Check if ports are in use
sudo lsof -i :8080
sudo lsof -i :5000
sudo lsof -i :3000
```

### Frontend tidak connect?

1. Check VPS backend is running: `pm2 status`
2. Test endpoints manually: `curl http://143.198.205.88/api/ai/health`
3. Check browser console for errors
4. Verify CORS settings in Nginx

### Out of Memory?

```bash
# Add swap space
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 📚 Documentation Files

- **DEPLOY_TO_MY_VPS.md** - Specific instructions for your VPS
- **VPS_DEPLOYMENT_GUIDE.md** - Complete deployment guide
- **VPS_QUICK_START.md** - Quick reference
- **scripts/deploy-to-vps.sh** - Automated deployment script
- **scripts/update-frontend-vps.sh** - Frontend update script

---

## 🎉 Success Indicators

Your application is fully live when:

- ✅ VPS services showing "online" in `pm2 status`
- ✅ All health endpoints returning 200 OK
- ✅ Frontend showing "✅ LIVE" for all services
- ✅ Can get AI predictions from frontend
- ✅ Can create contracts from frontend
- ✅ GraphQL endpoint accessible

---

## 💡 Pro Tips

1. **Setup Domain**: Point your domain to 143.198.205.88
2. **Enable SSL**: Use Let's Encrypt for HTTPS
3. **Monitor**: Setup monitoring with PM2 Plus or UptimeRobot
4. **Backup**: Regular backups of VPS data
5. **Security**: Keep system updated, use firewall

---

## 🆘 Need Help?

Check these files:
- TROUBLESHOOTING.md
- VPS_DEPLOYMENT_GUIDE.md
- DEPLOY_TO_MY_VPS.md

Or check logs:
```bash
pm2 logs
sudo journalctl -u nginx
```

---

## 🚀 Ready to Deploy?

1. **Backend**: SSH to VPS and run `./scripts/deploy-to-vps.sh`
2. **Frontend**: Run `./scripts/update-frontend-vps.sh`
3. **Verify**: Check all endpoints and test functionality
4. **Celebrate**: Your app is fully live! 🎉

---

**Let's make it live!** 🚀
