# 🚀 VPS Quick Start - 15 Menit Deploy!

## 🎯 Cara Tercepat Deploy ke VPS

### Option 1: Automated Script (Recommended)

```bash
# 1. SSH ke VPS
ssh root@YOUR_VPS_IP

# 2. Create user (jika belum ada)
adduser smartcontract
usermod -aG sudo smartcontract
su - smartcontract

# 3. Clone repository
git clone https://github.com/YOUR_USERNAME/smart-contract-2.0.git
cd smart-contract-2.0

# 4. Run deployment script
chmod +x scripts/deploy-to-vps.sh
./scripts/deploy-to-vps.sh

# 5. Done! ✅
```

**Total waktu: ~15-20 menit** (tergantung kecepatan internet VPS)

---

### Option 2: Manual Step-by-Step

Jika ingin kontrol lebih atau script gagal:

```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install dependencies
sudo apt install -y git build-essential pkg-config libssl-dev protobuf-compiler curl

# 3. Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup target add wasm32-unknown-unknown

# 4. Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# 5. Install Python
sudo apt install -y python3 python3-pip python3-venv

# 6. Install PM2 & Nginx
sudo npm install -g pm2
sudo apt install -y nginx

# 7. Install Linera
cargo install linera-service --git https://github.com/linera-io/linera-protocol.git --tag v0.15.6

# 8. Clone & setup project
git clone https://github.com/YOUR_USERNAME/smart-contract-2.0.git
cd smart-contract-2.0

# 9. Setup AI Engine
cd ai-engine
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
cd ..

# 10. Setup Oracle Service
cd oracle-service
npm install
cd ..

# 11. Deploy Linera
linera net up
cd smart-contract-2-simple
cargo build --release --target wasm32-unknown-unknown
linera project publish-and-create --json-argument 0
nohup linera service --port 8080 > ../logs/linera.log 2>&1 &
cd ..

# 12. Start services with PM2
pm2 start ecosystem.config.js
pm2 save
pm2 startup

# 13. Configure Nginx (see VPS_DEPLOYMENT_GUIDE.md)
```

---

## 💰 Pilih VPS Provider

### Rekomendasi Berdasarkan Budget:

#### 1. **Budget Minimal ($5-6/month)**
- **Contabo VPS S** - €4.99/month
  - 4 vCPU, 6GB RAM, 200GB SSD
  - Best value for money!
  - Link: https://contabo.com

#### 2. **Mudah & Reliable ($6/month)**
- **DigitalOcean Basic Droplet** - $6/month
  - 1 vCPU, 1GB RAM, 25GB SSD
  - $200 credit untuk new user
  - Link: https://www.digitalocean.com

#### 3. **VPS Indonesia (Rp 20k-50k/month)**
- **IDCloudHost** - Mulai Rp 20.000/month
- **Niagahoster** - Mulai Rp 30.000/month
- **Dewaweb** - Mulai Rp 50.000/month

---

## 📋 Checklist Sebelum Deploy

- [ ] Punya akun VPS provider
- [ ] VPS sudah dibuat (Ubuntu 22.04 LTS)
- [ ] Punya SSH access ke VPS
- [ ] Repository sudah di GitHub
- [ ] Punya 15-20 menit waktu

---

## 🎯 Setelah Deploy

### 1. Cek Status Services
```bash
pm2 status
```

### 2. Test Endpoints
```bash
# Get VPS IP
curl ifconfig.me

# Test AI Engine
curl http://YOUR_VPS_IP/api/ai/health

# Test Oracle Service
curl http://YOUR_VPS_IP/api/oracle/health

# Test GraphQL
curl http://YOUR_VPS_IP/graphql
```

### 3. Update Frontend Config

Edit `frontend/config.js`:
```javascript
const API_CONFIG = {
  AI_ENGINE: 'http://YOUR_VPS_IP/api/ai',
  ORACLE_SERVICE: 'http://YOUR_VPS_IP/api/oracle',
  GRAPHQL_ENDPOINT: 'http://YOUR_VPS_IP/graphql',
  WS_ENDPOINT: 'ws://YOUR_VPS_IP/ws'
};
```

Deploy ulang ke Vercel:
```bash
cd frontend
vercel --prod
```

---

## 🔍 Troubleshooting

### Service tidak jalan?
```bash
pm2 logs
pm2 restart all
```

### Port sudah dipakai?
```bash
sudo lsof -i :8080
sudo kill -9 <PID>
```

### Nginx error?
```bash
sudo nginx -t
sudo systemctl status nginx
sudo systemctl restart nginx
```

### Out of memory?
```bash
# Add swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

---

## 🎉 Setelah Berhasil

Aplikasi Anda sekarang:
- ✅ **Fully Live** - Accessible 24/7
- ✅ **Real Backend** - Bukan demo lagi
- ✅ **Public API** - Bisa diakses dari mana saja
- ✅ **Production Ready** - Siap digunakan

---

## 📚 Resources

- **Full Guide:** VPS_DEPLOYMENT_GUIDE.md
- **Deployment Script:** scripts/deploy-to-vps.sh
- **Monitoring:** `pm2 monit`
- **Logs:** `pm2 logs`

---

## 💡 Tips

1. **Gunakan Contabo** jika budget minimal (best value)
2. **Gunakan DigitalOcean** jika mau mudah dan reliable
3. **Setup domain** untuk URL yang lebih professional
4. **Install SSL** dengan Let's Encrypt (gratis)
5. **Monitor resources** dengan `htop` dan `pm2 monit`

---

**Ready? Pilih VPS provider dan mulai deploy!** 🚀
