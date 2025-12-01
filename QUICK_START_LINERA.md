# ⚡ Quick Start - Linera Integration

## 🚀 5-Minute Setup

### Step 1: Install (2 minutes)

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown

# Install Linera CLI
curl -L https://github.com/linera-io/linera-protocol/releases/latest/download/linera-macos -o linera
chmod +x linera && sudo mv linera /usr/local/bin/

# Install Node.js dependencies
cd linera-integration/oracle-client && npm install
```

### Step 2: Deploy (2 minutes)

```bash
# Automated deployment
cd linera-integration
./scripts/full-deploy.sh
```

### Step 3: Test (1 minute)

```bash
# Start services
cd ..
./scripts/start-full-integration.sh

# Run tests
cd linera-integration/oracle-client
node full-integration.js
```

---

## 📋 Command Cheat Sheet

### Build & Deploy

```bash
# Build contract
cd linera-integration
cargo build --release --target wasm32-unknown-unknown

# Initialize wallet
linera wallet init --with-new-chain

# Start service
linera service --port 8080

# Deploy contract
linera publish-and-create \
  target/wasm32-unknown-unknown/release/*.wasm
```

### Service Management

```bash
# Start all services
./scripts/start-full-integration.sh

# Stop all services
./scripts/stop-all-services.sh

# Check service status
curl http://localhost:8080/graphql  # Linera
curl http://localhost:5001/health   # AI Engine
curl http://localhost:3001/health   # Oracle
```

### Testing

```bash
# Full integration test
cd linera-integration/oracle-client
node full-integration.js

# Unit tests
cargo test                    # Rust
npm test                      # JavaScript
pytest                        # Python
```

### GraphQL Queries

```bash
# Query chains
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chains { list } }"}'

# Query contract
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query { application(chainId: \"CHAIN\", id: \"APP\") { contract(id: 1) { id contract_type } } }"
  }'
```

---

## 🎯 Common Tasks

### Create Contract

```javascript
const oracle = new LineraOracleClient(config);
const result = await oracle.createAdaptiveContract('price_prediction', 50000);
console.log('Contract ID:', result.contractId);
```

### Submit Prediction

```javascript
const result = await oracle.requestAndSubmitPrediction(
  contractId,
  'price_prediction',
  { symbol: 'BTC' }
);
console.log('Prediction:', result.prediction);
```

### Query Contract

```javascript
const contract = await oracle.getContract(contractId);
console.log('Active:', contract.is_active);
```

---

## 🐛 Quick Troubleshooting

### Build fails
```bash
rustup update
cargo clean
cargo build --release --target wasm32-unknown-unknown
```

### Service won't start
```bash
# Kill existing processes
pkill -f "linera service"
pkill -f "python main.py"
pkill -f "node server.js"

# Restart
./scripts/start-full-integration.sh
```

### GraphQL not responding
```bash
# Check if running
lsof -i :8080

# Restart Linera
linera service --port 8080
```

---

## 📚 Documentation

- **Full Guide**: [FULL_INTEGRATION_GUIDE.md](./FULL_INTEGRATION_GUIDE.md)
- **Status**: [LINERA_FULL_INTEGRATION.md](./LINERA_FULL_INTEGRATION.md)
- **Technical**: [linera-integration/README_COMPLETE.md](./linera-integration/README_COMPLETE.md)

---

## 🎉 Success Checklist

- [ ] Linera CLI installed
- [ ] Smart contract built
- [ ] Wallet initialized
- [ ] Service running on port 8080
- [ ] Contract deployed
- [ ] Integration tests passing
- [ ] Frontend accessible

**All done? You're ready to build! 🚀**
