#!/bin/bash

# Smart Contract 2.0 - Start All Services Script
# This script starts all required services for testing Linera integration

set -e

echo "🚀 Starting Smart Contract 2.0 Services..."
echo "=========================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if required commands exist
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 is not installed${NC}"
        exit 1
    fi
}

echo -e "${BLUE}Checking dependencies...${NC}"
check_command python3
check_command node
check_command linera

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Create logs directory
mkdir -p logs

echo ""
echo -e "${BLUE}📦 Installing Python dependencies...${NC}"
cd ai-engine
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate
pip install -q -r requirements.txt
deactivate
cd ..

echo -e "${GREEN}✅ Python dependencies installed${NC}"

echo ""
echo -e "${BLUE}📦 Installing Node.js dependencies...${NC}"
cd linera-integration/oracle-client
npm install --silent
cd ../..

echo -e "${GREEN}✅ Node.js dependencies installed${NC}"

echo ""
echo -e "${YELLOW}🔧 Starting Linera local network...${NC}"
cd linera-integration
linera net up > ../logs/linera-net.log 2>&1 &
LINERA_PID=$!
echo "Linera network PID: $LINERA_PID"
sleep 3
cd ..

echo -e "${GREEN}✅ Linera network started${NC}"

echo ""
echo -e "${YELLOW}🤖 Starting AI Engine (port 5001)...${NC}"
cd ai-engine
source venv/bin/activate
python3 main.py > ../logs/ai-engine.log 2>&1 &
AI_PID=$!
echo "AI Engine PID: $AI_PID"
deactivate
cd ..

echo -e "${GREEN}✅ AI Engine started${NC}"

echo ""
echo -e "${YELLOW}🔗 Starting Oracle Service (port 3002)...${NC}"
cd linera-integration/oracle-client
node linera-oracle.js > ../../logs/oracle.log 2>&1 &
ORACLE_PID=$!
echo "Oracle Service PID: $ORACLE_PID"
cd ../..

echo -e "${GREEN}✅ Oracle Service started${NC}"

echo ""
echo -e "${YELLOW}🌐 Starting Frontend Server (port 8080)...${NC}"
cd frontend
python3 -m http.server 8080 > ../logs/frontend.log 2>&1 &
FRONTEND_PID=$!
echo "Frontend Server PID: $FRONTEND_PID"
cd ..

echo -e "${GREEN}✅ Frontend Server started${NC}"

# Save PIDs to file for cleanup
echo "$LINERA_PID" > logs/pids.txt
echo "$AI_PID" >> logs/pids.txt
echo "$ORACLE_PID" >> logs/pids.txt
echo "$FRONTEND_PID" >> logs/pids.txt

echo ""
echo -e "${BLUE}⏳ Waiting for services to be ready...${NC}"
sleep 5

echo ""
echo "=========================================="
echo -e "${GREEN}✅ All services are running!${NC}"
echo "=========================================="
echo ""
echo "📊 Service Status:"
echo "  • Linera Network: http://localhost:8080 (GraphQL)"
echo "  • AI Engine:      http://localhost:5001"
echo "  • Oracle Service: http://localhost:3002"
echo "  • Frontend:       http://localhost:8080"
echo ""
echo "🧪 Test Pages:"
echo "  • Service Test:   http://localhost:8080/test.html"
echo "  • Main Interface: http://localhost:8080/index.html"
echo ""
echo "📝 Logs are saved in: logs/"
echo ""
echo "🛑 To stop all services, run:"
echo "   ./scripts/stop-all-services.sh"
echo ""

# Open browser automatically (macOS)
echo -e "${BLUE}🌐 Opening test page in browser...${NC}"
sleep 2
open http://localhost:8080/test.html

echo ""
echo -e "${YELLOW}Press Ctrl+C to view logs or run stop script to shutdown${NC}"
