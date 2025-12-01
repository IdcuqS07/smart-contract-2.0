#!/bin/bash

# Deploy to Local Linera Network
# Requires: linera net up running

set -e

echo "🚀 Deploying Smart Contract to Local Linera Network"
echo "===================================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Check if network is running
if ! pgrep -f "linera-proxy" > /dev/null; then
    echo -e "${RED}❌ Local network not running${NC}"
    echo "Please start the network first:"
    echo "  linera net up"
    exit 1
fi

echo -e "${GREEN}✅ Network is running${NC}"
echo ""

# Build contract
echo -e "${BLUE}Step 1: Building Smart Contract...${NC}"
cargo build --release --target wasm32-unknown-unknown
echo -e "${GREEN}✅ Build complete${NC}"
echo ""

# Check WASM files
CONTRACT_WASM="target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm"
SERVICE_WASM="target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm"

if [ ! -f "$CONTRACT_WASM" ]; then
    echo -e "${RED}❌ Contract WASM not found: $CONTRACT_WASM${NC}"
    exit 1
fi

if [ ! -f "$SERVICE_WASM" ]; then
    echo -e "${RED}❌ Service WASM not found: $SERVICE_WASM${NC}"
    exit 1
fi

echo -e "${GREEN}✅ WASM files ready${NC}"
echo "  Contract: $(ls -lh $CONTRACT_WASM | awk '{print $5}')"
echo "  Service: $(ls -lh $SERVICE_WASM | awk '{print $5}')"
echo ""

# Deploy
echo -e "${BLUE}Step 2: Publishing and Creating Application...${NC}"

# Use linera project publish-and-create
OUTPUT=$(linera project publish-and-create 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo ""
    echo "$OUTPUT"
    echo ""
    
    # Extract application ID if possible
    APP_ID=$(echo "$OUTPUT" | grep -o 'e476187f6ddfeb9d588c7b45d3df334d52fd60221610d44e0b2472942e36c5f6[a-f0-9]*' | head -1)
    
    if [ ! -z "$APP_ID" ]; then
        echo -e "${BLUE}Application ID:${NC} $APP_ID"
        echo ""
    fi
    
    echo -e "${BLUE}Next Steps:${NC}"
    echo "1. Start GraphQL service:"
    echo "   linera service --port 8080"
    echo ""
    echo "2. Access GraphQL playground:"
    echo "   http://localhost:8080/graphql"
    echo ""
    echo -e "${GREEN}🎉 Deployment complete!${NC}"
else
    echo -e "${RED}❌ Deployment failed${NC}"
    echo "$OUTPUT"
    exit 1
fi
