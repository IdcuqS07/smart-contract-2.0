# 🚀 Smart Contract 2.0 - Linera Integration

AI-Enhanced Smart Contracts on Linera blockchain for ultra-low latency and high scalability.

## 🎯 Features

- ⚡ **Sub-second finality** with Linera
- 🤖 **3 AI Models**: Price Prediction, Risk Analysis, Fraud Detection
- 🔄 **Real-time events** via GraphQL subscriptions
- 💰 **Low gas costs** for frequent predictions
- 🌐 **Microchains** for isolated contract execution

## 📁 Project Structure

```
linera-integration/
├── src/
│   ├── lib.rs           # ABI definitions
│   ├── contract.rs      # Contract logic (Rust)
│   ├── service.rs       # GraphQL service
│   └── state.rs         # State management
├── oracle-client/
│   ├── linera-oracle.js # Oracle client for Linera
│   └── package.json
├── Cargo.toml           # Rust dependencies
└── README.md
```

## 🛠️ Prerequisites

### 1. Install Rust
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown
```

### 2. Install Linera CLI
```bash
cargo install linera-service --git https://github.com/linera-io/linera-protocol.git
```

### 3. Verify Installation
```bash
linera --version
```

## 🚀 Quick Start

### Step 1: Build the Contract

```bash
cd linera-integration
cargo build --release --target wasm32-unknown-unknown
```

### Step 2: Initialize Linera Wallet

```bash
# Create new wallet
linera wallet init --with-new-chain

# Get your chain ID
export CHAIN_ID=$(linera wallet show | grep "Public Key" -A 1 | tail -1 | awk '{print $2}')
echo "Chain ID: $CHAIN_ID"
```

### Step 3: Publish Application

```bash
# Publish the application
linera publish-and-create \
  --bytecode target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm \
  --service target/wasm32-unknown-unknown/release/smart_contract_2_service.wasm \
  --required-application-ids []

# Save the application ID
export APP_ID=<application-id-from-output>
```

### Step 4: Start Linera Service

```bash
# Start local Linera node
linera service --port 8080
```

### Step 5: Setup Oracle Client

```bash
cd oracle-client
npm install

# Create .env file
cat > .env << EOF
GRAPHQL_ENDPOINT=http://localhost:8080/graphql
CHAIN_ID=$CHAIN_ID
APPLICATION_ID=$APP_ID
OWNER_ADDRESS=<your-owner-address>
AI_ENGINE_URL=http://localhost:5001
EOF
```

### Step 6: Test the Integration

```bash
node test.js
```

## 📖 Usage Examples

### Create Adaptive Contract

```javascript
const LineraOracleClient = require('./linera-oracle');

const oracle = new LineraOracleClient({
  graphqlEndpoint: 'http://localhost:8080/graphql',
  chainId: process.env.CHAIN_ID,
  applicationId: process.env.APP_ID,
  aiEngineUrl: 'http://localhost:5001'
});

// Create insurance contract
const result = await oracle.createAdaptiveContract('insurance', 7000);
console.log('Contract ID:', result.contractId);
```

### Submit AI Prediction

```javascript
// Request prediction and submit to blockchain
const prediction = await oracle.requestAndSubmitPrediction(
  1, // contract ID
  'risk_analysis',
  {
    amount: 5000,
    history_score: 75,
    volatility: 0.3
  }
);

console.log('Prediction:', prediction.prediction);
console.log('Blockchain TX:', prediction.blockchain.hash);
```

### Query Contract

```javascript
// Get contract information
const contract = await oracle.getContract(1);
console.log('Contract:', contract);

// Get latest prediction
const latestPrediction = await oracle.getLatestPrediction(1);
console.log('Latest Prediction:', latestPrediction);
```

### Subscribe to Events

```javascript
// Subscribe to real-time events
const subscription = oracle.subscribeToEvents((event) => {
  console.log('New event:', event);
  
  if (event.type === 'PredictionReceived') {
    console.log('New prediction received!');
  }
  
  if (event.type === 'ContractExecuted') {
    console.log('Contract auto-executed!');
  }
});

