# 🚀 Quick Start Guide

## Backend Setup (Local Development)

### 1. Install Dependencies
```bash
cd "/Users/idcuq/Documents/Smart Contract 2.0"
npm install
```

### 2. Start Backend Server
```bash
npm start
```

Server akan jalan di: **http://localhost:3000**

### 3. Test API
```bash
# Health check
curl http://localhost:3000/health

# Get BTC prediction
curl -X POST http://localhost:3000/api/predict \
  -H "Content-Type: application/json" \
  -d '{"symbol":"BTC","timeframe":"1h"}'

# Auto-trade
curl -X POST http://localhost:3000/api/auto-trade \
  -H "Content-Type: application/json" \
  -d '{"symbol":"BTC","amount":100,"riskLevel":"MEDIUM"}'
```

## Frontend

### Open in Browser
- **Homepage**: `file:///Users/idcuq/Documents/Smart%20Contract%202.0/frontend/index.html`
- **Dashboard**: `file:///Users/idcuq/Documents/Smart%20Contract%202.0/frontend/dashboard.html`

### Connect to Backend
Edit `frontend/index.html` dan `frontend/dashboard.html`:
```javascript
const API_URL = 'http://localhost:3000'; // Sudah di-set
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| POST | `/api/predict` | Get AI prediction |
| POST | `/api/auto-trade` | Execute auto-trade |
| GET | `/api/contracts` | Get all contracts |
| GET | `/api/price/:symbol` | Get current price |
| GET | `/api/history/:symbol` | Get price history |

## Features

### ✅ Backend (Real)
- AI prediction dengan Binance API
- Smart contract executor
- Risk management
- Real-time price data

### ✅ Frontend
- Professional UI/UX
- Dashboard dengan chart
- Transaction history
- Auto-trade interface

## Next Steps

1. **Test Backend**: Jalankan `npm start` dan test API
2. **Open Dashboard**: Buka `dashboard.html` di browser
3. **Try Auto-Trade**: Klik "Start Auto-Trade" di homepage
4. **View History**: Lihat transaction history di dashboard

## Troubleshooting

**Port 3000 sudah dipakai?**
```bash
# Ganti port di backend/server.js
const PORT = process.env.PORT || 3001;
```

**CORS error?**
Backend sudah setup CORS, pastikan server jalan.

**Binance API error?**
API public, tidak perlu API key. Check internet connection.
