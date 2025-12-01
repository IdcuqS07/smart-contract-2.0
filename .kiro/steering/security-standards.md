---
inclusion: always
---

# Security Standards for Smart Contract 2.0

## Input Validation

### All Layers Must Validate

```rust
// Rust - Contract Layer
fn validate_prediction_request(req: &PredictionRequest) -> Result<(), OracleError> {
    if req.data.is_empty() || req.data.len() > MAX_DATA_SIZE {
        return Err(OracleError::InvalidRequest("Invalid data size".into()));
    }
    Ok(())
}
```

```python
# Python - AI Engine Layer
from pydantic import BaseModel, validator

class PredictionRequest(BaseModel):
    symbol: str
    timeframe: str
    
    @validator('symbol')
    def validate_symbol(cls, v):
        if not v or len(v) < 2 or len(v) > 10:
            raise ValueError('Invalid symbol')
        return v.upper()
```

```javascript
// JavaScript - Oracle Service Layer
const Joi = require('joi');

const schema = Joi.object({
  symbol: Joi.string().min(2).max(10).required(),
  timeframe: Joi.string().valid('1m', '5m', '15m', '1h', '4h', '1d').required()
});
```

## Rate Limiting

### API Rate Limits

```javascript
const rateLimit = require('express-rate-limit');

// General API limit
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100
});

// Prediction-specific limit
const predictionLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 10
});
```

### Contract-Level Rate Limiting

```rust
// Track requests per address
pub struct RateLimiter {
    requests: BTreeMap<Owner, Vec<Timestamp>>,
    max_per_minute: u32,
}

impl RateLimiter {
    pub fn check_rate_limit(&mut self, owner: Owner) -> Result<(), OracleError> {
        let now = Timestamp::now();
        let requests = self.requests.entry(owner).or_insert_with(Vec::new);
        
        // Remove old requests
        requests.retain(|&t| now - t < Duration::from_secs(60));
        
        if requests.len() >= self.max_per_minute as usize {
            return Err(OracleError::RateLimitExceeded);
        }
        
        requests.push(now);
        Ok(())
    }
}
```

## Authentication & Authorization

### JWT Authentication

```javascript
const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Authentication required' });
  }
  
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ error: 'Invalid token' });
    req.user = user;
    next();
  });
};
```


### API Key Management

```javascript
// Never hardcode API keys
const API_KEY = process.env.ORACLE_API_KEY;

// Validate API key
const validateApiKey = (req, res, next) => {
  const apiKey = req.headers['x-api-key'];
  
  if (!apiKey || apiKey !== API_KEY) {
    return res.status(401).json({ error: 'Invalid API key' });
  }
  
  next();
};
```

## Data Sanitization

### Prevent Injection Attacks

```python
import re
from html import escape

def sanitize_input(data: str) -> str:
    """Sanitize user input to prevent injection attacks."""
    # Remove special characters
    data = re.sub(r'[^\w\s-]', '', data)
    # Escape HTML
    data = escape(data)
    return data.strip()
```

```javascript
const validator = require('validator');

function sanitizeInput(input) {
  // Escape HTML
  let sanitized = validator.escape(input);
  // Remove SQL injection patterns
  sanitized = sanitized.replace(/['";\\]/g, '');
  return sanitized.trim();
}
```

## CORS Configuration

```javascript
const cors = require('cors');

const corsOptions = {
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type', 'Authorization', 'x-api-key'],
  credentials: true,
  maxAge: 86400 // 24 hours
};

app.use(cors(corsOptions));
```

## Environment Variables

### Never Commit Secrets

```bash
# .env.example (commit this)
ORACLE_API_KEY=your_api_key_here
JWT_SECRET=your_jwt_secret_here
AI_ENGINE_URL=http://localhost:5000

# .env (never commit this)
ORACLE_API_KEY=actual_secret_key
JWT_SECRET=actual_jwt_secret
```

### Load Environment Variables Securely

```javascript
require('dotenv').config();

// Validate required env vars
const requiredEnvVars = ['ORACLE_API_KEY', 'JWT_SECRET', 'AI_ENGINE_URL'];

requiredEnvVars.forEach(varName => {
  if (!process.env[varName]) {
    throw new Error(`Missing required environment variable: ${varName}`);
  }
});
```

## Error Handling - Don't Leak Information

```javascript
// BAD - Exposes internal details
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.stack });
});

// GOOD - Generic error in production
app.use((err, req, res, next) => {
  console.error(err); // Log internally
  
  const message = process.env.NODE_ENV === 'production'
    ? 'Internal server error'
    : err.message;
  
  res.status(err.statusCode || 500).json({ error: message });
});
```

## Logging - Secure Practices

```python
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

# NEVER log sensitive data
def process_payment(card_number: str, amount: float):
    # BAD
    logger.info(f"Processing payment: {card_number}, {amount}")
    
    # GOOD
    masked_card = f"****{card_number[-4:]}"
    logger.info(f"Processing payment: {masked_card}, {amount}")
```

## Dependency Security

### Regular Updates

```bash
# Check for vulnerabilities
npm audit
pip check

# Update dependencies
npm update
pip install --upgrade -r requirements.txt
```

### Use Lock Files

- `package-lock.json` for Node.js
- `requirements.txt` with pinned versions for Python
- `Cargo.lock` for Rust

## Smart Contract Security

### Reentrancy Protection

```rust
pub struct ContractState {
    locked: bool,
}

impl ContractState {
    pub fn execute_with_lock<F, R>(&mut self, f: F) -> Result<R, OracleError>
    where
        F: FnOnce(&mut Self) -> Result<R, OracleError>,
    {
        if self.locked {
            return Err(OracleError::ReentrancyDetected);
        }
        
        self.locked = true;
        let result = f(self);
        self.locked = false;
        
        result
    }
}
```

### Integer Overflow Protection

```rust
// Use saturating arithmetic
let total = amount.saturating_add(fee);

// Or checked arithmetic
let total = amount.checked_add(fee)
    .ok_or(OracleError::ArithmeticOverflow)?;
```

## AI-Oracle Integration Security

### Validate AI Responses

```javascript
function validateAIPrediction(prediction) {
  // Check required fields
  if (!prediction.predictedPrice || !prediction.confidence) {
    throw new ValidationError('Invalid prediction format');
  }
  
  // Validate ranges
  if (prediction.confidence < 0 || prediction.confidence > 1) {
    throw new ValidationError('Invalid confidence score');
  }
  
  if (prediction.predictedPrice <= 0) {
    throw new ValidationError('Invalid price prediction');
  }
  
  return true;
}
```

### Timeout Protection

```javascript
const axios = require('axios');

async function fetchAIPrediction(data) {
  try {
    const response = await axios.post(AI_ENGINE_URL, data, {
      timeout: 5000, // 5 second timeout
      validateStatus: (status) => status === 200
    });
    
    return response.data;
  } catch (error) {
    if (error.code === 'ECONNABORTED') {
      throw new OracleError('AI service timeout');
    }
    throw error;
  }
}
```
