#!/bin/bash

set -e

echo "🚀 Deploying Smart Contract 2.0 to Linera Testnet"
echo "=================================================="
echo ""

cd "$(dirname "$0")/.."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Step 1: Building WASM bytecode...${NC}"
cargo build --release --target wasm32-unknown-unknown

echo ""
echo -e "${BLUE}Step 2: Checking wallet...${NC}"
linera wallet show

echo ""
echo -e "${BLUE}Step 3: Publishing and creating application...${NC}"
BYTECODE_PATH="target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm"

if [ ! -f "$BYTECODE_PATH" ]; then
    echo "❌ Error: WASM file not found at $BYTECODE_PATH"
    exit 1
fi

echo "Publishing bytecode and creating application..."
OUTPUT=$(linera project publish-and-create \
    "$BYTECODE_PATH" \
    --json-argument '"owner_address"' 2>&1)

echo "$OUTPUT"

# Extract application ID from output
APP_ID=$(echo "$OUTPUT" | grep -o 'e476187f6ddfeb9d588c7b45d3df334d5501d6499b3f9ad5595cae86cce16a65[0-9a-f]*' | head -1)

if [ -z "$APP_ID" ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Could not auto-extract Application ID${NC}"
    echo "Please check the output above for the Application ID"
else
    echo ""
    echo -e "${GREEN}✅ Application deployed successfully!${NC}"
    echo ""
    echo "Application ID: $APP_ID"
    
    # Save to file
    echo "$APP_ID" > .app-id
    echo "Saved to .app-id file"
fi

echo ""
echo -e "${BLUE}Step 4: Starting GraphQL service...${NC}"
echo "Run this command in a separate terminal:"
echo ""
echo -e "${GREEN}linera service --port 8080${NC}"
echo ""

echo -e "${BLUE}Step 5: Test queries:${NC}"
echo ""
echo "# Get all contracts:"
echo "curl -X POST http://localhost:8080/graphql \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"query\": \"{ contracts { id creator contractType threshold isActive } }\"}'"
echo ""

echo -e "${GREEN}🎉 Deployment complete!${NC}"
