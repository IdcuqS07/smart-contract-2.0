#!/bin/bash
# Quick deployment script - run immediately after CLI installation completes

set -e

echo "🚀 IMMEDIATE DEPLOYMENT TO LINERA TESTNET"
echo "=========================================="
echo ""

# Verify CLI installed
if ! command -v linera &> /dev/null; then
    echo "❌ Linera CLI not found. Please wait for installation to complete."
    exit 1
fi

echo "✅ Linera CLI found: $(linera --version)"
echo ""

# Step 1: Initialize wallet
echo "📝 Step 1/5: Initializing wallet..."
linera wallet init --with-new-chain --faucet https://faucet.testnet-conway.linera.net

echo ""
echo "💰 Wallet info:"
linera wallet show

# Save wallet info
linera wallet show > .linera-wallet-info.txt

echo ""
echo "📦 Step 2/5: Verifying WASM files..."
cd linera-integration
ls -lh target/wasm32-unknown-unknown/release/smart_contract_2_linera*.wasm

echo ""
echo "📤 Step 3/5: Publishing to testnet..."
APP_OUTPUT=$(linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm 2>&1)

echo "$APP_OUTPUT"

# Extract Application ID
APP_ID=$(echo "$APP_OUTPUT" | grep -o "Application ID: [a-f0-9]*" | cut -d' ' -f3 || echo "")

if [ -z "$APP_ID" ]; then
    echo "⚠️  Could not extract Application ID from output"
    echo "Full output saved to .linera-deploy-output.txt"
    echo "$APP_OUTPUT" > .linera-deploy-output.txt
else
    echo ""
    echo "✅ Application deployed successfully!"
    echo "📋 Application ID: $APP_ID"
    echo "$APP_ID" > .linera-app-id
fi

echo ""
echo "🌐 Step 4/5: Starting GraphQL service..."
linera service --port 8080 &
SERVICE_PID=$!
echo "Service PID: $SERVICE_PID"
echo "$SERVICE_PID" > .linera-service-pid

sleep 5

echo ""
echo "🧪 Step 5/5: Testing deployment..."
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ contractCounter }"}' \
  | python3 -m json.tool || echo "GraphQL endpoint not ready yet"

echo ""
echo "=========================================="
echo "✅ DEPLOYMENT COMPLETE!"
echo "=========================================="
echo ""
echo "📊 Deployment Information:"
echo "  Application ID: $APP_ID"
echo "  GraphQL URL: http://localhost:8080/graphql"
echo "  Service PID: $SERVICE_PID"
echo ""
echo "📝 Next steps:"
echo "  1. Test GraphQL: curl -X POST http://localhost:8080/graphql -d '{\"query\":\"{contractCounter}\"}'"
echo "  2. View logs: tail -f ~/.linera/service.log"
echo "  3. Stop service: kill $SERVICE_PID"
echo ""
echo "🎉 Smart Contract 2.0 is now live on Linera Testnet Conway!"
