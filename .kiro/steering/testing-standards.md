---
inclusion: always
---

# Testing Standards

## Test Structure

### Unit Tests

Test individual functions and methods in isolation.

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_validate_prediction_request() {
        let valid_req = PredictionRequest {
            data: "BTC,50000".to_string(),
        };
        assert!(validate_prediction_request(&valid_req).is_ok());
        
        let invalid_req = PredictionRequest {
            data: "".to_string(),
        };
        assert!(validate_prediction_request(&invalid_req).is_err());
    }
}
```

```python
import pytest

def test_predict_price():
    """Test price prediction function."""
    result = predict_price('BTC', '1h')
    
    assert 'predictedPrice' in result
    assert 'confidence' in result
    assert 0 <= result['confidence'] <= 1
    assert result['predictedPrice'] > 0
```

```javascript
describe('Oracle Service', () => {
  it('should process valid prediction request', async () => {
    const result = await processPrediction({
      symbol: 'BTC',
      timeframe: '1h'
    });
    
    expect(result).toHaveProperty('predictedPrice');
    expect(result.confidence).toBeGreaterThanOrEqual(0);
    expect(result.confidence).toBeLessThanOrEqual(1);
  });
});
```

### Integration Tests

Test interactions between components.

```javascript
const request = require('supertest');
const app = require('../app');

describe('API Integration', () => {
  it('should complete full prediction flow', async () => {
    // Request prediction
    const response = await request(app)
      .post('/api/predict')
      .send({ symbol: 'BTC', timeframe: '1h' })
      .expect(200);
    
    expect(response.body.success).toBe(true);
    
    // Verify prediction stored
    const id = response.body.data.id;
    const stored = await request(app)
      .get(`/api/prediction/${id}`)
      .expect(200);
    
    expect(stored.body.data.id).toBe(id);
  });
});
```

## Test Coverage

Aim for:
- 80%+ code coverage
- 100% coverage for critical paths
- All error cases tested

```bash
# Python coverage
pytest --cov=ai_engine --cov-report=html

# JavaScript coverage
npm test -- --coverage

# Rust coverage
cargo tarpaulin --out Html
```

## Mocking

### Mock External Services

```python
from unittest.mock import Mock, patch

@patch('requests.get')
def test_fetch_market_data(mock_get):
    """Test with mocked API call."""
    mock_get.return_value.json.return_value = {
        'price': 50000,
        'volume': 1000000
    }
    
    result = fetch_market_data('BTC')
    assert result['price'] == 50000
```

```javascript
jest.mock('axios');

test('fetches AI prediction', async () => {
  axios.post.mockResolvedValue({
    data: { predictedPrice: 50000, confidence: 0.85 }
  });
  
  const result = await fetchAIPrediction({ symbol: 'BTC' });
  expect(result.predictedPrice).toBe(50000);
});
```

## Test Fixtures

```python
@pytest.fixture
def sample_market_data():
    """Provide sample market data for tests."""
    return pd.DataFrame({
        'timestamp': pd.date_range('2024-01-01', periods=100, freq='1h'),
        'open': np.random.rand(100) * 50000,
        'high': np.random.rand(100) * 51000,
        'low': np.random.rand(100) * 49000,
        'close': np.random.rand(100) * 50000,
        'volume': np.random.rand(100) * 1000000
    })
```

## E2E Tests

Test complete user workflows.

```javascript
describe('E2E: Prediction Flow', () => {
  it('should complete full prediction workflow', async () => {
    // 1. User requests prediction
    const prediction = await requestPrediction('BTC', '1h');
    expect(prediction.id).toBeDefined();
    
    // 2. System processes via AI
    await waitForProcessing(prediction.id);
    
    // 3. User retrieves result
    const result = await getPrediction(prediction.id);
    expect(result.status).toBe('completed');
    expect(result.predictedPrice).toBeGreaterThan(0);
  });
});
```
