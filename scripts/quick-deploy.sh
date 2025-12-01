#!/bin/bash
set -e

echo "🚀 Quick Deploy to Linera Testnet"
echo "=================================="

cd linera-integration

# Use existing WASM files
CONTRACT_WASM="target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm"
SERVICE_WASM="target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm"

echo "📋 Checking WASM files..."
ls -lh $CONTRACT_WASM
ls -lh $SERVICE_WASM

echo ""
echo "🐳 Pulling Linera Docker image..."
docker pull ghcr.io/linera-io/linera:latest

echo ""
echo "💼 Initializing wallet..."
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/linera-io/linera:latest \
  linera wallet init --with-new-chain \
  --faucet https://faucet.testnet-conway.linera.net

echo ""
echo "📊 Wallet info:"
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/linera-io/linera:latest \
  linera wallet show

echo ""
echo "📤 Publishing application..."
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/linera-io/linera:latest \
  linera project publish-and-create \
  $CONTRACT_WASM \
  $SERVICE_WASM

echo ""
echo "✅ Deployment complete!"
