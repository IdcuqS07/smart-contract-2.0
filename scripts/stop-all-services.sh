#!/bin/bash

# Smart Contract 2.0 - Stop All Services Script
# This script stops all running services

set -e

echo "🛑 Stopping Smart Contract 2.0 Services..."
echo "=========================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Check if PID file exists
if [ ! -f "logs/pids.txt" ]; then
    echo -e "${YELLOW}⚠️  No running services found${NC}"
    exit 0
fi

# Read PIDs and kill processes
echo -e "${YELLOW}Stopping services...${NC}"
while IFS= read -r pid; do
    if ps -p $pid > /dev/null 2>&1; then
        echo "Killing process $pid..."
        kill $pid 2>/dev/null || true
    fi
done < logs/pids.txt

# Also kill by port (backup method)
echo ""
echo -e "${YELLOW}Cleaning up ports...${NC}"
lsof -ti:5001 | xargs kill -9 2>/dev/null || true
lsof -ti:3002 | xargs kill -9 2>/dev/null || true
lsof -ti:8080 | xargs kill -9 2>/dev/null || true

# Stop Linera network
echo ""
echo -e "${YELLOW}Stopping Linera network...${NC}"
cd linera-integration
linera net down 2>/dev/null || true
cd ..

# Remove PID file
rm -f logs/pids.txt

echo ""
echo "=========================================="
echo -e "${GREEN}✅ All services stopped${NC}"
echo "=========================================="
