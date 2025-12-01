#!/bin/bash

# Quick Start Script for Linera Smart Contract
# Linera SDK v0.15.6

set -e

echo "🚀 Linera Smart Contract Quick Start"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Build Contract
echo -e "${BLUE}Step 1: Building Smart Contract...${NC}"
cd "$(dirname "$0")/.."
cargo build --release --target wasm32-unknown-unknown
echo -e "${GREEN}✅ Build complete!${NC}"
echo ""

# Step 2: Check if network is running
echo -e "${BLUE}Step 2: Checking Linera Network...${NC}"
if ! pgrep -f "linera-proxy" > /dev/null; then
    echo -e "${YELLOW}⚠️  Local network not running${NC}"
    echo "Please start the network first:"
    echo "  linera net up"
    echo ""
    echo "Then run this script again."
    exit 1
fi
echo -e "${GREEN}✅ Network is running${NC}"
echo ""

# Step 3: Deploy Contract
echo -e "${BLUE}Step 3: Deploying Smart Contract...${NC}"
CONTRACT_WASM="target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm"
SERVICE_WASM="target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm"

if [ ! -f "$CONTRACT_WASM" ] || [ ! -f "$SERVICE_WASM" ]; then
    echo -e "${YELLOW}⚠️  WASM files not found${NC}"
    exit 1
fi

echo "Publishing and creating application..."
linera project publish-and-create "$CONTRACT_WASM" "$SERVICE_WASM"
echo -e "${GREEN}✅ Contract deployed!${NC}"
echo ""

# Step 4: Instructions
echo -e "${BLUE}Step 4: Next Steps${NC}"
echo "Start the GraphQL service:"
echo "  linera service --port 8080"
echo ""
echo "Then access:"
echo "  GraphQL Playground: http://localhost:8080/graphql"
echo "  GraphQL Endpoint: http://localhost:8080"
echo ""
echo -e "${GREEN}🎉 Setup complete!${NC}"
