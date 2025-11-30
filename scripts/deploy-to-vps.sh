#!/bin/bash

# 🚀 Smart Contract 2.0 - VPS Deployment Script
# This script automates the deployment to VPS

set -e

echo "🚀 Smart Contract 2.0 - VPS Deployment"
echo "========================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}❌ Please don't run as root. Use a regular user with sudo access.${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 This script will:${NC}"
echo "  1. Install all dependencies"
echo "  2. Setup Linera SDK"
echo "  3. Deploy smart contract"
echo "  4. Setup AI Engine"
echo "  5. Setup Oracle Service"
echo "  6. Configure Nginx"
echo "  7. Setup PM2 process manager"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Step 1: Update System
echo -e "${GREEN}📦 Step 1: Updating system...${NC}"
sudo apt update && sudo apt upgrade -y

# Step 2: Install Dependencies
echo -e "${GREEN}📦 Step 2: Installing dependencies...${NC}"
sudo apt install -y git build-essential pkg-config libssl-dev protobuf-compiler curl

# Step 3: Install Rust
echo -e "${GREEN}🦀 Step 3: Installing Rust...${NC}"
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    rustup target add wasm32-unknown-unknown
else
    echo "Rust already installed"
fi

# Step 4: Install Node.js
echo -e "${GREEN}📗 Step 4: Installing Node.js...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js already installed"
fi

# Step 5: Install Python
echo -e "${GREEN}🐍 Step 5: Installing Python...${NC}"
sudo apt install -y python3 python3-pip python3-venv

# Step 6: Install PM2
echo -e "${GREEN}⚙️  Step 6: Installing PM2...${NC}"
if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
else
    echo "PM2 already installed"
fi

# Step 7: Install Nginx
echo -e "${GREEN}🌐 Step 7: Installing Nginx...${NC}"
if ! command -v nginx &> /dev/null; then
    sudo apt install -y nginx
else
    echo "Nginx already installed"
fi

# Step 8: Install Linera SDK
echo -e "${GREEN}⛓️  Step 8: Installing Linera SDK...${NC}"
if ! command -v linera &> /dev/null; then
    cargo install linera-service --git https://github.com/linera-io/linera-protocol.git --tag v0.15.6
else
    echo "Linera SDK already installed"
fi

# Step 9: Setup AI Engine
echo -e "${GREEN}🤖 Step 9: Setting up AI Engine...${NC}"
cd ai-engine
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate
pip install -r requirements.txt
deactivate
cd ..

# Step 10: Setup Oracle Service
echo -e "${GREEN}🔮 Step 10: Setting up Oracle Service...${NC}"
cd oracle-service
npm install
cd ..

# Step 11: Create Environment Files
echo -e "${GREEN}📝 Step 11: Creating environment files...${NC}"

# AI Engine .env
cat > ai-engine/.env << EOF
FLASK_ENV=production
FLASK_PORT=5000
MODEL_PATH=./models
LOG_LEVEL=INFO
EOF

# Oracle Service .env
cat > oracle-service/.env << EOF
NODE_ENV=production
PORT=3000
AI_ENGINE_URL=http://localhost:5000
LINERA_GRAPHQL_URL=http://localhost:8080/graphql
LINERA_WS_URL=ws://localhost:8080/ws
CORS_ORIGIN=https://smartcontract2-linera-eight.vercel.app
EOF

# Step 12: Create PM2 Ecosystem
echo -e "${GREEN}⚙️  Step 12: Creating PM2 configuration...${NC}"
cat > ecosystem.config.js << 'EOF'
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
      },
      error_file: './logs/ai-engine-error.log',
      out_file: './logs/ai-engine-out.log'
    },
    {
      name: 'oracle-service',
      cwd: './oracle-service',
      script: 'index.js',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      error_file: './logs/oracle-error.log',
      out_file: './logs/oracle-out.log'
    }
  ]
};
EOF

# Create logs directory
mkdir -p logs

# Step 13: Deploy Linera Network
echo -e "${GREEN}⛓️  Step 13: Deploying Linera network...${NC}"
linera net up

# Step 14: Build Smart Contract
echo -e "${GREEN}🔨 Step 14: Building smart contract...${NC}"
cd smart-contract-2-simple
cargo build --release --target wasm32-unknown-unknown

# Step 15: Deploy Contract
echo -e "${GREEN}🚀 Step 15: Deploying smart contract...${NC}"
linera project publish-and-create --json-argument 0

# Step 16: Start Linera Service
echo -e "${GREEN}🌐 Step 16: Starting Linera GraphQL service...${NC}"
nohup linera service --port 8080 > ../logs/linera-service.log 2>&1 &
cd ..

# Step 17: Start PM2 Services
echo -e "${GREEN}▶️  Step 17: Starting all services with PM2...${NC}"
pm2 start ecosystem.config.js
pm2 save
pm2 startup

# Step 18: Configure Nginx
echo -e "${GREEN}🌐 Step 18: Configuring Nginx...${NC}"
VPS_IP=$(curl -s ifconfig.me)

sudo tee /etc/nginx/sites-available/smartcontract > /dev/null << EOF
server {
    listen 80;
    server_name $VPS_IP;

    # AI Engine
    location /api/ai/ {
        proxy_pass http://localhost:5000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    # Oracle Service
    location /api/oracle/ {
        proxy_pass http://localhost:3000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }

    # Linera GraphQL
    location /graphql {
        proxy_pass http://localhost:8080/graphql;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    # WebSocket
    location /ws {
        proxy_pass http://localhost:8080/ws;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host \$host;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/smartcontract /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Step 19: Configure Firewall
echo -e "${GREEN}🔒 Step 19: Configuring firewall...${NC}"
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
echo "y" | sudo ufw enable

# Step 20: Display Status
echo ""
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo "========================================"
echo ""
echo -e "${YELLOW}📊 Service Status:${NC}"
pm2 status
echo ""
echo -e "${YELLOW}🌐 Access Points:${NC}"
echo "  AI Engine:      http://$VPS_IP/api/ai"
echo "  Oracle Service: http://$VPS_IP/api/oracle"
echo "  GraphQL:        http://$VPS_IP/graphql"
echo "  WebSocket:      ws://$VPS_IP/ws"
echo ""
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "  1. Update frontend config with VPS IP: $VPS_IP"
echo "  2. Test all endpoints"
echo "  3. (Optional) Setup domain and SSL"
echo ""
echo -e "${YELLOW}🔍 Useful Commands:${NC}"
echo "  pm2 status          - Check service status"
echo "  pm2 logs            - View logs"
echo "  pm2 restart all     - Restart all services"
echo "  sudo systemctl status nginx - Check Nginx status"
echo ""
echo -e "${GREEN}🎉 Your application is now LIVE!${NC}"