// Unsubscribe later
subscription.unsubscribe();
```

## 🎯 GraphQL Queries

### Query Contract

```graphql
query GetContract($chainId: ChainId!, $applicationId: ApplicationId!, $contractId: Int!) {
  application(chainId: $chainId, id: $applicationId) {
    contract(id: $contractId) {
      id
      creator
      contract_type
      threshold
      is_active
      created_at
      last_updated
    }
  }
}
```

### Query Predictions

```graphql
query GetPredictions($chainId: ChainId!, $applicationId: ApplicationId!, $contractId: Int!) {
  application(chainId: $chainId, id: $applicationId) {
    predictions(contract_id: $contractId) {
      timestamp
      prediction_type
      value
      confidence
      oracle
    }
  }
}
```

### Create Contract Mutation

```graphql
mutation CreateContract(
  $chainId: ChainId!,
  $applicationId: ApplicationId!,
  $contractType: String!,
  $threshold: Int!
) {
  executeOperation(
    chainId: $chainId,
    applicationId: $applicationId,
    operation: {
      CreateAdaptiveContract: {
        contract_type: $contractType,
        threshold: $threshold
      }
    }
  ) {
    hash
  }
}
```

## 🔧 Configuration

### Environment Variables

```bash
# Linera Configuration
GRAPHQL_ENDPOINT=http://localhost:8080/graphql
CHAIN_ID=your-chain-id
APPLICATION_ID=your-app-id
OWNER_ADDRESS=your-owner-address

# AI Engine
AI_ENGINE_URL=http://localhost:5001

# Oracle
ORACLE_PRIVATE_KEY=your-private-key
```

## 📊 Performance Benchmarks

| Metric | Ethereum | Linera |
|--------|----------|--------|
| Finality | 12-15s | <1s ⚡ |
| TPS | 15 | 1000+ 🚀 |
| Gas Cost | High | Low 💰 |
| Latency | Medium | Very Low ⚡ |

## 🎨 Use Cases

### 1. High-Frequency Trading
```javascript
// Ultra-low latency for trading decisions
const prediction = await oracle.requestAndSubmitPrediction(
  tradingContractId,
  'price_prediction',
  { prices: recentPrices }
);

// Execute trade in <1 second
if (prediction.prediction.prediction > threshold) {
  executeTrade();
}
```

### 2. Real-Time Fraud Detection
```javascript
// Instant fraud detection
const fraudCheck = await oracle.requestAndSubmitPrediction(
  paymentContractId,
  'fraud_detection',
  {
    amount: transactionAmount,
    user_history: userHistory,
    speed: transactionSpeed
  }
);

// Block transaction immediately if fraud detected
if (fraudCheck.prediction.is_fraud) {
  blockTransaction();
}
```

### 3. Dynamic Insurance Pricing
```javascript
// Real-time risk assessment
const riskAssessment = await oracle.requestAndSubmitPrediction(
  insuranceContractId,
  'risk_analysis',
  {
    amount: claimAmount,
    history_score: userScore,
    volatility: marketVolatility
  }
);

// Instant approval/rejection
if (riskAssessment.prediction.risk_score < threshold) {
  approveClaim();
}
```

## 🐛 Troubleshooting

### Contract Build Fails
```bash
# Clean and rebuild
cargo clean
cargo build --release --target wasm32-unknown-unknown
```

### Linera Service Won't Start
```bash
# Check if port is in use
lsof -i :8080

# Use different port
linera service --port 8081
```

### GraphQL Connection Error
```bash
# Verify Linera service is running
curl http://localhost:8080/graphql

# Check chain ID
linera wallet show
```

## 📚 Resources

- **Linera Docs**: https://linera.dev/
- **Linera GitHub**: https://github.com/linera-io/linera-protocol
- **Smart Contract 2.0 Docs**: ../TUTORIAL.md
- **Discord**: https://discord.gg/linera

## 🚀 Next Steps

1. ✅ Build and deploy contract
2. ✅ Test with AI predictions
3. ✅ Monitor performance
4. ✅ Deploy to Linera testnet
5. ✅ Scale to production

## 📄 License

MIT

---

**Built with ❤️ using Linera & AI**
