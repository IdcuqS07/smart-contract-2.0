# 📋 Linera Commands Cheatsheet

Quick reference untuk semua command yang sering digunakan.

## 🚀 Network Management

```bash
# Start local network
linera net up

# Stop network (Ctrl+C in terminal)

# Check network status
ps aux | grep linera
```

## 💼 Wallet Management

```bash
# Show wallet info
linera wallet show

# Get default chain
linera wallet default-chain

# Set default chain
linera wallet set-default-chain <CHAIN_ID>

# List all chains
linera wallet show
```

## 🔨 Build & Deploy

```bash
# Build contract
cargo build --release --target wasm32-unknown-unknown

# Deploy contract
linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm

# Quick deploy (using script)
./scripts/quick-start.sh
```

## 🔍 Query & Inspect

```bash
# Query balance
linera query-balance

# List applications
linera query-applications

# Get application details
linera query-application <APP_ID>

# Query chain state
linera query-chain <CHAIN_ID>
```

## 🌐 Service Management

```bash
# Start GraphQL service
linera service --port 8080

# Start with debug logs
RUST_LOG=debug linera service --port 8080

# Start with trace logs
RUST_LOG=trace linera service --port 8080
```

## 🧪 Testing

```bash
# Run unit tests
cargo test

# Run with test features
cargo test --features test

# Run specific test
cargo test test_name

# Run with output
cargo test -- --nocapture
```

## 🔧 Development

```bash
# Clean build
cargo clean

# Update dependencies
cargo update

# Check code
cargo check

# Format code
cargo fmt

# Lint code
cargo clippy
```

## 📊 GraphQL Queries

### Get Chain State
```graphql
query {
  chain(chainId: "YOUR_CHAIN_ID") {
    executionState {
      system {
        balance
        timestamp
      }
    }
  }
}
```

### Execute Operation
```graphql
mutation {
  executeOperation(
    chainId: "YOUR_CHAIN_ID"
    operation: {
      requestPrediction: {
        data: "BTC,50000"
      }
    }
  ) {
    hash
  }
}
```

### Subscribe to Events
```graphql
subscription {
  notifications(chainId: "YOUR_CHAIN_ID") {
    reason
    chainId
    height
  }
}
```

## 🐛 Debugging

```bash
# Check Linera version
linera --version

# Check storage server
which linera-storage-server

# Check running processes
ps aux | grep linera

# Check ports
lsof -i :8080

# Kill processes
pkill -f linera

# View logs
tail -f ~/.linera/logs/*.log
```

## 📦 Chain Operations

```bash
# Transfer tokens
linera transfer <AMOUNT> --to <CHAIN_ID>

# Create new chain
linera open-chain

# Close chain
linera close-chain <CHAIN_ID>
```

## 🔐 Security

```bash
# Generate new key
linera keygen

# Export private key
linera wallet export-key

# Import private key
linera wallet import-key <KEY>
```

## 🎯 Quick Workflows

### Full Development Cycle
```bash
# 1. Start network
linera net up

# 2. Build
cd linera-integration
cargo build --release --target wasm32-unknown-unknown

# 3. Deploy
./scripts/quick-start.sh

# 4. Start service
linera service --port 8080

# 5. Test
open http://localhost:8080/graphql
```

### Quick Rebuild & Redeploy
```bash
# Clean and rebuild
cargo clean
cargo build --release --target wasm32-unknown-unknown

# Redeploy
linera project publish-and-create \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_contract.wasm \
  target/wasm32-unknown-unknown/release/smart_contract_2_linera_service.wasm
```

### Debug Workflow
```bash
# Terminal 1: Network with logs
RUST_LOG=debug linera net up

# Terminal 2: Build and deploy
cd linera-integration
cargo build --release --target wasm32-unknown-unknown
./scripts/quick-start.sh

# Terminal 3: Service with logs
RUST_LOG=debug linera service --port 8080

# Terminal 4: Test queries
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chain { executionState { system { balance } } } }"}'
```

## 📝 Environment Variables

```bash
# Rust log level
export RUST_LOG=debug
export RUST_LOG=trace
export RUST_LOG=info

# Linera wallet location
export LINERA_WALLET=~/.linera/wallet.json

# Storage location
export LINERA_STORAGE=~/.linera/storage
```

## 🔄 Common Patterns

### Check Everything
```bash
# Version check
linera --version
cargo --version
rustc --version

# Network check
ps aux | grep linera
lsof -i :8080

# Wallet check
linera wallet show

# Build check
cargo check
```

### Clean Everything
```bash
# Clean Rust build
cargo clean

# Kill all Linera processes
pkill -f linera

# Remove wallet (CAREFUL!)
rm -rf ~/.linera/wallet.json

# Remove storage (CAREFUL!)
rm -rf ~/.linera/storage
```

### Fresh Start
```bash
# 1. Kill everything
pkill -f linera

# 2. Clean build
cargo clean

# 3. Rebuild
cargo build --release --target wasm32-unknown-unknown

# 4. Start fresh network
linera net up

# 5. Deploy
./scripts/quick-start.sh
```

## 🎓 Tips

- Always keep network running in separate terminal
- Use `RUST_LOG=debug` for troubleshooting
- Check wallet before deploying
- Test locally before testnet
- Keep WASM files small
- Use GraphQL playground for testing
- Monitor logs for errors
- Backup wallet regularly

## 📚 More Info

- Full Guide: `LINERA_DEV_GUIDE.md`
- Setup: `LINERA_SETUP_SUCCESS.md`
- Deployment: `DEPLOYMENT.md`
- Architecture: `ARCHITECTURE.md`

---

**Quick Access:**
- GraphQL: http://localhost:8080/graphql
- Docs: https://linera.dev
- GitHub: https://github.com/linera-io/linera-protocol
