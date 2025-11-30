# 🚀 VPS Deployment Guide - Smart Contract 2.0

## 📋 Overview

Deploy Smart Contract 2.0 ke VPS untuk membuat aplikasi **fully live** dan accessible dari internet.

---

## 🎯 Keuntungan Menggunakan VPS

✅ **Full Control** - Kontrol penuh atas server  
✅ **Always Online** - 24/7 uptime  
✅ **Public Access** - Accessible dari internet  
✅ **Cost Effective** - Lebih murah dari cloud managed services  
✅ **Scalable** - Bisa upgrade resources kapan saja  
✅ **Custom Domain** - Bisa pakai domain sendiri  

---

## 💰 Rekomendasi VPS Provider

### 1. **DigitalOcean** (Recommended)
- **Harga:** $6/bulan (Basic Droplet)
- **Specs:** 1 vCPU, 1GB RAM, 25GB SSD
- **Bonus:** $200 credit untuk new user
- **Link:** https://www.digitalocean.com

### 2. **Vultr**
- **Harga:** $6/bulan
- **Specs:** 1 vCPU, 1GB RAM, 25GB SSD
- **Bonus:** $100 credit
- **Link:** https://www.vultr.com

### 3. **Linode (Akamai)**
- **Harga:** $5/bulan
- **Specs:** 1 vCPU, 1GB RAM, 25GB SSD
- **Bonus:** $100 credit
- **Link:** https://www.linode.com

### 4. **Contabo** (Cheapest)
- **Harga:** €4.99/bulan (~$5.50)
- **Specs:** 4 vCPU, 6GB RAM, 200GB SSD
- **Best Value:** Paling murah dengan specs tinggi
- **Link:** https://contabo.com

### 5. **VPS Indonesia**
- **IDCloudHost:** Mulai Rp 20.000/bulan
- **Niagahoster:** Mulai Rp 30.000/bulan
- **Dewaweb:** Mulai Rp 50.000/bulan

---

## 📊 Minimum Requirements

```
OS: Ubuntu 22.04 LTS
CPU: 2 vCPU (minimum 1 vCPU)
RAM: 2GB (minimum 1GB)
Storage: 20GB SSD
Bandwidth: 1TB/month
```

---

## 🔧 Step-by-Step Deployment

### Step 1: Setup VPS

#### 1.1 Create VPS Instance
```bash
# Pilih:
- OS: Ubuntu 22.04 LTS
- Region: Singapore/US (terdekat dengan target user)
- Size: $6/month (1GB RAM, 1 vCPU)
```

#### 1.2 SSH ke VPS
```bash
ssh root@YOUR_VPS_IP
```

#### 1.3 Update System
```bash
apt update && apt upgrade -y
```

#### 1.4 Create Non-Root User
```bash
adduser smartcontract
usermod -aG sudo smartcontract
su - smartcontract
```

---

### Step 2: Install Dependencies

#### 2.1 Install Rust
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup target add wasm32-unknown-unknown
```

#### 2.2 Install Node.js
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

#### 2.3 Install Python
```bash
sudo apt install -y python3 python3-pip python3-venv
```

#### 2.4 Install Additional Tools
```bash
sudo apt install -y git build-essential pkg-config libssl-dev protobuf-compiler
```

---

### Step 3: Clone & Setup Project

#### 3.1 Clone Repository
```bash
cd ~
git clone https://github.com/YOUR_USERNAME/smart-contract-2.0.git
cd smart-contract-2.0
```

#### 3.2 Install Linera SDK
```bash
cargo install linera-service --git https://github.com/linera-io/linera-protocol.git --tag v0.15.6
```

#### 3.3 Setup AI Engine
```bash
cd ai-engine
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

#### 3.4 Setup Oracle Service
```bash
cd ../oracle-service
npm install
```

---

### Step 4: Configure Environment

#### 4.1 Create Environment Files
```bash
# AI Engine
cat > ~/smart-contract-2.0/ai-engine/.env << EOF
FLASK_ENV=production
FLASK_PORT=5000
MODEL_PATH=./models
LOG_LEVEL=INFO
EOF

# Oracle Service
cat > ~/smart-contract-2.0/oracle-service/.env << EOF
NODE_ENV=production
PORT=3000
AI_ENGINE_URL=http://localhost:5000
LINERA_GRAPHQL_URL=http://localhost:8080/graphql
LINERA_WS_URL=ws://localhost:8080/ws
CORS_ORIGIN=https://smartcontract2-linera-eight.vercel.app
EOF
```

---

### Step 5: Deploy Linera Network

#### 5.1 Start Linera Network
```bash
cd ~/smart-contract-2.0
linera net up
```

#### 5.2 Build Smart Contract
```bash
cd smart-contract-2-simple
cargo build --release --target wasm32-unknown-unknown
```

#### 5.3 Deploy Contract
```bash
linera project publish-and-create --json-argument 0
```

#### 5.4 Start GraphQL Service
```bash
linera service --port 8080 &
```

---

### Step 6: Setup Process Managers

