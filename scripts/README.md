# 📜 Scripts Directory

Automated scripts untuk mengelola Smart Contract 2.0 services.

---

## 🚀 Available Scripts

### 1. `start-services-dev.sh`
**Purpose:** Start semua services untuk development

**What it does:**
- ✅ Install Python dependencies (AI Engine)
- ✅ Install Node.js dependencies (Oracle)
- ✅ Start AI Engine (port 5001)
- ✅ Start Oracle Service (port 3002)
- ✅ Start Frontend Server (port 8080)
- ✅ Open browser test page automatically
- ✅ Save process IDs for cleanup

**Usage:**
```bash
./scripts/start-services-dev.sh
```

**Output:**
```
🚀 Starting Smart Contract 2.0 Services (Dev Mode)...
========================================
📦 Installing Python dependencies...
✅ Python dependencies ready
📦 Checking Node.js dependencies...
✅ Node.js dependencies ready
🤖 Starting AI Engine (port 5001)...
✅ AI Engine started
🔗 Starting Oracle Service (port 3002)...
✅ Oracle Service started
🌐 Starting Frontend Server (port 8080)...
✅ Frontend Server started
========================================
✅ All services are running!
```

---

### 2. `stop-all-services.sh`
**Purpose:** Stop semua running services

**What it does:**
- ✅ Kill all service processes
- ✅ Clean up ports (5001, 3002, 8080)
- ✅ Stop Linera network (if running)
- ✅ Remove PID file

**Usage:**
```bash
./scripts/stop-all-services.sh
```

**Output:**
```
🛑 Stopping Smart Contract 2.0 Services...
========================================
Stopping services...
Killing process 12345...
Killing process 12346...
Killing process 12347...
Cleaning up ports...
Stopping Linera network...
========================================
✅ All services stopped
```

---

### 3. `test-integration.sh`
**Purpose:** Test integrasi semua services

**What it does:**
- ✅ Test AI Engine health
- ✅ Test AI Engine models endpoint
- ✅ Test Oracle Service health
- ✅ Test Frontend pages
- ✅ Test AI prediction

**Usage:**
```bash
./scripts/test-integration.sh
```

**Output:**
```
🧪 Testing Linera Integration...
========================================
1. Testing AI Engine
   Testing AI Engine Health... ✅ OK
   Testing AI Engine Models... ✅ OK
2. Testing Oracle Service
   Testing Oracle Health... ✅ OK
3. Testing Frontend
   Testing Frontend Test Page... ✅ OK
   Testing Frontend Main Page... ✅ OK
4. Testing AI Prediction
   Requesting price prediction... ✅ OK
========================================
✅ Integration Test Complete
```

---

### 4. `start-all-services.sh`
**Purpose:** Start semua services INCLUDING Linera network

**Requirements:**
- Linera CLI installed
- All dependencies installed

**What it does:**
- ✅ Check dependencies (python3, node, linera)
- ✅ Install Python & Node.js dependencies
- ✅ Start Linera local network
- ✅ Start AI Engine
- ✅ Start Oracle Service
- ✅ Start Frontend Server
- ✅ Open browser test page

**Usage:**
```bash
./scripts/start-all-services.sh
```

**Note:** Requires Linera CLI. If not installed, use `start-services-dev.sh` instead.

---

## 📁 Logs

All service logs are saved in `logs/` directory:

```
logs/
├── ai-engine.log      # AI Engine output
├── oracle.log         # Oracle Service output
├── frontend.log       # Frontend server output
└── pids.txt          # Process IDs (auto-generated)
```

**View logs:**
```bash
# Real-time
tail -f logs/ai-engine.log
tail -f logs/oracle.log

# Full log
cat logs/ai-engine.log
cat logs/oracle.log
```

---

## 🔧 Troubleshooting

### Problem: Script permission denied
```bash
chmod +x scripts/*.sh
```

### Problem: Port already in use
```bash
# Kill specific port
lsof -ti:5001 | xargs kill -9  # AI Engine
lsof -ti:3002 | xargs kill -9  # Oracle
lsof -ti:8080 | xargs kill -9  # Frontend

# Or use stop script
./scripts/stop-all-services.sh
```

### Problem: Services not starting
```bash
# Check logs
cat logs/ai-engine.log
cat logs/oracle.log

# Clean restart
./scripts/stop-all-services.sh
rm -rf logs/*
./scripts/start-services-dev.sh
```

### Problem: Dependencies not installed
```bash
# Python
cd ai-engine
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Node.js
cd linera-integration/oracle-client
rm -rf node_modules
npm install
```

---

## 🎯 Workflow

### Development Workflow
```bash
# 1. Start services
./scripts/start-services-dev.sh

# 2. Develop & test
# Open http://localhost:8080/test-advanced.html

# 3. Check logs if needed
tail -f logs/ai-engine.log

# 4. Stop when done
./scripts/stop-all-services.sh
```

### Testing Workflow
```bash
# 1. Start services
./scripts/start-services-dev.sh

# 2. Run integration tests
./scripts/test-integration.sh

# 3. Manual testing via browser
open http://localhost:8080/test-advanced.html

# 4. Stop services
./scripts/stop-all-services.sh
```

---

## 📚 Related Documentation

- **QUICK_TEST.md** - Quick testing guide
- **BROWSER_TEST_GUIDE.md** - Complete browser testing
- **INTEGRATION_COMPLETE.md** - Integration status
- **TROUBLESHOOTING.md** - Common issues & solutions

---

## 💡 Tips

1. **Always use `stop-all-services.sh` before restarting**
   - Prevents port conflicts
   - Cleans up zombie processes

2. **Check logs when services fail**
   - Logs are in `logs/` directory
   - Use `tail -f` for real-time monitoring

3. **Use `test-integration.sh` after changes**
   - Verifies all services working
   - Quick health check

4. **Browser test page is your friend**
   - http://localhost:8080/test-advanced.html
   - Interactive testing
   - Beautiful UI

---

**Happy Scripting! 🚀**
