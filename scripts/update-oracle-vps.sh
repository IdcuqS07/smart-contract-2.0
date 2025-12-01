#!/bin/bash

# Update Oracle Service on VPS
# This script deploys the new oracle service with all endpoints

set -e

VPS_IP="143.198.205.88"
VPS_USER="smartcontract"
PROJECT_DIR="/home/smartcontract/smart-contract-2.0"

echo "🚀 Updating Oracle Service on VPS..."
echo "===================================="
echo ""

# Check if oracle-service directory exists locally
if [ ! -d "oracle-service" ]; then
  echo "❌ Error: oracle-service directory not found!"
  exit 1
fi

# Copy oracle service files
echo "📦 Copying oracle service files..."
scp oracle-service/server.js ${VPS_USER}@${VPS_IP}:${PROJECT_DIR}/oracle-service/
scp oracle-service/package.json ${VPS_USER}@${VPS_IP}:${PROJECT_DIR}/oracle-service/

echo "✅ Files copied!"
echo ""

# SSH and restart service
echo "🔄 Installing dependencies and restarting service..."
ssh ${VPS_USER}@${VPS_IP} << 'ENDSSH'
cd /home/smartcontract/smart-contract-2.0/oracle-service

# Install dependencies
echo "Installing npm packages..."
npm install --production

# Set environment variable
export AI_ENGINE_URL=http://localhost:5001

# Restart with PM2
echo "Restarting with PM2..."
pm2 delete oracle-service 2>/dev/null || true
pm2 start server.js --name oracle-service --env production

# Show status
echo ""
pm2 status

echo ""
echo "✅ Oracle service updated and running!"
ENDSSH

echo ""
echo "⏳ Waiting for service to start..."
sleep 3

echo ""
echo "🧪 Testing endpoints..."
echo "======================"
echo ""

# Test health
echo "1. Testing /health..."
HEALTH=$(curl -s http://${VPS_IP}/api/oracle/health)
echo "$HEALTH" | jq . 2>/dev/null || echo "$HEALTH"

echo ""
echo "2. Testing /request (create contract)..."
CONTRACT=$(curl -s -X POST http://${VPS_IP}/api/oracle/request \
  -H "Content-Type: application/json" \
  -d '{"contractType":"insurance","threshold":50000}')
echo "$CONTRACT" | jq . 2>/dev/null || echo "$CONTRACT"

echo ""
echo "3. Testing /contracts (get all)..."
CONTRACTS=$(curl -s http://${VPS_IP}/api/oracle/contracts)
echo "$CONTRACTS" | jq . 2>/dev/null || echo "$CONTRACTS"

echo ""
echo "✅ Update complete!"
echo ""
echo "📊 Available endpoints:"
echo "  GET  http://${VPS_IP}/api/oracle/health"
echo "  POST http://${VPS_IP}/api/oracle/request"
echo "  GET  http://${VPS_IP}/api/oracle/contracts"
echo "  GET  http://${VPS_IP}/api/oracle/contract/:id"
echo "  POST http://${VPS_IP}/api/oracle/predict"
echo "  GET  http://${VPS_IP}/api/oracle/prediction/:id"
echo "  GET  http://${VPS_IP}/api/oracle/prediction/latest/:contractId"
echo ""
echo "📖 Full documentation: API_ENDPOINTS.md"
echo ""
