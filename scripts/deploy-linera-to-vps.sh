#!/bin/bash

set -e

echo "🚀 Deploying Linera GraphQL Service to VPS"
echo "==========================================="
echo ""

# VPS Configuration
VPS_HOST="${VPS_HOST:-139.59.102.167}"
VPS_USER="${VPS_USER:-root}"
VPS_PORT="${VPS_PORT:-22}"
LINERA_PORT="${LINERA_PORT:-8080}"

# Application Details
APP_ID="bb8c6e801d6433ed2c705861b622d943e89c759f65b1476985214ea4005a4160"
CHAIN_ID="23db34dcbdbf832798b977b48248733e0505abab109466eee41da8fb2171dc3b"

echo "📋 Configuration:"
echo "  VPS Host: $VPS_HOST"
echo "  VPS User: $VPS_USER"
echo "  Linera Port: $LINERA_PORT"
echo "  Application ID: $APP_ID"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Step 1: Installing Linera on VPS...${NC}"
ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << 'ENDSSH'
# Install Rust if not installed
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

# Add wasm32 target
rustup target add wasm32-unknown-unknown

# Install Linera CLI
if ! command -v linera &> /dev/null; then
    echo "Installing Linera CLI..."
    cargo install linera-service --git https://github.com/linera-io/linera-protocol.git --tag v0.15.6
fi

echo "✅ Linera installed"
ENDSSH

echo ""
echo -e "${BLUE}Step 2: Copying wallet configuration...${NC}"

# Copy wallet from local to VPS
WALLET_DIR="$HOME/Library/Application Support/linera"
if [ -d "$WALLET_DIR" ]; then
    echo "Copying wallet.json to VPS..."
    scp -P $VPS_PORT "$WALLET_DIR/wallet.json" $VPS_USER@$VPS_HOST:/root/.linera/
    echo "✅ Wallet copied"
else
    echo "⚠️  Wallet not found locally. Will need to initialize on VPS."
fi

echo ""
echo -e "${BLUE}Step 3: Creating systemd service...${NC}"

ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << ENDSSH
# Create systemd service file
cat > /etc/systemd/system/linera-graphql.service << 'EOF'
[Unit]
Description=Linera GraphQL Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root
Environment="PATH=/root/.cargo/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/root/.cargo/bin/linera service --port $LINERA_PORT
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Enable and start service
systemctl enable linera-graphql
systemctl restart linera-graphql

echo "✅ Systemd service created and started"
ENDSSH

echo ""
echo -e "${BLUE}Step 4: Configuring firewall...${NC}"

ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << ENDSSH
# Allow Linera port
ufw allow $LINERA_PORT/tcp

echo "✅ Firewall configured"
ENDSSH

echo ""
echo -e "${BLUE}Step 5: Setting up Nginx reverse proxy...${NC}"

ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << 'ENDSSH'
# Install Nginx if not installed
if ! command -v nginx &> /dev/null; then
    apt-get update
    apt-get install -y nginx
fi

# Create Nginx configuration
cat > /etc/nginx/sites-available/linera-graphql << 'EOF'
server {
    listen 80;
    server_name _;

    location /graphql {
        proxy_pass http://localhost:8080/graphql;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # CORS headers
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type' always;
        
        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }

    location /ws {
        proxy_pass http://localhost:8080/ws;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/linera-graphql /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test and reload Nginx
nginx -t && systemctl reload nginx

echo "✅ Nginx configured"
ENDSSH

echo ""
echo -e "${BLUE}Step 6: Checking service status...${NC}"

ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << 'ENDSSH'
echo "Linera GraphQL Service Status:"
systemctl status linera-graphql --no-pager | head -20

echo ""
echo "Nginx Status:"
systemctl status nginx --no-pager | head -10
ENDSSH

echo ""
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo ""
echo "📡 Access Points:"
echo "  GraphQL Endpoint: http://$VPS_HOST/graphql"
echo "  GraphiQL IDE: http://$VPS_HOST"
echo "  WebSocket: ws://$VPS_HOST/ws"
echo ""
echo "🔍 Test with:"
echo "  curl -X POST http://$VPS_HOST/graphql \\"
echo "    -H 'Content-Type: application/json' \\"
echo "    -d '{\"query\": \"{ chains { list { default } } }\"}'"
echo ""
echo "📊 Monitor logs:"
echo "  ssh $VPS_USER@$VPS_HOST 'journalctl -u linera-graphql -f'"
echo ""
echo "🎉 Linera GraphQL Service is now live on VPS!"
