#!/bin/bash

# Stop All Services for Smart Contract 2.0

echo "🛑 Stopping All Services..."

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOGS_DIR="$PROJECT_ROOT/logs"

# Function to stop service by PID file
stop_service() {
    local name=$1
    local pid_file="$LOGS_DIR/$2.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p $pid > /dev/null 2>&1; then
            echo "Stopping $name (PID: $pid)..."
            kill $pid
            rm "$pid_file"
            echo "✅ $name stopped"
        else
            echo "⚠️  $name not running"
            rm "$pid_file"
        fi
    else
        echo "⚠️  No PID file for $name"
    fi
}

# Stop services
stop_service "AI Engine" "ai-engine"
stop_service "Linera" "linera"
stop_service "Oracle" "oracle"

# Also kill by process name (backup)
pkill -f "python main.py" 2>/dev/null || true
pkill -f "linera service" 2>/dev/null || true
pkill -f "node server.js" 2>/dev/null || true

echo ""
echo "✅ All services stopped"
