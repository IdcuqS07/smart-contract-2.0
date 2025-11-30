# 🌐 Linera Testnet Conway Deployment Guide

Complete guide untuk deploy Smart Contract 2.0 ke Linera Testnet Conway dengan live demo.

---

## 📋 Prerequisites

### 1. Install Linera CLI
```bash
curl -sSf https://get.linera.io | bash
linera --version
```

### 2. Install Dependencies
```bash
# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Node.js & npm (for frontend)
# Already installed

# Vercel CLI (for deployment)
npm install -g vercel
```

---

## 🚀 Phase 1: Deploy Contract to Testnet Conway

### Step 1: Configure Testnet Connection

Create `.linera/config.toml`:
```toml
[network]
name = "testnet-conway"
rpc_url = "https://rpc.testnet-conway.linera.net"
faucet_url = "https://faucet.testnet-conway.linera.net"

[wallet]
# Will be generated after wallet creation
```

### Step 2: Create Testnet Wallet

```bash
# Create new wallet for testnet
linera wallet init --testnet

# Get your wallet address
linera wallet show

# Request testnet tokens from faucet
linera faucet request
```

### Step 3: Build Contract

```bash
cd linera-integration

# Build the contract
cargo build --release --target wasm32-unknown-unknown

# Verify build
ls target/wasm32-unknown-unknown/release/*.wasm
```

### Step 4: Deploy to Testnet

```bash
# Deploy contract
linera project publish-and-create \
  --testnet \
  --name "smart-contract-2.0"

# Save the application ID
# Output will show: Application ID: <app-id>
```

### Step 5: Verify Deployment

```bash
# Query contract on testnet
linera query-application <app-id>

# Test GraphQL endpoint
curl https://rpc.testnet-conway.linera.net/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ application(id: \"<app-id>\") { id } }"}'
```

---

## 🌐 Phase 2: Setup Frontend with Linera Web Client

### Step 1: Install Linera Web SDK

```bash
cd frontend

# Create package.json if not exists
npm init -y

# Install Linera Web Client
npm install @linera/web-client
```

### Step 2: Configure Frontend

Update `linera-web-demo.html` with actual Testnet config:

```javascript
// Replace in linera-web-demo.html
const TESTNET_CONFIG = {
    rpcUrl: 'https://rpc.testnet-conway.linera.net',
    chainId: 'testnet-conway-1',
    applicationId: '<YOUR-APP-ID-HERE>' // From deployment
};
```

### Step 3: Test Locally

```bash
# Start local server
python3 -m http.server 8080

# Open browser
open http://localhost:8080/linera-web-demo.html
```

---

## 📦 Phase 3: Deploy Frontend to Vercel

### Step 1: Prepare for Vercel

Create `vercel.json`:
```json
{
  "version": 2,
  "builds": [
    {
      "src": "frontend/**",
      "use": "@vercel/static"
    },
    {
      "src": "api/**/*.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/api/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/frontend/$1"
    }
  ],
  "env": {
    "LINERA_RPC_URL": "https://rpc.testnet-conway.linera.net",
    "LINERA_APP_ID": "<YOUR-APP-ID>"
  }
}
```

### Step 2: Deploy to Vercel

```bash
# Login to Vercel
vercel login

# Deploy
vercel --prod

# Your live demo URL will be:
# https://smart-contract-2-0.vercel.app
```

### Step 3: Configure Environment Variables

In Vercel Dashboard:
1. Go to Project Settings
2. Environment Variables
3. Add:
   - `LINERA_RPC_URL`: https://rpc.testnet-conway.linera.net
   - `LINERA_APP_ID`: Your application ID
   - `AI_ENGINE_URL`: Your AI engine URL (if deployed separately)

---

## 🔗 Phase 4: Integrate Linera Web Client Library

### Option A: Using Linera Web Client (Recommended)

```javascript
// In linera-web-demo.html
import { LineraClient } from '@linera/web-client';

const client = new LineraClient({
    rpcUrl: 'https://rpc.testnet-conway.linera.net',
    applicationId: '<YOUR-APP-ID>'
});

// Connect wallet
await client.connectWallet();

// Create contract
const result = await client.executeOperation({
    operation: 'CreateAdaptiveContract',
    params: {
        contract_type: 'price_prediction',
        threshold: 80
    }
});

// Query contract
const contract = await client.query({
    query: `
        query GetContract($id: Int!) {
            contract(id: $id) {
                id
                contract_type
                threshold
                is_active
            }
        }
    `,
    variables: { id: 1 }
});
```

### Option B: Using CheCko Wallet

