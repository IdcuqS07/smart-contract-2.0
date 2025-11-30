#!/bin/bash

# Smart Contract 2.0 - Integration Test Script
# This script tests the full integration with Linera

set -e

echo "🧪 Testing Linera Integration..."
echo "=========================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Test function
test_service() {
    local name=$1
    local url=$2
    
    echo -n "Testing $name... "
    
    if curl -s -f -o /dev/null "$url"; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        return 1
    fi
}

echo ""
echo -e "${BLUE}1. Testing AI Engine${NC}"
test_service "AI Engine Health" "http://localhost:5001/health"
test_service "AI Engine Models" "http://localhost:5001/models"

echo ""
echo -e "${BLUE}2. Testing Oracle Service${NC}"
test_service "Oracle Health" "http://localhost:3002/health"

echo ""
echo -e "${BLUE}3. Testing Frontend${NC}"
test_service "Frontend Test Page" "http://localhost:8080/test.html"
test_service "Frontend Main Page" "http://localhost:8080/index.html"

echo ""
echo -e "${BLUE}4. Testing AI Prediction${NC}"
echo -n "Requesting price prediction... "
RESPONSE=$(curl -s -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type":"price_prediction","data":{"prices":[100,105,110,108,112]}}')

if echo "$RESPONSE" | grep -q "prediction"; then
    echo -e "${GREEN}✅ OK${NC}"
    echo "Response: $RESPONSE"
else
    echo -e "${RED}❌ FAILED${NC}"
    echo "Response: $RESPONSE"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}✅ Integration Test Complete${NC}"
echo "=========================================="
echo ""
echo "📊 Next Steps:"
echo "  1. Open http://localhost:8080/test.html to see service status"
echo "  2. Open http://localhost:8080/index.html to test full flow"
echo "  3. Create a contract and request predictions"
echo ""
