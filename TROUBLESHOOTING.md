# 🔧 Troubleshooting Guide

## ❌ Masalah: Hanya Port 8080 yang Bisa Terbuka

### 🔍 Diagnosis

Buka **http://localhost:8080/test.html** untuk test koneksi semua service.

### ✅ Solusi

#### 1. Check Service Status

```bash
# Check AI Engine (port 5001)
curl http://localhost:5001/health

# Check Oracle (port 3002)
curl http://localhost:3002/health

# Check Frontend (port 8080)
curl http://localhost:8080
```

#### 2. Restart Services Jika Perlu

```bash
# Stop semua (Ctrl+C di setiap terminal)

# Start ulang satu per satu:

# Terminal 1: Blockchain
npm run node

# Terminal 2: AI Engine
./venv/bin/python ai-engine/main.py

# Terminal 3: Oracle
node oracle-service/server.js

# Terminal 4: Frontend
cd frontend && python3 -m http.server 8080
```

#### 3. Check Port Conflicts

```bash
# Check port yang digunakan
lsof -i :5001
lsof -i :3002
lsof -i :8080
lsof -i :8545
```

Jika ada konflik, kill process atau ganti port.

---

## 🌐 Browser Tidak Bisa Connect ke Backend

### Gejala:
- Frontend terbuka di http://localhost:8080
- Tapi request ke AI/Oracle gagal
- Error di browser console: "Failed to fetch" atau "CORS"

### Solusi:

#### Option 1: Gunakan Test Page
Buka: **http://localhost:8080/test.html**

Test page akan menunjukkan service mana yang bermasalah.

#### Option 2: Check Browser Console
1. Buka browser (Chrome/Firefox)
2. Tekan F12 (Developer Tools)
3. Tab "Console"
4. Lihat error message

**Common Errors:**

**"Failed to fetch"**
→ Service tidak berjalan atau port salah

**"CORS policy"**
→ Seharusnya tidak terjadi di localhost, tapi jika terjadi:
- Restart browser
- Atau gunakan browser lain
- Atau disable CORS extension jika ada

**"net::ERR_CONNECTION_REFUSED"**
→ Service tidak berjalan di port tersebut

#### Option 3: Test via cURL (Terminal)

```bash
# Test AI
curl -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type":"price_prediction","data":{"prices":[100,105,110]}}'

# Test Oracle
curl -X POST http://localhost:3002/request-prediction \
  -H "Content-Type: application/json" \
  -d '{"contractId":1,"modelType":"price_prediction","data":{"prices":[100,105,110]}}'
```

Jika cURL berhasil tapi browser gagal → masalah di browser/CORS.

---

## 🐍 Python/AI Engine Issues

### "ModuleNotFoundError: No module named 'flask'"

```bash
# Install dependencies
pip3 install flask numpy requests

# Atau gunakan virtual environment
python3 -m venv venv
./venv/bin/pip install flask numpy requests
./venv/bin/python ai-engine/main.py
```

### "Port 5000 already in use"

Port 5000 digunakan oleh AirPlay di macOS.

**Solusi:** Sudah diganti ke port 5001 di kode.

Jika masih error:
```bash
# Check apa yang menggunakan port
lsof -i :5001

# Kill process jika perlu
kill -9 <PID>
```

---

## 🔗 Oracle Service Issues

### "Port 3002 already in use"

```bash
# Check process
lsof -i :3002

# Kill jika perlu
kill -9 <PID>

# Atau ganti port di oracle-service/server.js
# Line: const PORT = process.env.PORT || 3003;
```

### "Cannot find module 'ethers'"

```bash
cd oracle-service
npm install
```

---

## ⛓️ Blockchain Issues

### "Error: could not detect network"

Blockchain node tidak berjalan.

```bash
# Start Hardhat node
npm run node
```

### "Contract not active"

Contract belum dibuat.

```bash
# Create contract
npx hardhat run scripts/create-contract.js --network localhost
```

---

## 🖥️ Frontend Issues

### Halaman Blank/Tidak Muncul

```bash
# Check apakah server berjalan
curl http://localhost:8080

# Restart frontend server
cd frontend
python3 -m http.server 8080
```

### JavaScript Error di Console

1. Hard refresh: Ctrl+Shift+R (Windows) atau Cmd+Shift+R (Mac)
2. Clear cache
3. Check browser console untuk detail error

---

## 🚀 Quick Fix: Restart Everything

```bash
# 1. Stop semua (Ctrl+C di setiap terminal)

# 2. Kill semua process
pkill -f "hardhat node"
pkill -f "python.*ai-engine"
pkill -f "node.*oracle"
pkill -f "http.server"

# 3. Start ulang
npm run node &
./venv/bin/python ai-engine/main.py &
node oracle-service/server.js &
cd frontend && python3 -m http.server 8080
```

---

## 📞 Still Having Issues?

1. **Check Logs**: Lihat output di setiap terminal
2. **Test Page**: http://localhost:8080/test.html
3. **Browser Console**: F12 → Console tab
4. **cURL Test**: Test via terminal untuk isolate masalah

### Debug Checklist:

- [ ] Semua dependencies installed? (`npm install`, `pip install`)
- [ ] Semua services running? (4 terminals)
- [ ] Port tidak konflik? (`lsof -i :PORT`)
- [ ] Browser console ada error? (F12)
- [ ] cURL test berhasil?
- [ ] Test page menunjukkan apa?

---

## 💡 Alternative: Deploy ke Vercel

Jika masalah lokal terlalu kompleks, deploy saja ke Vercel:

```bash
vercel --prod
```

Semua akan berjalan di cloud tanpa perlu setup lokal! 🚀

Lihat: **[VERCEL_READY.md](VERCEL_READY.md)**