```bash
# Install CheCko Wallet extension
# https://github.com/respeer-ai/linera-wallet

# In your frontend
window.checko.connect()
    .then(account => {
        console.log('Connected:', account);
    });
```

### Option C: Using Croissant

```bash
# Install Croissant
# https://github.com/Nirajsah/croissant

# Use Croissant signer
import { CroissantSigner } from 'croissant';
const signer = new CroissantSigner();
```

---

## 🧪 Phase 5: Testing on Testnet

### Test Checklist

- [ ] Contract deployed to Testnet Conway
- [ ] Application ID obtained
- [ ] Frontend connects to Testnet
- [ ] Wallet connection works
- [ ] Can create contracts on Testnet
- [ ] Can submit predictions to Testnet
- [ ] Transactions confirmed on-chain
- [ ] GraphQL queries work
- [ ] Frontend deployed to Vercel
- [ ] Live demo accessible

### Test Commands

```bash
# Test contract on testnet
linera query-application <app-id> --testnet

# Test GraphQL
curl https://rpc.testnet-conway.linera.net/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ application(id: \"<app-id>\") { id } }"
  }'

# Test frontend
curl https://smart-contract-2-0.vercel.app/linera-web-demo.html
```

---

## 📊 Expected Results

### Successful Deployment

```
✅ Contract deployed to Testnet Conway
   Application ID: e476187f6ddfeb9d588c7b45d3df334d5501d6499b3f9ad5595cae86cce16a65010000000000000000000000

✅ Frontend deployed to Vercel
   URL: https://smart-contract-2-0.vercel.app

✅ Live Demo accessible
   Demo: https://smart-contract-2-0.vercel.app/linera-web-demo.html

✅ Testnet integration working
   - Wallet connection: ✅
   - Contract creation: ✅
   - Prediction submission: ✅
   - Transaction confirmation: ✅
```

---

## 🎯 Live Demo Features

Your live demo will have:

1. **Wallet Connection**
   - Connect to Linera Testnet
   - View wallet address & balance
   - Sign transactions

2. **Contract Management**
   - Create adaptive contracts
   - View contract details
   - Monitor contract status

3. **AI Predictions**
   - Select AI model (Price/Risk/Fraud)
   - Submit prediction requests
   - View results on-chain

4. **Transaction History**
   - View recent transactions
   - Transaction hashes
   - Confirmation status

5. **Real-time Updates**
   - Live network status
   - Transaction confirmations
   - Contract events

---

## 🐛 Troubleshooting

### Problem: Contract deployment fails

```bash
# Check wallet balance
linera wallet show

# Request more tokens
linera faucet request

# Retry deployment
linera project publish-and-create --testnet
```

### Problem: Frontend can't connect to Testnet

```javascript
// Check RPC URL
const rpcUrl = 'https://rpc.testnet-conway.linera.net';

// Test connection
fetch(rpcUrl + '/health')
    .then(r => r.json())
    .then(data => console.log('RPC Status:', data));
```

### Problem: Vercel deployment fails

```bash
# Check vercel.json syntax
cat vercel.json | jq .

# Check logs
vercel logs

# Redeploy
vercel --prod --force
```

---

## 📚 Resources

**Linera Documentation:**
- Frontend Guide: https://linera.dev/developers/frontend.html
- Testnet Info: https://linera.dev/testnet
- GraphQL API: https://linera.dev/developers/graphql.html

**Wallet Options:**
- CheCko Wallet: https://github.com/respeer-ai/linera-wallet
- Croissant: https://github.com/Nirajsah/croissant

**Deployment:**
- Vercel Docs: https://vercel.com/docs
- Linera CLI: https://linera.dev/developers/cli.html

---

## 🎉 Success Criteria

Your submission should have:

✅ **Live Demo URL**
- Accessible from anywhere
- Running on Testnet Conway
- Wallet connection working

✅ **Contract on Testnet**
- Deployed and verified
- Application ID documented
- GraphQL queries working

✅ **Frontend Features**
- Wallet integration
- Contract creation
- Prediction submission
- Transaction history

✅ **Documentation**
- Deployment guide
- User guide
- API documentation

---

## 📞 Next Steps

1. **Deploy Contract**
   ```bash
   cd linera-integration
   linera project publish-and-create --testnet
   ```

2. **Update Frontend**
   - Add Application ID
   - Configure Testnet RPC
   - Test wallet connection

3. **Deploy to Vercel**
   ```bash
   vercel --prod
   ```

4. **Submit Demo**
   - Live demo URL
   - Application ID
   - Documentation

---

**Ready to deploy? Let's start with Phase 1! 🚀**
