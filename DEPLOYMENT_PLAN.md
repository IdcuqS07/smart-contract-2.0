# 📋 Deployment Plan - Linera Testnet Conway

Complete step-by-step plan untuk deploy Smart Contract 2.0 ke Linera Testnet Conway.

---

## 🎯 Objective

Deploy Smart Contract 2.0 sebagai **live demo on Linera Testnet Conway** dengan:
- ✅ Smart contract deployed on-chain
- ✅ Frontend accessible via web
- ✅ Wallet integration working
- ✅ AI predictions on blockchain
- ✅ Complete documentation

---

## 📊 Current Status

### ✅ Completed
- [x] Smart contract code (Rust)
- [x] AI Engine (3 models)
- [x] Oracle Service
- [x] Frontend interface
- [x] Local testing successful
- [x] GitHub repository
- [x] Documentation

### ⏳ To Do
- [ ] Install Linera CLI
- [ ] Create testnet wallet
- [ ] Deploy contract to testnet
- [ ] Integrate Linera Web Client
- [ ] Deploy frontend to Vercel
- [ ] Test live demo
- [ ] Submit for review

---

## 🚀 Deployment Steps

### Phase 1: Setup Environment (30 mins)

**Step 1.1: Install Linera CLI**
```bash
curl -sSf https://get.linera.io | bash
source ~/.bashrc
linera --version
```

