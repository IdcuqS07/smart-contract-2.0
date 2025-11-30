#!/bin/bash

# Smart Contract 2.0 - Start Services (Development Mode)
# This script starts AI Engine, Oracle, and Frontend for testing
# Note: Linera network needs to be started separately

set -e

echo "🚀 Starting Smart Contract 2.0 Services (Dev Mode)..."
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

# Create logs directory
mkdir -p logs

echo ""
echo -e "${BLUE}📦 Installing Python dependencies...${NC}"
cd ai-engine
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate
pip install -q -r requirements.txt 2>&1 | grep -v "already satisfied" || true
deactivate
cd ..

echo -e "${GREEN}✅ Python dependencies ready${NC}"

echo ""
echo -e "${BLUE}📦 Checking Node.js dependencies...${NC}"
if [ -d "linera-integration/oracle-client/node_modules" ]; then
    echo -e "${GREEN}✅ Node.js dependencies ready${NC}"
else
    echo -e "${YELLOW}Installing Node.js dependencies...${NC}"
    cd linera-integration/oracle-client
    npm install --silent
    cd ../..
    echo -e "${GREEN}✅ Node.js dependencies installed${NC}"
fi

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
node server.js > ../../logs/oracle.log 2>&1 &
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
echo "$AI_PID" > logs/pids.txt
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
echo "  • AI Engine:      http://localhost:5001"
echo "  • Oracle Service: http://localhost:3002"
echo "  • Frontend:       http://localhost:8080"
echo ""
echo "🧪 Test Pages:"
echo "  • Service Test:   http://localhost:8080/test.html"
echo "  • Main Interface: http://localhost:8080/index.html"
echo ""
echo "📝 Logs are saved in: logs/"
echo "  • AI Engine:  logs/ai-engine.log"
echo "  • Oracle:     logs/oracle.log"
echo "  • Frontend:   logs/frontend.log"
echo ""
echo "🛑 To stop all services, run:"
echo "   ./scripts/stop-all-services.sh"
echo ""

# Open browser automatically (macOS)
echo -e "${BLUE}🌐 Opening test page in browser...${NC}"
sleep 2
open http://localhost:8080/test.html

echo ""
echo -e "${YELLOW}Services are running in background${NC}"
echo -e "${YELLOW}Check logs/ directory for service output${NC}"
