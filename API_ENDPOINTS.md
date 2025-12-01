# 📡 API Endpoints Documentation

Complete API reference for Smart Contract 2.0

---

## 🌐 Base URLs

- **VPS Backend**: `http://143.198.205.88`
- **Local Development**: `http://localhost`

---

## 🤖 AI Engine Endpoints

Base path: `/api/ai`

### 1. Health Check
```http
GET /api/ai/health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-11-30T19:47:15.789598"
}
```

---

### 2. Get Available Models
```http
GET /api/ai/models
```

**Response:**
```json
{
  "models": [
    "price_prediction",
    "risk_analysis",
    "fraud_detection"
  ],
  "timestamp": "2025-11-30T19:49:11.989209"
}
```

---

### 3. Request Prediction
```http
POST /api/ai/predict
Content-Type: application/json
```

**Request Body:**
```json
{
  "model_type": "price_prediction",
  "data": {
    "prices": [50000, 51000, 49500, 52000, 51500]
  }
}
```

**Response:**
```json
{
  "prediction": 51400.0,
  "confidence": 50,
  "model": "price_prediction",
  "timestamp": "2025-11-30T19:49:05.222098"
}
```

**Model Types:**

#### a) Price Prediction
```json
{
  "model_type": "price_prediction",
  "data": {
    "prices": [50000, 51000, 49500, 52000, 51500]
  }
}
```

#### b) Risk Analysis
```json
{
  "model_type": "risk_analysis",
  "data": {
    "amount": 10000,
    "history_score": 75,
    "volatility": 0.3
  }
}
```

Response:
```json
{
  "risk_score": 45,
  "risk_level": "MEDIUM",
  "confidence": 85,
  "model": "risk_analysis",
  "timestamp": "2025-11-30T..."
}
```

#### c) Fraud Detection
```json
{
  "model_type": "fraud_detection",
  "data": {
    "amount": 5000,
    "user_history": [1000, 1200, 1100, 1300],
    "speed": 5
  }
}
```

Response:
```json
{
  "fraud_score": 35,
  "is_fraud": false,
  "confidence": 80,
  "model": "fraud_detection",
  "timestamp": "2025-11-30T..."
}
```

---

## 🔮 Oracle Service Endpoints

Base path: `/api/oracle`

### 1. Health Check
```http
GET /api/oracle/health
```

**Response:**
```json
{
  "status": "ok",
  "service": "oracle",
  "timestamp": 1764532039120
}
```

---

### 2. Create Adaptive Contract
```http
POST /api/oracle/request
Content-Type: application/json
```

**Request Body:**
```json
{
  "contractType": "insurance",
  "threshold": 50000
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "type": "insurance",
    "threshold": 50000,
    "status": "active",
    "createdAt": "2025-11-30T...",
    "predictions": []
  }
}
```

**Contract Types:**
- `insurance` - Insurance contracts
- `loan` - Loan agreements
- `escrow` - Escrow services
- `derivative` - Financial derivatives

---

### 3. Get Contract by ID
```http
GET /api/oracle/contract/:id
```

**Example:**
```bash
GET /api/oracle/contract/1
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "type": "insurance",
    "threshold": 50000,
    "status": "active",
    "createdAt": "2025-11-30T...",
    "predictions": [1, 2, 3]
  }
}
```

---

### 4. Get All Contracts
```http
GET /api/oracle/contracts
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "type": "insurance",
      "threshold": 50000,
      "status": "active",
      "createdAt": "2025-11-30T...",
      "predictions": [1]
    },
    {
      "id": 2,
      "type": "loan",
      "threshold": 25000,
      "status": "active",
      "createdAt": "2025-11-30T...",
      "predictions": []
    }
  ],
  "count": 2
}
```

---

### 5. Request AI Prediction for Contract
```http
POST /api/oracle/predict
Content-Type: application/json
```

**Request Body:**
```json
{
  "contractId": 1,
  "modelType": "price_prediction",
  "data": {
    "prices": [50000, 51000, 49500, 52000, 51500]
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "contractId": 1,
    "modelType": "price_prediction",
    "result": {
      "prediction": 51400.0,
      "confidence": 50,
      "model": "price_prediction",
      "timestamp": "2025-11-30T..."
    },
    "timestamp": "2025-11-30T..."
  }
}
```

