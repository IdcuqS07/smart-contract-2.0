# 🚀 Production Quick Reference

**Smart Contract 2.0 - Production Commands & URLs**

---

## 🌐 URLs

```
Frontend:  https://smartcontract2-linera-eight.vercel.app/
API Base:  http://143.198.205.88
VPS IP:    143.198.205.88
SSH User:  smartcontract
```

---

## 🔍 Health Checks

```bash
# Oracle Service
curl http://143.198.205.88/api/oracle/health

# AI Engine
curl http://143.198.205.88/api/ai/health
```

---

## 📊 Metrics

```bash
# Oracle Metrics
curl http://143.198.205.88/api/oracle/metrics | jq .

# AI Metrics
curl http://143.198.205.88/api/ai/metrics | jq .
```

---

## 🔧 SSH Commands

```bash
# Connect to VPS
ssh smartcontract@143.198.205.88

# Check service status
pm2 status

# View logs
pm2 logs

# Restart services
pm2 restart all

# Stop services
pm2 stop all

# Start services
pm2 start all
```

---

## 📝 View Logs

```bash
# All logs
pm2 logs

# Oracle only
pm2 logs oracle-service

# AI Engine only
pm2 logs ai-engine

# Last 100 lines
pm2 logs --lines 100

# Follow logs (real-time)
pm2 logs --follow
```

---

## 🔄 Deploy Updates

```bash
# Deploy production updates
./scripts/deploy-production.sh

# Deploy oracle only
./scripts/update-oracle-vps.sh

# Deploy frontend
./scripts/update-frontend-vps.sh
```

---

## 🧪 Quick Tests

```bash
# Create contract
curl -X POST http://143.198.205.88/api/oracle/request \
  -H "Content-Type: application/json" \
  -d '{"contractType":"insurance","threshold":50000}'

# Get all contracts
curl http://143.198.205.88/api/oracle/contracts

# AI Prediction
curl -X POST http://143.198.205.88/api/ai/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type":"price_prediction","data":{"prices":[50000,51000,49500,52000,51500]}}'
```

---

## 🚨 Troubleshooting

### Service Down
```bash
ssh smartcontract@143.198.205.88
pm2 restart all
pm2 logs
```

### High Memory
```bash
pm2 restart all
pm2 monit
```

### Check Nginx
```bash
sudo systemctl status nginx
sudo nginx -t
```

### View System Resources
```bash
htop
df -h
free -h
```

---

## 📈 Performance Monitoring

```bash
# PM2 monitoring dashboard
pm2 monit

# System resources
htop

# Disk usage
df -h

# Memory usage
free -h

# Network connections
netstat -tulpn | grep LISTEN
```

---

## 🔒 Security

### Rate Limits
- 100 requests per 15 minutes per IP
- HTTP 429 response when exceeded

### Firewall Status
```bash
sudo ufw status
```

### Check Open Ports
```bash
sudo netstat -tulpn | grep LISTEN
```

---

## 📚 Documentation

- `API_ENDPOINTS.md` - API reference
- `PRODUCTION_READY.md` - Production status
- `PRODUCTION_CHECKLIST.md` - Requirements
- `WEBSITE_TESTING_GUIDE.md` - Testing guide

---

## 🎯 Common Tasks

### Restart Everything
```bash
ssh smartcontract@143.198.205.88 'pm2 restart all'
```

### Check if Services Running
```bash
curl -s http://143.198.205.88/api/oracle/health && echo "✅ Oracle OK"
curl -s http://143.198.205.88/api/ai/health && echo "✅ AI OK"
```

### View Recent Errors
```bash
ssh smartcontract@143.198.205.88 'pm2 logs --err --lines 50'
```

### Clear Logs
```bash
ssh smartcontract@143.198.205.88 'pm2 flush'
```

---

## 🔥 Emergency Commands

### Service Not Responding
```bash
ssh smartcontract@143.198.205.88
pm2 delete all
pm2 start /home/smartcontract/smart-contract-2.0/ai-engine/main.py --name ai-engine --interpreter python3
pm2 start /home/smartcontract/smart-contract-2.0/oracle-service/server.js --name oracle-service
pm2 save
```

### Nginx Issues
```bash
sudo systemctl restart nginx
sudo nginx -t
```

### Out of Memory
```bash
pm2 restart all
# Or reboot VPS
sudo reboot
```

---

## 📞 Quick Contact

**VPS**: 143.198.205.88  
**User**: smartcontract  
**Services**: PM2 managed  
**Proxy**: Nginx  
**Ports**: 80 (HTTP), 22 (SSH)

---

**Keep this handy for quick production operations!** 🚀
