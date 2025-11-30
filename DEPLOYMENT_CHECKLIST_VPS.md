# ✅ Deployment Checklist - VPS 143.198.205.88

## 📋 Pre-Deployment

- [ ] VPS accessible via SSH (143.198.205.88)
- [ ] Repository pushed to GitHub
- [ ] All code tested locally
- [ ] Environment variables prepared

---

## 🚀 Backend Deployment (VPS)

### Step 1: Access VPS
```bash
ssh root@143.198.205.88
```
- [ ] Successfully connected to VPS

### Step 2: Setup User
```bash
adduser smartcontract
usermod -aG sudo smartcontract
su - smartcontract
```
- [ ] User created and switched

### Step 3: Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/smart-contract-2.0.git
cd smart-contract-2.0
```
- [ ] Repository cloned

### Step 4: Run Deployment Script
```bash
chmod +x scripts/deploy-to-vps.sh
./scripts/deploy-to-vps.sh
```
- [ ] Script executed successfully
- [ ] All dependencies installed
- [ ] Linera SDK installed
- [ ] AI Engine setup complete
- [ ] Oracle Service setup complete
- [ ] PM2 services started
- [ ] Nginx configured

### Step 5: Verify Backend
```bash
pm2 status
```
- [ ] ai-engine: online
- [ ] oracle-service: online
- [ ] linera-service: running

```bash
curl http://143.198.205.88/api/ai/health
curl http://143.198.205.88/api/oracle/health
curl http://143.198.205.88/graphql
```
- [ ] AI Engine responding
- [ ] Oracle Service responding
- [ ] GraphQL responding

---

## 🌐 Frontend Deployment (Vercel)

### Step 1: Update Frontend Config
```bash
# On local machine
cd smart-contract-2.0
chmod +x scripts/update-frontend-vps.sh
./scripts/update-frontend-vps.sh
```
- [ ] Frontend config updated
- [ ] Changes committed to Git
- [ ] Changes pushed to GitHub

### Step 2: Deploy to Vercel
```bash
cd frontend
vercel --prod
```
- [ ] Deployed to Vercel
- [ ] Deployment successful

### Step 3: Verify Frontend
Open: https://smartcontract2-linera-eight.vercel.app/

- [ ] Page loads correctly
- [ ] Status shows "✅ LIVE" for all services
- [ ] AI Engine status: ✅ LIVE
- [ ] Oracle Service status: ✅ LIVE
- [ ] GraphQL Service status: ✅ LIVE
- [ ] Smart Contract status: ✅ LIVE

---

## 🧪 Functional Testing

### Test AI Prediction
- [ ] Enter symbol (e.g., BTC)
- [ ] Select timeframe
- [ ] Click "Get Prediction"
- [ ] Receives prediction result
- [ ] Shows predicted price
- [ ] Shows confidence score

### Test Contract Creation
- [ ] Enter contract type
- [ ] Enter threshold value
- [ ] Click "Create Contract"
- [ ] Contract created successfully
- [ ] Receives contract ID
- [ ] Shows contract status

### Test GraphQL
```bash
curl -X POST http://143.198.205.88/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __schema { types { name } } }"}'
```
- [ ] GraphQL query works
- [ ] Returns valid response

---

## 🔒 Security Checklist

- [ ] Firewall enabled (UFW)
- [ ] Only necessary ports open (22, 80, 443)
- [ ] SSH key authentication (recommended)
- [ ] Non-root user created
- [ ] Nginx configured properly
- [ ] CORS settings correct
- [ ] Environment variables secured

---

## 📊 Performance Checklist

- [ ] All services using < 80% CPU
- [ ] Memory usage < 80%
- [ ] Disk space > 20% free
- [ ] Response times < 1 second
- [ ] No errors in logs

Check with:
```bash
pm2 monit
htop
df -h
free -m
```

---

## 🔍 Monitoring Setup

- [ ] PM2 monitoring active
- [ ] Logs accessible via `pm2 logs`
- [ ] Nginx logs accessible
- [ ] Error tracking setup (optional)
- [ ] Uptime monitoring (optional)

---

## 📝 Documentation

- [ ] README.md updated with VPS info
- [ ] API endpoints documented
- [ ] Deployment process documented
- [ ] Troubleshooting guide available

---

## 🎯 Post-Deployment

### Immediate
- [ ] Test all endpoints
- [ ] Verify all features working
- [ ] Check logs for errors
- [ ] Monitor resource usage

### Within 24 Hours
- [ ] Monitor uptime
- [ ] Check for any errors
- [ ] Verify performance
- [ ] Test from different locations

### Within 1 Week
- [ ] Setup SSL certificate (Let's Encrypt)
- [ ] Configure custom domain (optional)
- [ ] Setup automated backups
- [ ] Configure monitoring alerts

---

## 🆘 Emergency Contacts

### Restart Services
```bash
ssh root@143.198.205.88
pm2 restart all
```

### Check Logs
```bash
pm2 logs
pm2 logs ai-engine
pm2 logs oracle-service
sudo journalctl -u nginx
```

### Rollback
```bash
cd ~/smart-contract-2.0
git pull
pm2 restart all
```

---

## ✅ Final Verification

Application is fully live when ALL of these are true:

- ✅ VPS backend accessible from internet
- ✅ Frontend deployed on Vercel
- ✅ Frontend connects to VPS backend
- ✅ AI predictions working
- ✅ Contract creation working
- ✅ GraphQL queries working
- ✅ All status indicators show "LIVE"
- ✅ No errors in logs
- ✅ Response times acceptable
- ✅ Can access from different devices/networks

---

## 🎉 Success!

When all checkboxes are checked, your application is:

**FULLY LIVE AND OPERATIONAL!** 🚀

---

## 📞 Support Resources

- **DEPLOY_NOW.md** - Quick deploy guide
- **DEPLOY_TO_MY_VPS.md** - VPS-specific instructions
- **VPS_DEPLOYMENT_GUIDE.md** - Complete guide
- **TROUBLESHOOTING.md** - Common issues
- **PM2 Docs**: https://pm2.keymetrics.io/
- **Nginx Docs**: https://nginx.org/en/docs/

---

**Print this checklist and check off items as you complete them!** ✅
