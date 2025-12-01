#!/bin/bash

# Start Full Integration - All Services
# This script starts all required services for Smart Contract 2.0

set -e

echo "🚀 Starting Smart Contract 2.0 - Full Integration"
echo "=================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Create logs directory
mkdir -p logs

# Function to check if port is in use
check_port() {
    lsof -i :$1 > /dev/null 2>&1
}

# Function to wait for service
wait_for_service() {
    local url=$1
    local name=$2
    local max_attempts=30
    local attempt=0
    
    echo -n "Waiting for $name to start..."
    while [ $attempt -lt $max_attempts ]; do
        if curl -s "$url" > /dev/null 2>&1; then
            echo -e " ${GREEN}✅${NC}"
            return 0
        fi
        echo -n "."
        sleep 1
        attempt=$((attempt + 1))
    done
    
    echo -e " ${RED}❌ Timeout${NC}"
    return 1
}

# Step 1: Start AI Engine
echo -e "\n${YELLOW}1. Starting AI Engine (Port 5001)...${NC}"

if check_port 5001; then
    echo -e "${GREEN}✅ AI Engine already running${NC}"
else
    cd "$PROJECT_ROOT/ai-engine"
    
    # Check if venv exists
    if [ ! -d "venv" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv venv
        source venv/bin/activate
        pip install -r requirements.txt
    else
        source venv/bin/activate
    fi
    
    echo "Starting AI Engine..."
    nohup python main.py > "$PROJECT_ROOT/logs/ai-engine.log" 2>&1 &
    AI_PID=$!
    echo $AI_PID > "$PROJECT_ROOT/logs/ai-engine.pid"
    
    cd "$PROJECT_ROOT"
    
    if wait_for_service "http://localhost:5001/health" "AI Engine"; then
        echo -e "${GREEN}✅ AI Engine started (PID: $AI_PID)${NC}"
    else
        echo -e "${RED}❌ Failed to start AI Engine${NC}"
        exit 1
    fi
fi

# Step 2: Start Linera Service
echo -e "\n${YELLOW}2. Starting Linera Service (Port 8080)...${NC}"

if check_port 8080; then
    echo -e "${GREEN}✅ Linera service already running${NC}"
else
    if ! command -v linera &> /dev/null; then
        echo -e "${RED}❌ Linera CLI not found!${NC}"
        echo "Please install Linera first:"
        echo "  curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera"
        echo "  chmod +x linera && sudo mv linera /usr/local/bin/"
        exit 1
    fi
    
    echo "Starting Linera service..."
    nohup linera service --port 8080 > "$PROJECT_ROOT/logs/linera.log" 2>&1 &
    LINERA_PID=$!
    echo $LINERA_PID > "$PROJECT_ROOT/logs/linera.pid"
    
    if wait_for_service "http://localhost:8080/graphql" "Linera"; then
        echo -e "${GREEN}✅ Linera service started (PID: $LINERA_PID)${NC}"
    else
        echo -e "${RED}❌ Failed to start Linera service${NC}"
        exit 1
    fi
fi

# Step 3: Start Oracle Service
echo -e "\n${YELLOW}3. Starting Oracle Service (Port 3001)...${NC}"

if check_port 3001; then
    echo -e "${GREEN}✅ Oracle service already running${NC}"
else
    cd "$PROJECT_ROOT/linera-integration/oracle-client"
    
    if [ ! -d "node_modules" ]; then
        echo "Installing dependencies..."
        npm install
    fi
    
    echo "Starting Oracle service..."
    nohup node server.js > "$PROJECT_ROOT/logs/oracle.log" 2>&1 &
    ORACLE_PID=$!
    echo $ORACLE_PID > "$PROJECT_ROOT/logs/oracle.pid"
    
    cd "$PROJECT_ROOT"
    
    if wait_for_service "http://localhost:3001/health" "Oracle"; then
        echo -e "${GREEN}✅ Oracle service started (PID: $ORACLE_PID)${NC}"
    else
        echo -e "${RED}❌ Failed to start Oracle service${NC}"
        exit 1
    fi
fi

# Summary
echo -e "\n${GREEN}=================================================="
echo "✅ All Services Started Successfully!"
echo "==================================================${NC}"
echo ""
echo "📋 Service Status:"
echo "  🤖 AI Engine:      http://localhost:5001"
echo "  ⛓️  Linera:         http://localhost:8080/graphql"
echo "  🔮 Oracle Service: http://localhost:3001"
echo ""
echo "📝 Logs:"
echo "  - AI Engine: logs/ai-engine.log"
echo "  - Linera:    logs/linera.log"
echo "  - Oracle:    logs/oracle.log"
echo ""
echo "🧪 Run Integration Tests:"
echo "  cd linera-integration/oracle-client"
echo "  node full-integration.js"
echo ""
echo "🌐 Open Frontend:"
echo "  cd frontend"
echo "  open index.html"
echo ""
echo "🛑 Stop All Services:"
echo "  ./scripts/stop-all-services.sh"
echo ""
