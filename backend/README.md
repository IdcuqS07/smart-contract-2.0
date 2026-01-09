# AI + Blockchain Integration

## Konsep: AI Prediksi → Smart Contract Execute

### Flow:
```
1. AI analyze harga crypto (Binance API)
2. AI prediksi: BUY/SELL/HOLD
3. Smart Contract dibuat otomatis
4. Contract execute sesuai kondisi
```

## API Endpoints:

### 1. Get AI Prediction
```bash
POST /api/predict
Body: { "symbol": "BTC", "timeframe": "1h" }
```

Response:
```json
{
  "symbol": "BTC",
  "currentPrice": "45230.50",
  "predictedPrice": "46100.25",
  "direction": "UP",
  "confidence": "82.5",
  "action": "BUY"
}
```

### 2. Create Contract from Prediction
```bash
POST /api/contract/create
Body: { 
  "symbol": "BTC", 
  "amount": 100,
  "riskLevel": "MEDIUM"
}
```

Response:
```json
{
  "id": 1000,
  "action": "BUY",
  "entryPrice": "45230.50",
  "stopLoss": "42969.00",
  "takeProfit": "48848.94",
  "status": "PENDING"
}
```

### 3. Auto-Trade (All-in-One)
```bash
POST /api/auto-trade
Body: { 
  "symbol": "BTC", 
  "amount": 100 
}
```

## Run Server:

```bash
npm install
npm start
```

Server: http://localhost:3000

## Test:

```bash
# Get prediction
curl -X POST http://localhost:3000/api/predict \
  -H "Content-Type: application/json" \
  -d '{"symbol":"BTC"}'

# Auto-trade
curl -X POST http://localhost:3000/api/auto-trade \
  -H "Content-Type: application/json" \
  -d '{"symbol":"BTC","amount":100}'
```
