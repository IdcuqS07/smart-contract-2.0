#!/bin/bash

set -e

echo "🚀 Deploying GraphQL Proxy to VPS"
echo "=================================="
echo ""

VPS_HOST="${VPS_HOST:-143.198.205.88}"
VPS_USER="${VPS_USER:-root}"

# Application Details
APP_ID="bb8c6e801d6433ed2c705861b622d943e89c759f65b1476985214ea4005a4160"
CHAIN_ID="23db34dcbdbf832798b977b48248733e0505abab109466eee41da8fb2171dc3b"

echo "📋 Configuration:"
echo "  VPS: $VPS_HOST"
echo "  Application ID: $APP_ID"
echo ""

# Deploy simple proxy that forwards to local Linera service
ssh $VPS_USER@$VPS_HOST << 'ENDSSH'

# Install Node.js if not installed
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
fi

# Create proxy directory
mkdir -p /root/linera-proxy
cd /root/linera-proxy

# Create package.json
cat > package.json << 'EOF'
{
  "name": "linera-graphql-proxy",
  "version": "1.0.0",
  "description": "GraphQL Proxy for Linera",
  "main": "server.js",
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "http-proxy-middleware": "^2.0.6"
  }
}
EOF

# Install dependencies
npm install

# Create proxy server
cat > server.js << 'EOF'
const express = require('express');
const cors = require('cors');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = 8080;

// CORS configuration
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    service: 'Linera GraphQL Proxy',
    timestamp: new Date().toISOString()
  });
});

// GraphQL endpoint info
app.get('/', (req, res) => {
  res.json({
    service: 'Linera GraphQL Proxy',
    endpoints: {
      graphql: '/graphql',
      health: '/health'
    },
    applicationId: 'bb8c6e801d6433ed2c705861b622d943e89c759f65b1476985214ea4005a4160',
    chainId: '23db34dcbdbf832798b977b48248733e0505abab109466eee41da8fb2171dc3b'
  });
});

// Proxy GraphQL requests to Linera testnet validators
app.use('/graphql', createProxyMiddleware({
  target: 'https://linera-testnet.rubynodes.io',
  changeOrigin: true,
  pathRewrite: {
    '^/graphql': '/graphql'
  },
  onProxyReq: (proxyReq, req, res) => {
    console.log(`[${new Date().toISOString()}] Proxying ${req.method} ${req.url}`);
  },
  onError: (err, req, res) => {
    console.error('Proxy error:', err);
    res.status(500).json({ error: 'Proxy error', message: err.message });
  }
}));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Linera GraphQL Proxy running on port ${PORT}`);
  console.log(`📡 GraphQL endpoint: http://0.0.0.0:${PORT}/graphql`);
  console.log(`🏥 Health check: http://0.0.0.0:${PORT}/health`);
});
EOF

echo "✅ Proxy server created"

# Create systemd service
cat > /etc/systemd/system/linera-proxy.service << 'EOF'
[Unit]
Description=Linera GraphQL Proxy
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/linera-proxy
Environment="NODE_ENV=production"
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Reload and start service
systemctl daemon-reload
systemctl enable linera-proxy
systemctl restart linera-proxy

echo "✅ Service started"

# Configure firewall
ufw allow 8080/tcp

# Setup Nginx
if ! command -v nginx &> /dev/null; then
    apt-get update
    apt-get install -y nginx
fi

cat > /etc/nginx/sites-available/linera << 'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type' always;
    }
}
EOF

ln -sf /etc/nginx/sites-available/linera /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

nginx -t && systemctl reload nginx

echo "✅ Nginx configured"

ENDSSH

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "📡 Access Points:"
echo "  GraphQL: http://$VPS_HOST/graphql"
echo "  Health: http://$VPS_HOST/health"
echo "  Info: http://$VPS_HOST/"
echo ""
echo "🧪 Test:"
echo "  curl http://$VPS_HOST/health"
echo ""
