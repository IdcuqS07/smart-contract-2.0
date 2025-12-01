#!/bin/bash

set -e

echo "🚀 Deploying Smart Contract 2.0 to Local Linera Devnet"
echo "======================================================="
echo ""

cd "$(dirname "$0")/.."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Step 1: Building WASM bytecode...${NC}"
cargo build --release --target wasm32-unknown-unknown

echo ""
echo -e "${BLUE}Step 2: Starting local devnet...${NC}"
echo "This will start a local Linera network for testing"
echo ""

# Kill any existing linera processes
pkill -f "linera" || true
sleep 2

# Start local devnet in background
echo "Starting devnet..."
linera net up --testing-prng-seed 37 > devnet.log 2>&1 &
DEVNET_PID=$!

echo "Waiting for devnet to start..."
sleep 5

# Check if devnet is running
if ! ps -p $DEVNET_PID > /dev/null; then
    echo "❌ Failed to start devnet"
    cat devnet.log
    exit 1
fi

echo -e "${GREEN}✅ Devnet started (PID: $DEVNET_PID)${NC}"

echo ""
echo -e "${BLUE}Step 3: Checking wallet...${NC}"
linera wallet show

echo ""
echo -e "${BLUE}Step 4: Deploying application...${NC}"

# Try to deploy
BYTECODE_PATH="target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm"

if [ ! -f "$BYTECODE_PATH" ]; then
    echo "❌ Error: WASM file not found at $BYTECODE_PATH"
    kill $DEVNET_PID
    exit 1
fi

echo "Deploying application..."
linera project publish-and-create "$BYTECODE_PATH" 2>&1 | tee deploy-output.log

echo ""
echo -e "${GREEN}✅ Deployment process completed!${NC}"
echo ""
echo "Devnet is running in background (PID: $DEVNET_PID)"
echo "To stop: kill $DEVNET_PID"
echo ""
echo "Check deploy-output.log for deployment details"
echo "Check devnet.log for devnet logs"
