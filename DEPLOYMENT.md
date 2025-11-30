# Panduan Deployment Smart Contract 2.0

## Prerequisites

- Node.js v18+
- Python 3.8+
- npm atau yarn

## Langkah Instalasi

### 1. Install Dependencies

```bash
# Install blockchain dependencies
npm install

# Install Python dependencies untuk AI Engine
pip install -r ai-engine/requirements.txt
```

### 2. Setup Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env dengan konfigurasi Anda
```

### 3. Compile Smart Contracts

```bash
npm run compile
```

### 4. Deploy ke Local Network

Terminal 1 - Start Hardhat Node:
```bash
npm run node
```

Terminal 2 - Deploy Contracts:
```bash
npm run deploy
```

Salin CONTRACT_ADDRESS dari output dan update file .env

### 5. Start AI Engine

Terminal 3:
```bash
cd ai-engine
python main.py
```

AI Engine akan berjalan di http://localhost:5000

### 6. Start Oracle Service

Terminal 4:
```bash
node oracle-service/server.js
```

Oracle Service akan berjalan di http://localhost:3000

### 7. Start Frontend

Terminal 5:
```bash
cd frontend
python -m http.server 8080
# atau
npx serve .
```

Buka browser: http://localhost:8080

## Testing

```bash
# Run unit tests
npm test

# Test AI Engine
curl http://localhost:5000/health

# Test Oracle Service
curl http://localhost:3000/health
```

## Demo Usage

1. Buka frontend di browser
2. Buat kontrak adaptif baru
3. Pilih model AI (Price Prediction, Risk Analysis, atau Fraud Detection)
4. Input data dan request prediksi
5. Lihat hasil prediksi dengan confidence score
6. Optional: Submit hasil ke blockchain

## Production Deployment

### Deploy ke Testnet (Sepolia, Mumbai, dll)

1. Update hardhat.config.js dengan network config
2. Dapatkan testnet ETH dari faucet
3. Deploy: `npx hardhat run scripts/deploy.js --network sepolia`

### Deploy AI Engine

- Gunakan Docker untuk containerization
- Deploy ke cloud (AWS, GCP, Azure)
- Setup load balancer untuk scalability

### Deploy Oracle Service

- Implement multiple oracle nodes
- Setup monitoring dan alerting
- Implement retry mechanism dan error handling

## Monitoring

- Monitor gas usage untuk optimasi
- Track AI model accuracy
- Log oracle submissions
- Setup alerts untuk anomali

## Troubleshooting

**Contract deployment gagal:**
- Pastikan Hardhat node berjalan
- Check balance account deployer

**AI Engine error:**
- Verify Python dependencies installed
- Check port 5000 tidak digunakan aplikasi lain

**Oracle tidak bisa submit:**
- Verify oracle address sudah diauthorize
- Check private key di .env valid
- Pastikan contract address benar
