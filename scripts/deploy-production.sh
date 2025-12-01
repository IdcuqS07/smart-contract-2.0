#!/bin/bash

# Deploy Production Updates to VPS
# Includes rate limiting, logging, and metrics

set -e

VPS_IP="143.198.205.88"
VPS_USER="smartcontract"
PROJECT_DIR="/home/smartcontract/smart-contract-2.0"

echo "🚀 Deploying Production Updates..."
echo "===================================="
echo ""

# Check if files exist
if [ ! -f "oracle-service/server.js" ] || [ ! -f "ai-engine/main.py" ]; then
  echo "❌ Error: Required files not found!"
  exit 1
fi

echo "📦 Step 1: Copying updated files..."
echo ""

# Copy oracle service
echo "  → Oracle Service..."
scp oracle-service/server.js ${VPS_USER}@${VPS_IP}:${PROJECT_DIR}/oracle-service/

# Copy AI engine
echo "  → AI Engine..."
scp ai-engine/main.py ${VPS_USER}@${VPS_IP}:${PROJECT_DIR}/ai-engine/

echo "✅ Files copied!"
echo ""

echo "🔄 Step 2: Installing dependencies and restarting services..."
echo ""

ssh ${VPS_USER}@${VPS_IP} << 'ENDSSH'
cd /home/smartcontract/smart-contract-2.0

# Install Python dependencies for metrics
echo "Installing Python dependencies..."
cd ai-engine
pip3 install psutil --quiet
cd ..

# Restart services with PM2
echo "Restarting services..."
pm2 restart ai-engine
pm2 restart oracle-service

# Wait for services to start
sleep 3

# Show status
echo ""
pm2 status

echo ""
echo "✅ Services restarted!"
ENDSSH

echo ""
echo "⏳ Waiting for services to stabilize..."
sleep 3

echo ""
echo "🧪 Step 3: Testing production features..."
echo "=========================================="
echo ""

# Test Oracle Service
echo "1. Testing Oracle Health..."
HEALTH=$(curl -s http://${VPS_IP}/api/oracle/health)
echo "$HEALTH" | jq . 2>/dev/null || echo "$HEALTH"

echo ""
echo "2. Testing Oracle Metrics..."
METRICS=$(curl -s http://${VPS_IP}/api/oracle/metrics)
echo "$METRICS" | jq . 2>/dev/null || echo "$METRICS"

echo ""
echo "3. Testing AI Engine Health..."
AI_HEALTH=$(curl -s http://${VPS_IP}/api/ai/health)
echo "$AI_HEALTH" | jq . 2>/dev/null || echo "$AI_HEALTH"

echo ""
echo "4. Testing AI Engine Metrics..."
AI_METRICS=$(curl -s http://${VPS_IP}/api/ai/metrics)
echo "$AI_METRICS" | jq . 2>/dev/null || echo "$AI_METRICS"

echo ""
echo "5. Testing Rate Limiting (sending 5 requests)..."
for i in {1..5}; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://${VPS_IP}/api/oracle/health)
  echo "  Request $i: HTTP $STATUS"
done

echo ""
echo "6. Testing Contract Creation..."
CONTRACT=$(curl -s -X POST http://${VPS_IP}/api/oracle/request \
  -H "Content-Type: application/json" \
  -d '{"contractType":"insurance","threshold":50000}')
echo "$CONTRACT" | jq . 2>/dev/null || echo "$CONTRACT"

echo ""
echo "✅ Production deployment complete!"
echo ""
echo "📊 New Features Enabled:"
echo "  ✅ Rate Limiting (100 req/15min per IP)"
echo "  ✅ Request Logging"
echo "  ✅ Metrics Endpoints"
echo "  ✅ Enhanced Error Handling"
echo "  ✅ 404 Handler"
echo "  ✅ Performance Monitoring"
echo ""
echo "🔍 Monitor Services:"
echo "  Metrics: http://${VPS_IP}/api/oracle/metrics"
echo "  Metrics: http://${VPS_IP}/api/ai/metrics"
echo "  Logs: ssh ${VPS_USER}@${VPS_IP} 'pm2 logs'"
echo ""
echo "📖 Documentation: PRODUCTION_CHECKLIST.md"
echo ""