#### 6.1 Install PM2 (for Node.js)
```bash
sudo npm install -g pm2
```

#### 6.2 Create PM2 Ecosystem File
```bash
cat > ~/smart-contract-2.0/ecosystem.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'ai-engine',
      cwd: './ai-engine',
      script: 'venv/bin/python',
      args: 'main.py',
      env: {
        FLASK_ENV: 'production',
        FLASK_PORT: 5000
      }
    },
    {
      name: 'oracle-service',
      cwd: './oracle-service',
      script: 'index.js',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      }
    },
    {
      name: 'linera-service',
      script: 'linera',
      args: 'service --port 8080',
      cwd: './smart-contract-2-simple'
    }
  ]
};
EOF
```

#### 6.3 Start All Services
```bash
cd ~/smart-contract-2.0
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

---

### Step 7: Configure Nginx

#### 7.1 Install Nginx
```bash
sudo apt install -y nginx
```

#### 7.2 Create Nginx Configuration
```bash
sudo nano /etc/nginx/sites-available/smartcontract
```

```nginx
server {
    listen 80;
    server_name YOUR_VPS_IP;

    # AI Engine
    location /api/ai/ {
        proxy_pass http://localhost:5000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Oracle Service
    location /api/oracle/ {
        proxy_pass http://localhost:3000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # Linera GraphQL
    location /graphql {
        proxy_pass http://localhost:8080/graphql;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # WebSocket
    location /ws {
        proxy_pass http://localhost:8080/ws;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }
}
```

#### 7.3 Enable Site
```bash
sudo ln -s /etc/nginx/sites-available/smartcontract /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

### Step 8: Configure Firewall

```bash
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
```

---

### Step 9: Setup SSL (Optional but Recommended)

#### 9.1 Install Certbot
```bash
sudo apt install -y certbot python3-certbot-nginx
```

#### 9.2 Get SSL Certificate
```bash
sudo certbot --nginx -d your-domain.com
```

---

### Step 10: Update Frontend

Update frontend untuk connect ke VPS:

```javascript
// frontend/config.js
const API_CONFIG = {
  AI_ENGINE: 'http://YOUR_VPS_IP/api/ai',
  ORACLE_SERVICE: 'http://YOUR_VPS_IP/api/oracle',
  GRAPHQL_ENDPOINT: 'http://YOUR_VPS_IP/graphql',
  WS_ENDPOINT: 'ws://YOUR_VPS_IP/ws'
};
```

---

## 🔍 Monitoring & Maintenance

### Check Service Status
```bash
pm2 status
pm2 logs
```

### Restart Services
```bash
pm2 restart all
```

### Update Application
```bash
cd ~/smart-contract-2.0
git pull
pm2 restart all
```

### Monitor Resources
```bash
htop
df -h
free -m
```

---

## 📊 Cost Estimation

### Monthly Costs

| Provider | Specs | Price |
|----------|-------|-------|
| Contabo | 4 vCPU, 6GB RAM | $5.50/month |
| DigitalOcean | 1 vCPU, 1GB RAM | $6/month |
| Vultr | 1 vCPU, 1GB RAM | $6/month |
| IDCloudHost | 1 vCPU, 1GB RAM | Rp 20.000/month |

**Recommended:** Contabo (best value) atau DigitalOcean (easiest)

---

## 🎯 Architecture After VPS Deployment

```
Internet
    ↓
Nginx (Port 80/443)
    ↓
    ├─→ AI Engine (Port 5000)
    ├─→ Oracle Service (Port 3000)
    └─→ Linera GraphQL (Port 8080)
         ↓
    Linera Network (Local)
         ↓
    Smart Contract (WASM)
```

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] VPS accessible via SSH
- [ ] All services running (pm2 status)
- [ ] Nginx serving requests
- [ ] GraphQL endpoint accessible
- [ ] AI Engine responding
- [ ] Oracle Service working
- [ ] Frontend can connect to backend
- [ ] Firewall configured
- [ ] SSL certificate installed (if using domain)

---

## 🚨 Troubleshooting

### Service Not Starting
```bash
pm2 logs <service-name>
journalctl -u nginx
```

### Port Already in Use
```bash
sudo lsof -i :8080
sudo kill -9 <PID>
```

### Out of Memory
```bash
# Add swap space
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

---

## 📚 Next Steps

1. ✅ Deploy to VPS
2. ✅ Configure domain (optional)
3. ✅ Setup SSL certificate
4. ✅ Update frontend config
5. ✅ Test all endpoints
6. ✅ Monitor performance
7. ✅ Setup backups

---

## 🎉 Benefits After VPS Deployment

✅ **Fully Live** - Accessible 24/7 from anywhere  
✅ **Real Backend** - Actual AI predictions and blockchain  
✅ **Public API** - Can be used by other applications  
✅ **Custom Domain** - Professional URL  
✅ **SSL/HTTPS** - Secure connections  
✅ **Scalable** - Easy to upgrade resources  

---

**Ready to deploy? Follow the steps above!** 🚀
