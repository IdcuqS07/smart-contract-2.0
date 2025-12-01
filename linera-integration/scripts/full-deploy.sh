#!/bin/bash

# Full Linera Deployment Script for Smart Contract 2.0
# This script handles complete deployment from build to testing

set -e

echo "🚀 Starting Full Linera Deployment..."
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
LINERA_DIR="$HOME/.config/linera"
WALLET_PATH="$LINERA_DIR/wallet.json"
STORAGE_PATH="$LINERA_DIR/storage.db"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo -e "${BLUE}📁 Project Directory: $PROJECT_DIR${NC}"

# Step 1: Check Prerequisites
echo -e "\n${YELLOW}Step 1: Checking Prerequisites...${NC}"

if ! command -v linera &> /dev/null; then
    echo -e "${RED}❌ Linera CLI not found!${NC}"
    echo "Please install Linera CLI first:"
    echo "  curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera"
    echo "  chmod +x linera"
    echo "  sudo mv linera /usr/local/bin/"
    exit 1
fi

if ! command -v cargo &> /dev/null; then
    echo -e "${RED}❌ Rust/Cargo not found!${NC}"
    echo "Please install Rust: https://rustup.rs/"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites OK${NC}"

# Step 2: Build Smart Contract
echo -e "\n${YELLOW}Step 2: Building Smart Contract...${NC}"
cd "$PROJECT_DIR"

echo "Cleaning previous builds..."
cargo clean

echo "Building contract and service..."
cargo build --release --target wasm32-unknown-unknown

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

# Step 3: Initialize Linera Wallet (if needed)
echo -e "\n${YELLOW}Step 3: Initializing Linera Wallet...${NC}"

if [ ! -f "$WALLET_PATH" ]; then
    echo "Creating new wallet..."
    linera wallet init --with-new-chain --storage rocksdb:$STORAGE_PATH
    echo -e "${GREEN}✅ Wallet created${NC}"
else
    echo -e "${GREEN}✅ Wallet already exists${NC}"
fi

# Step 4: Start Local Linera Network
echo -e "\n${YELLOW}Step 4: Starting Local Linera Network...${NC}"

# Kill any existing linera service
pkill -f "linera service" || true
sleep 2

# Start service in background
echo "Starting Linera service on port 8080..."
linera service --port 8080 &
LINERA_PID=$!

echo "Waiting for service to start..."
sleep 5

# Check if service is running
if ps -p $LINERA_PID > /dev/null; then
    echo -e "${GREEN}✅ Linera service running (PID: $LINERA_PID)${NC}"
else
    echo -e "${RED}❌ Failed to start Linera service${NC}"
    exit 1
fi

# Step 5: Deploy Smart Contract
echo -e "\n${YELLOW}Step 5: Deploying Smart Contract...${NC}"

# Get default chain
DEFAULT_CHAIN=$(linera wallet show | grep "Public Key" -A 1 | tail -n 1 | awk '{print $1}')
echo "Default chain: $DEFAULT_CHAIN"

# Publish and create application
echo "Publishing application..."
CONTRACT_PATH="$PROJECT_DIR/target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm"
SERVICE_PATH="$PROJECT_DIR/target/wasm32-unknown-unknown/release/smart_contract_2_service.wasm"

if [ ! -f "$CONTRACT_PATH" ] || [ ! -f "$SERVICE_PATH" ]; then
    echo -e "${RED}❌ WASM files not found!${NC}"
    echo "Expected:"
    echo "  - $CONTRACT_PATH"
    echo "  - $SERVICE_PATH"
    exit 1
fi

DEPLOY_OUTPUT=$(linera publish-and-create \
    "$CONTRACT_PATH" \
    "$SERVICE_PATH" \
    --json-argument "null" 2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Contract deployed successfully${NC}"
    
    # Extract application ID
    APP_ID=$(echo "$DEPLOY_OUTPUT" | grep -o '"[a-f0-9]\{64\}"' | head -n 1 | tr -d '"')
    
    if [ -n "$APP_ID" ]; then
        echo -e "${GREEN}📝 Application ID: $APP_ID${NC}"
        
        # Save to config file
        cat > "$PROJECT_DIR/deployment-config.json" <<EOF
{
  "applicationId": "$APP_ID",
  "chainId": "$DEFAULT_CHAIN",
  "graphqlEndpoint": "http://localhost:8080/graphql",
  "wsEndpoint": "ws://localhost:8080/ws",
  "deployedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
        echo -e "${GREEN}✅ Configuration saved to deployment-config.json${NC}"
    fi
else
    echo -e "${RED}❌ Deployment failed${NC}"
    echo "$DEPLOY_OUTPUT"
    exit 1
fi

# Step 6: Test GraphQL Endpoint
echo -e "\n${YELLOW}Step 6: Testing GraphQL Endpoint...${NC}"

GRAPHQL_TEST=$(curl -s -X POST http://localhost:8080/graphql \
    -H "Content-Type: application/json" \
    -d '{"query": "{ chains { list } }"}')

if echo "$GRAPHQL_TEST" | grep -q "chains"; then
    echo -e "${GREEN}✅ GraphQL endpoint working${NC}"
else
    echo -e "${RED}❌ GraphQL endpoint not responding${NC}"
    echo "$GRAPHQL_TEST"
fi

# Step 7: Summary
echo -e "\n${GREEN}======================================"
echo "🎉 Deployment Complete!"
echo "======================================${NC}"
echo ""
echo "📋 Deployment Information:"
echo "  - Application ID: $APP_ID"
echo "  - Chain ID: $DEFAULT_CHAIN"
echo "  - GraphQL: http://localhost:8080/graphql"
echo "  - WebSocket: ws://localhost:8080/ws"
echo ""
echo "🔧 Next Steps:"
echo "  1. Test the contract:"
echo "     cd linera-integration/oracle-client"
echo "     node test.js"
echo ""
echo "  2. Start Oracle Service:"
echo "     cd oracle-service"
echo "     npm start"
echo ""
echo "  3. Start AI Engine:"
echo "     cd ai-engine"
echo "     python main.py"
echo ""
echo "  4. Open Frontend:"
echo "     cd frontend"
echo "     open index.html"
echo ""
echo "📝 Configuration saved to: deployment-config.json"
echo ""
echo "To stop Linera service:"
echo "  kill $LINERA_PID"
echo ""
