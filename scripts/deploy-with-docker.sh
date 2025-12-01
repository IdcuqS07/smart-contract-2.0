#!/bin/bash
set -e

echo "🚀 Deploying Smart Contract 2.0 to Linera Testnet using Docker"
echo "================================================================"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Build smart contract
echo -e "${BLUE}📦 Step 1: Building smart contract...${NC}"
cd linera-integration
cargo build --release --target wasm32-unknown-unknown

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful${NC}"
else
    echo "❌ Build failed"
    exit 1
fi

# Check WASM files
echo -e "${BLUE}📋 Checking WASM files...${NC}"
ls -lh target/wasm32-unknown-unknown/release/*.wasm

# Step 2: Pull Linera Docker image
echo -e "${BLUE}🐳 Step 2: Pulling Linera Docker image...${NC}"
docker pull ghcr.io/linera-io/linera:latest

# Step 3: Initialize wallet in Docker
echo -e "${BLUE}💼 Step 3: Initializing wallet...${NC}"
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/linera-io/linera:latest \
  linera wallet init --with-new-chain \
  --faucet https://faucet.testnet-conway.linera.net

# Step 4: Show wallet info
echo -e "${BLUE}📊 Step 4: Wallet information...${NC}"
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/linera-io/linera:latest \
  linera wallet show

# Step 5: Publish application
echo -e "${BLUE}📤 Step 5: Publishing application to testnet...${NC}"
APP_OUTPUT=$(docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/linera-io/linera:latest \
  linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm)

echo "$APP_OUTPUT"

# Extract Application ID
APP_ID=$(echo "$APP_OUTPUT" | grep -o "Application ID: [a-f0-9]*" | cut -d' ' -f3)

if [ -z "$APP_ID" ]; then
    echo -e "${YELLOW}⚠️  Could not extract Application ID${NC}"
    echo "Full output:"
    echo "$APP_OUTPUT"
else
    echo -e "${GREEN}✅ Application deployed!${NC}"
    echo -e "${GREEN}Application ID: $APP_ID${NC}"
    echo "$APP_ID" > .linera-app-id
fi

# Step 6: Start service
echo -e "${BLUE}🌐 Step 6: Starting GraphQL service...${NC}"
docker run -d \
  --name linera-service \
  -p 8080:8080 \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/linera-io/linera:latest \
  linera service --port 8080

sleep 5

# Step 7: Test GraphQL endpoint
echo -e "${BLUE}🧪 Step 7: Testing GraphQL endpoint...${NC}"
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ contractCounter }"}' \
  | jq .

echo ""
echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${GREEN}================================================================${NC}"
echo ""
echo -e "📊 ${BLUE}Application ID:${NC} $APP_ID"
echo -e "🌐 ${BLUE}GraphQL URL:${NC} http://localhost:8080/graphql"
echo -e "📝 ${BLUE}Wallet Info:${NC} docker exec linera-service linera wallet show"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Test operations: curl -X POST http://localhost:8080/graphql -d '{\"query\":\"{contractCounter}\"}'"
echo "2. View logs: docker logs linera-service"
echo "3. Stop service: docker stop linera-service"
echo ""
