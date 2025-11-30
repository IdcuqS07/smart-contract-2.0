# ⚡ Quick Reference Guide

## 🚀 Quick Start (5 Menit)

```bash
# 1. Start services
npm run node                           # Terminal 1
npm run deploy                         # Terminal 2
./venv/bin/python ai-engine/main.py   # Terminal 3
node oracle-service/server.js          # Terminal 4

# 2. Open browser
open http://localhost:8080
```

---

## 📝 Cheat Sheet

### Membuat Kontrak

| Field | Example | Description |
|-------|---------|-------------|
| Tipe Kontrak | `insurance` | Jenis kontrak |
| Threshold | `7000` | Nilai trigger auto-execution |

**Output:** Contract ID (catat ini!)

### Model AI

#### 📈 Price Prediction
```json
{"prices": [100, 105, 110, 108, 112]}
```
**Output:** Predicted price + confidence

#### ⚠️ Risk Analysis
```json
{
  "amount": 5000,
  "history_score": 75,
  "volatility": 0.3
}
```
**Output:** Risk score (0-100) + level (LOW/MEDIUM/HIGH)

#### 🔍 Fraud Detection
```json
{
  "amount": 10000,
  "user_history": [1000, 1200, 1100],
  "speed": 5
}
```
**Output:** Fraud score + is_fraud (true/false)

---

## 🎯 Common Use Cases

### Insurance Contract
```
Type: insurance
Threshold: 7000
Model: risk_analysis
Auto-approve if risk < 7000
```

### Trading Bot
```
Type: trading
Threshold: 120
Model: price_prediction
Auto-buy if price > 120
```

### Payment Verification
```
Type: payment
Threshold: 60
Model: fraud_detection
Block if fraud score > 60
```

---

## 🔧 Troubleshooting

| Problem | Solution |
|---------|----------|
| Failed to fetch | Hard refresh (Cmd+Shift+R) |
| Contract not active | Create contract first |
| Service not running | Check http://localhost:8080/test.html |
| Port conflict | Change port in config |

---

## 📊 Confidence Score Guide

| Score | Meaning | Action |
|-------|---------|--------|
| 90-100% | Very High | Trust completely |
| 70-89% | High | Trust with monitoring |
| 50-69% | Medium | Use with caution |
| < 50% | Low | Need more data |

---

## 🌐 URLs

| Service | URL |
|---------|-----|
| Frontend | http://localhost:8080 |
| Test Page | http://localhost:8080/test.html |
| AI Engine | http://localhost:5001 |
| Oracle | http://localhost:3002 |
| Blockchain | http://localhost:8545 |

---

## 📱 Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Hard Refresh | Cmd+Shift+R (Mac) / Ctrl+Shift+R (Win) |
| Developer Tools | F12 |
| Console | Cmd+Option+J (Mac) / Ctrl+Shift+J (Win) |

---

## 🚀 Deploy Commands

```bash
# Local
npm run node && npm run deploy

# Vercel
vercel --prod

# Sepolia Testnet
npm run deploy:sepolia
```

---

## 📚 Documentation Links

- [TUTORIAL.md](TUTORIAL.md) - Full tutorial
- [STATUS.md](STATUS.md) - Current status
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Fix issues
- [VERCEL_READY.md](VERCEL_READY.md) - Deploy guide

---

## 💡 Pro Tips

1. **Always hard refresh** after service restart
2. **Use test page** to diagnose issues
3. **Check browser console** (F12) for errors
4. **Submit to blockchain** for immutability
5. **Combine models** for better accuracy

---

## 🎓 Learning Resources

**Beginner:** Start with [TUTORIAL.md](TUTORIAL.md) Section 1-3
**Intermediate:** Read Section 4-5
**Advanced:** Explore Section 6 + [ARCHITECTURE.md](ARCHITECTURE.md)

---

**Print this page for quick reference! 📄**
