#!/bin/bash

# Smart Contract 2.0 - Deploy to Linera Testnet Conway
# This script automates deployment to Linera Testnet

set -e

echo "🚀 Deploying Smart Contract 2.0 to Linera Testnet Conway"
echo "=========================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Check if Linera CLI is installed
if ! command -v linera &> /dev/null; then
    echo -e "${RED}❌ Linera CLI not found${NC}"
    echo ""
    echo "Install Linera CLI:"
    echo "  curl -sSf https://get.linera.io | bash"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Linera CLI found${NC}"
echo ""

# Check wallet
echo -e "${BLUE}📝 Checking Linera wallet...${NC}"
if ! linera wallet show &> /dev/null; then
    echo -e "${YELLOW}⚠️  No wallet found. Creating new wallet...${NC}"
    linera wallet init --testnet
    echo -e "${GREEN}✅ Wallet created${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Requesting testnet tokens...${NC}"
    linera faucet request
    echo -e "${GREEN}✅ Tokens requested${NC}"
else
    echo -e "${GREEN}✅ Wallet found${NC}"
fi

echo ""
echo -e "${BLUE}💰 Wallet Info:${NC}"
linera wallet show
echo ""

# Build contract
echo -e "${BLUE}🔨 Building contract...${NC}"
cd linera-integration

if ! cargo build --release --target wasm32-unknown-unknown; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Contract built successfully${NC}"
echo ""

# Deploy to testnet
echo -e "${BLUE}🌐 Deploying to Testnet Conway...${NC}"
echo ""

# Note: This is a template - actual deployment command may vary
echo -e "${YELLOW}⚠️  Manual deployment required${NC}"
echo ""
echo "Run the following command to deploy:"
echo ""
echo -e "${BLUE}  linera project publish-and-create --testnet --name smart-contract-2.0${NC}"
echo ""
echo "After deployment, save the Application ID and update:"
echo "  1. frontend/linera-web-demo.html (TESTNET_CONFIG.applicationId)"
echo "  2. vercel.json (LINERA_APP_ID)"
echo ""

# Create deployment info file
cat > deployment-info.txt << EOF
Linera Testnet Conway Deployment
================================

Deployment Date: $(date)
Network: Testnet Conway
RPC URL: https://rpc.testnet-conway.linera.net

Wallet Address: $(linera wallet show | grep "Owner" | head -1 | awk '{print $2}')

Next Steps:
1. Deploy contract:
   linera project publish-and-create --testnet --name smart-contract-2.0

2. Save Application ID from output

3. Update frontend configuration:
   - frontend/linera-web-demo.html
   - vercel.json

4. Deploy frontend to Vercel:
   vercel --prod

5. Test live demo

Documentation:
- TESTNET_DEPLOYMENT.md - Complete deployment guide
- https://linera.dev/developers/frontend.html
EOF

echo -e "${GREEN}✅ Deployment info saved to: deployment-info.txt${NC}"
echo ""
echo "=========================================="
echo -e "${GREEN}✅ Build Complete!${NC}"
echo "=========================================="
echo ""
echo "📚 Next Steps:"
echo "  1. Read: TESTNET_DEPLOYMENT.md"
echo "  2. Deploy contract to testnet"
echo "  3. Update frontend config"
echo "  4. Deploy to Vercel"
echo ""