---

### 6. Get Prediction by ID
```http
GET /api/oracle/prediction/:id
```

**Example:**
```bash
GET /api/oracle/prediction/1
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "contractId": 1,
    "modelType": "price_prediction",
    "result": {
      "prediction": 51400.0,
      "confidence": 50,
      "model": "price_prediction",
      "timestamp": "2025-11-30T..."
    },
    "timestamp": "2025-11-30T..."
  }
}
```

---

### 7. Get Latest Prediction for Contract
```http
GET /api/oracle/prediction/latest/:contractId
```

**Example:**
```bash
GET /api/oracle/prediction/latest/1
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 3,
    "contractId": 1,
    "modelType": "risk_analysis",
    "result": {
      "risk_score": 45,
      "risk_level": "MEDIUM",
      "confidence": 85,
      "model": "risk_analysis",
      "timestamp": "2025-11-30T..."
    },
    "timestamp": "2025-11-30T..."
  }
}
```

---

## 🧪 Testing Examples

### Using cURL

#### Test AI Engine:
```bash
# Health check
curl http://143.198.205.88/api/ai/health

# Get models
curl http://143.198.205.88/api/ai/models

# Price prediction
curl -X POST http://143.198.205.88/api/ai/predict \
  -H "Content-Type: application/json" \
  -d '{
    "model_type": "price_prediction",
    "data": {"prices": [50000, 51000, 49500, 52000, 51500]}
  }'
```

#### Test Oracle Service:
```bash
# Health check
curl http://143.198.205.88/api/oracle/health

# Create contract
curl -X POST http://143.198.205.88/api/oracle/request \
  -H "Content-Type: application/json" \
  -d '{"contractType": "insurance", "threshold": 50000}'

# Get all contracts
curl http://143.198.205.88/api/oracle/contracts

# Request prediction
curl -X POST http://143.198.205.88/api/oracle/predict \
  -H "Content-Type: application/json" \
  -d '{
    "contractId": 1,
    "modelType": "price_prediction",
    "data": {"prices": [50000, 51000, 49500, 52000, 51500]}
  }'
```

### Using JavaScript (Fetch API)

```javascript
// Create contract
const createContract = async () => {
  const response = await fetch('http://143.198.205.88/api/oracle/request', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      contractType: 'insurance',
      threshold: 50000
    })
  });
  return await response.json();
};

// Get AI prediction
const getPrediction = async () => {
  const response = await fetch('http://143.198.205.88/api/ai/predict', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      model_type: 'price_prediction',
      data: { prices: [50000, 51000, 49500, 52000, 51500] }
    })
  });
  return await response.json();
};
```

---

## 🔒 Error Responses

All endpoints return consistent error format:

```json
{
  "success": false,
  "error": "Error message here"
}
```

**Common HTTP Status Codes:**
- `200` - Success
- `400` - Bad Request (missing/invalid parameters)
- `404` - Not Found
- `500` - Internal Server Error

---

## 📊 Rate Limits

- **AI Engine**: 100 requests per 15 minutes per IP
- **Oracle Service**: 100 requests per 15 minutes per IP
- **Prediction requests**: 10 per minute per IP

---

## 🚀 Quick Start

1. **Test health endpoints:**
```bash
curl http://143.198.205.88/api/ai/health
curl http://143.198.205.88/api/oracle/health
```

2. **Create a contract:**
```bash
curl -X POST http://143.198.205.88/api/oracle/request \
  -H "Content-Type: application/json" \
  -d '{"contractType":"insurance","threshold":50000}'
```

3. **Get AI prediction:**
```bash
curl -X POST http://143.198.205.88/api/ai/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type":"price_prediction","data":{"prices":[50000,51000,49500,52000,51500]}}'
```

---

## 📝 Notes

- All timestamps are in ISO 8601 format
- All amounts/thresholds are numeric values
- Contract IDs and Prediction IDs are auto-incremented integers
- Data is currently stored in-memory (will be persisted to database in production)

---

**Last Updated**: December 1, 2025  
**API Version**: 1.0.0