**Step 1.2: Install Rust & WASM target**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown
```

**Step 1.3: Install Vercel CLI**
```bash
npm install -g vercel
vercel login
```

**Verification:**
```bash
linera --version    # Should show version
rustc --version     # Should show version
vercel --version    # Should show version
```

---

### Phase 2: Testnet Wallet Setup (15 mins)

**Step 2.1: Create Wallet**
```bash
linera wallet init --testnet
```

**Step 2.2: View Wallet**
```bash
linera wallet show
```

**Step 2.3: Request Testnet Tokens**
```bash
linera faucet request
```

**Step 2.4: Verify Balance**
```bash
linera wallet show
# Should show balance > 0
```

**Save wallet info:**
- Wallet address: `<your-address>`
- Chain ID: `<your-chain-id>`

---

### Phase 3: Build & Deploy Contract (45 mins)

**Step 3.1: Build Contract**
```bash
cd linera-integration
cargo build --release --target wasm32-unknown-unknown
```

**Step 3.2: Verify Build**
```bash
ls target/wasm32-unknown-unknown/release/*.wasm
# Should show .wasm files
```

**Step 3.3: Deploy to Testnet**
```bash
linera project publish-and-create \
  --testnet \
  --name "smart-contract-2.0"
```

**Step 3.4: Save Application ID**
```bash
# From deployment output, save:
# Application ID: e476187f6ddfeb9d588c7b45d3df334d5501d6499b3f9ad5595cae86cce16a65010000000000000000000000
```

**Step 3.5: Verify Deployment**
```bash
linera query-application <app-id> --testnet
```

---

### Phase 4: Configure Frontend (30 mins)

**Step 4.1: Update Demo Page**

Edit `frontend/linera-web-demo.html`:
```javascript
const TESTNET_CONFIG = {
    rpcUrl: 'https://rpc.testnet-conway.linera.net',
    chainId: 'testnet-conway-1',
    applicationId: '<YOUR-APP-ID-HERE>' // Paste from Step 3.4
};
```

**Step 4.2: Update Vercel Config**

Edit `vercel.json`:
```json
{
  "env": {
    "LINERA_RPC_URL": "https://rpc.testnet-conway.linera.net",
    "LINERA_APP_ID": "<YOUR-APP-ID-HERE>",
    "LINERA_NETWORK": "testnet-conway"
  }
}
```

**Step 4.3: Test Locally**
```bash
cd frontend
python3 -m http.server 8080
# Open: http://localhost:8080/linera-web-demo.html
```

---

### Phase 5: Deploy Frontend (20 mins)

**Step 5.1: Prepare for Deployment**
```bash
cd ..  # Back to project root
git add -A
git commit -m "feat: add Linera Testnet Conway integration"
git push origin main
```

**Step 5.2: Deploy to Vercel**
```bash
vercel --prod
```

**Step 5.3: Configure Environment Variables**

In Vercel Dashboard:
1. Go to Project Settings
2. Environment Variables
3. Add:
   - `LINERA_RPC_URL`: `https://rpc.testnet-conway.linera.net`
   - `LINERA_APP_ID`: `<your-app-id>`
   - `LINERA_NETWORK`: `testnet-conway`

**Step 5.4: Redeploy**
```bash
vercel --prod
```

**Step 5.5: Get Live URL**
```bash
# Output will show:
# Production: https://smart-contract-2-0.vercel.app
```

---

### Phase 6: Testing (30 mins)

**Step 6.1: Test Wallet Connection**
1. Open: https://smart-contract-2-0.vercel.app/demo
2. Click "Connect Wallet"
3. Verify connection successful

**Step 6.2: Test Contract Creation**
1. Select model type
2. Set threshold
3. Click "Create Contract"
4. Verify transaction hash

**Step 6.3: Test Prediction**
1. Enter contract ID
2. Input test data
3. Click "Request Prediction"
4. Verify result on blockchain

**Step 6.4: Test Transaction History**
1. View recent transactions
2. Verify transaction details
3. Check timestamps

**Step 6.5: Cross-browser Testing**
- Test on Chrome
- Test on Firefox
- Test on Safari
- Test on mobile

---

### Phase 7: Documentation (20 mins)

**Step 7.1: Update README**

Add to `README.md`:
```markdown
## 🌐 Live Demo

**URL:** https://smart-contract-2-0.vercel.app/demo

**Network:** Linera Testnet Conway

**Application ID:** <your-app-id>
```

**Step 7.2: Create Submission Document**

Create `SUBMISSION.md`:
```markdown
# Smart Contract 2.0 - Buildathon Submission

## Live Demo
- URL: https://smart-contract-2-0.vercel.app/demo
- Network: Linera Testnet Conway
- Application ID: <your-app-id>

## Features
- 3 AI Models integrated
- Wallet connection
- Contract creation
- Prediction submission
- Transaction history

## Documentation
- Deployment Guide: TESTNET_DEPLOYMENT.md
- Live Demo Guide: LIVE_DEMO.md
- Integration Details: INTEGRATION_COMPLETE.md
```

**Step 7.3: Commit & Push**
```bash
git add -A
git commit -m "docs: add live demo documentation"
git push origin main
```

---

## ✅ Verification Checklist

### Contract Deployment
- [ ] Contract built successfully
- [ ] Deployed to Testnet Conway
- [ ] Application ID obtained
- [ ] GraphQL queries working
- [ ] Contract verified on-chain

### Frontend Deployment
- [ ] Frontend deployed to Vercel
- [ ] Live URL accessible
- [ ] Environment variables set
- [ ] HTTPS working
- [ ] No console errors

### Functionality
- [ ] Wallet connection works
- [ ] Can create contracts
- [ ] Can request predictions
- [ ] Transactions confirmed
- [ ] History displayed

### Documentation
- [ ] README updated
- [ ] Live demo guide created
- [ ] Deployment guide complete
- [ ] Submission document ready
- [ ] GitHub repository public

---

## 📊 Expected Timeline

| Phase | Duration | Status |
|-------|----------|--------|
| Phase 1: Setup | 30 mins | ⏳ Pending |
| Phase 2: Wallet | 15 mins | ⏳ Pending |
| Phase 3: Contract | 45 mins | ⏳ Pending |
| Phase 4: Frontend Config | 30 mins | ⏳ Pending |
| Phase 5: Deploy | 20 mins | ⏳ Pending |
| Phase 6: Testing | 30 mins | ⏳ Pending |
| Phase 7: Docs | 20 mins | ⏳ Pending |
| **Total** | **~3 hours** | |

---

## 🎯 Success Criteria

### Minimum Requirements
✅ Contract deployed on Testnet Conway  
✅ Live demo accessible via web  
✅ Wallet integration working  
✅ Can create contracts  
✅ Can submit predictions  

### Bonus Points
✅ Beautiful UI  
✅ Complete documentation  
✅ Multiple AI models  
✅ Transaction history  
✅ Mobile responsive  
✅ Open source  

---

## 🐛 Troubleshooting

### Issue: Linera CLI not found
```bash
# Solution
curl -sSf https://get.linera.io | bash
source ~/.bashrc
```

### Issue: Wallet creation fails
```bash
# Solution
rm -rf ~/.linera
linera wallet init --testnet
```

### Issue: Build fails
```bash
# Solution
rustup update
rustup target add wasm32-unknown-unknown
cargo clean
cargo build --release --target wasm32-unknown-unknown
```

### Issue: Deployment fails
```bash
# Solution
linera wallet show  # Check balance
linera faucet request  # Get more tokens
# Retry deployment
```

### Issue: Vercel deployment fails
```bash
# Solution
vercel --debug
# Check logs for errors
# Fix and redeploy
```

---

## 📞 Resources

### Documentation
- [Testnet Deployment Guide](TESTNET_DEPLOYMENT.md)
- [Live Demo Guide](LIVE_DEMO.md)
- [Integration Complete](INTEGRATION_COMPLETE.md)

### External Links
- Linera Docs: https://linera.dev
- Testnet Info: https://linera.dev/testnet
- Frontend Guide: https://linera.dev/developers/frontend.html

### Support
- GitHub Issues: https://github.com/IdcuqS07/smart-contract-2.0/issues
- Linera Discord: https://discord.gg/linera

---

## 🚀 Quick Start

**Ready to deploy? Run:**

```bash
# 1. Setup
./scripts/deploy-testnet.sh

# 2. Follow the prompts

# 3. Deploy frontend
vercel --prod

# 4. Test live demo
open https://smart-contract-2-0.vercel.app/demo
```

---

## 📝 Notes

- Testnet tokens are free
- Deployment is reversible
- Test thoroughly before submission
- Keep Application ID safe
- Document everything

---

**Ready to start? Begin with Phase 1! 🚀**
