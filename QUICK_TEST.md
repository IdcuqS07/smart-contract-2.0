# ⚡ Quick Test Guide

## 🚀 Start Testing in 3 Steps

### Step 1: Start Services
```bash
./scripts/start-services-dev.sh
```
Browser akan otomatis terbuka ke test page.

### Step 2: Open Test Page
Pilih salah satu:
- **Basic:** http://localhost:8080/test.html
- **Advanced:** http://localhost:8080/test-advanced.html ⭐ Recommended

### Step 3: Click Test Buttons
Klik tombol-tombol test untuk verifikasi:
- ✅ Check All Services
- ✅ Load Models
- ✅ Run Prediction Test
- ✅ Test Oracle Integration

---

## 🛑 Stop Services
```bash
./scripts/stop-all-services.sh
```

---

## 📊 Expected Results

Jika semua berjalan dengan baik, Anda akan melihat:

```
✅ AI Engine: Connected
✅ Oracle Service: Connected
✅ Available Models: 3
✅ Prediction: Success (with confidence score)
```

---

## 🐛 Troubleshooting

**Problem:** Services tidak start
```bash
# Check logs
cat logs/ai-engine.log
cat logs/oracle.log

# Restart
./scripts/stop-all-services.sh
./scripts/start-services-dev.sh
```

**Problem:** Port already in use
```bash
lsof -ti:5001 | xargs kill -9
lsof -ti:3002 | xargs kill -9
lsof -ti:8080 | xargs kill -9
```

---

## 📚 More Info

- Full guide: `BROWSER_TEST_GUIDE.md`
- Test results: `TEST_SUCCESS.md`
- Troubleshooting: `TROUBLESHOOTING.md`
