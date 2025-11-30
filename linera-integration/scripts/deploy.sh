#!/bin/bash

# Smart Contract 2.0 - Linera Deployment Script

set -e

echo "🚀 Deploying Smart Contract 2.0 to Linera"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Build the contract
echo -e "\n${BLUE}📦 Step 1: Building contract...${NC}"
cargo build --release --target wasm32-unknown-unknown

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build successful${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

# Step 2: Check Linera wallet
echo -e "\n${BLUE}👛 Step 2: Checking Linera wallet...${NC}"
if ! linera wallet show > /dev/null 2>&1; then
    echo "Creating new wallet..."
    linera wallet init --with-new-chain
fi

CHAIN_ID=$(linera wallet show | grep "Chain ID" | head -1 | awk '{print $3}')
echo -e "${GREEN}✅ Chain ID: $CHAIN_ID${NC}"

# Step 3: Publish application
echo -e "\n${BLUE}📤 Step 3: Publishing application to Linera...${NC}"

CONTRACT_WASM="target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm"
SERVICE_WASM="target/wasm32-unknown-unknown/release/smart_contract_2_service.wasm"

if [ ! -f "$CONTRACT_WASM" ] || [ ! -f "$SERVICE_WASM" ]; then
    echo -e "${RED}❌ WASM files not found${NC}"
    exit 1
fi

echo "Publishing..."
PUBLISH_OUTPUT=$(linera publish-and-create \
  --bytecode "$CONTRACT_WASM" \
  --service "$SERVICE_WASM" \
  --required-application-ids [] 2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Application published${NC}"
    
    # Extract application ID
    APP_ID=$(echo "$PUBLISH_OUTPUT" | grep -oP 'Application ID: \K[a-f0-9]+' | head -1)
    
    if [ -z "$APP_ID" ]; then
        echo -e "${RED}❌ Could not extract Application ID${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Application ID: $APP_ID${NC}"
else
    echo -e "${RED}❌ Publish failed${NC}"
    echo "$PUBLISH_OUTPUT"
    exit 1
fi

# Step 4: Create .env file
echo -e "\n${BLUE}📝 Step 4: Creating .env file...${NC}"

cat > oracle-client/.env << EOF
# Linera Configuration
GRAPHQL_ENDPOINT=http://localhost:8080/graphql
CHAIN_ID=$CHAIN_ID
APPLICATION_ID=$APP_ID
OWNER_ADDRESS=$(linera wallet show | grep "Owner" | head -1 | awk '{print $2}')

# AI Engine
AI_ENGINE_URL=http://localhost:5001

# Oracle
ORACLE_PRIVATE_KEY=your-private-key-here
EOF

echo -e "${GREEN}✅ .env file created${NC}"

# Step 5: Summary
echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 Deployment Successful!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📋 Deployment Information:"
echo "  Chain ID: $CHAIN_ID"
echo "  Application ID: $APP_ID"
echo "  Contract WASM: $CONTRACT_WASM"
echo "  Service WASM: $SERVICE_WASM"
echo ""
echo "🚀 Next Steps:"
echo "  1. Start Linera service:"
echo "     linera service --port 8080"
echo ""
echo "  2. Install oracle client dependencies:"
echo "     cd oracle-client && npm install"
echo ""
echo "  3. Test the integration:"
echo "     node test.js"
echo ""
echo "  4. Update .env file with your oracle private key"
echo ""
echo "📚 Documentation: ./README.md"
echo ""
