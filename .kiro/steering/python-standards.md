---
inclusion: always
---

# Python Standards for AI Engine

## Type Hints

Always use type hints for function signatures and class attributes:

```python
from typing import Dict, List, Optional, Tuple, Union
import numpy as np
import pandas as pd

def predict_price(
    data: pd.DataFrame,
    model_type: str = "lstm"
) -> Dict[str, Union[float, str]]:
    """Predict cryptocurrency price."""
    pass

class PredictionModel:
    model: Optional[object]
    scaler: Optional[object]
    
    def __init__(self, model_path: str) -> None:
        self.model = None
        self.scaler = None
```

## Flask API Standards

### Route Structure

```python
from flask import Flask, request, jsonify
from typing import Tuple

app = Flask(__name__)

@app.route('/api/predict', methods=['POST'])
def predict() -> Tuple[Dict, int]:
    """
    Predict endpoint for AI models.
    
    Returns:
        Tuple of (response_dict, status_code)
    """
    try:
        data = request.get_json()
        
        # Validate input
        if not validate_input(data):
            return {"error": "Invalid input"}, 400
        
        # Process
        result = process_prediction(data)
        return {"result": result}, 200
        
    except Exception as e:
        return {"error": str(e)}, 500
```

### Input Validation

```python
from pydantic import BaseModel, validator

class PredictionRequest(BaseModel):
    symbol: str
    timeframe: str
    data_points: int
    
    @validator('symbol')
    def validate_symbol(cls, v):
        if not v or len(v) < 2:
            raise ValueError('Invalid symbol')
        return v.upper()
    
    @validator('data_points')
    def validate_data_points(cls, v):
        if v < 10 or v > 1000:
            raise ValueError('Data points must be between 10 and 1000')
        return v
```

## Model Standards

### Model Class Structure

```python
import joblib
import numpy as np
from pathlib import Path

class BaseModel:
    """Base class for all AI models."""
    
    def __init__(self, model_path: str) -> None:
        self.model_path = Path(model_path)
        self.model = None
        self.is_trained = False
    
    def load(self) -> None:
        """Load trained model from disk."""
        if self.model_path.exists():
            self.model = joblib.load(self.model_path)
            self.is_trained = True
    
    def save(self) -> None:
        """Save trained model to disk."""
        if self.model is not None:
            joblib.dump(self.model, self.model_path)
    
    def predict(self, X: np.ndarray) -> np.ndarray:
        """Make predictions."""
        if not self.is_trained:
            raise ValueError("Model not trained")
        return self.model.predict(X)
```

### Data Preprocessing

```python
from sklearn.preprocessing import StandardScaler
import pandas as pd

def preprocess_data(
    df: pd.DataFrame,
    scaler: Optional[StandardScaler] = None
) -> Tuple[np.ndarray, StandardScaler]:
    """
    Preprocess data for model input.
    
    Args:
        df: Input dataframe
        scaler: Optional pre-fitted scaler
    
    Returns:
        Tuple of (scaled_data, scaler)
    """
    # Handle missing values
    df = df.fillna(method='ffill').fillna(method='bfill')
    
    # Scale features
    if scaler is None:
        scaler = StandardScaler()
        scaled_data = scaler.fit_transform(df)
    else:
        scaled_data = scaler.transform(df)
    
    return scaled_data, scaler
```

## Error Handling

```python
import logging
from functools import wraps

logger = logging.getLogger(__name__)

class ModelError(Exception):
    """Base exception for model errors."""
    pass

class PredictionError(ModelError):
    """Exception for prediction failures."""
    pass

def handle_errors(func):
    """Decorator for error handling."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except PredictionError as e:
            logger.error(f"Prediction error: {e}")
            raise
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            raise ModelError(f"Model error: {str(e)}")
    return wrapper
```

## Testing Standards

```python
import pytest
import numpy as np

@pytest.fixture
def sample_data():
    """Fixture for test data."""
    return np.random.rand(100, 10)

def test_model_prediction(sample_data):
    """Test model prediction."""
    model = PredictionModel("models/test_model.pkl")
    model.load()
    
    result = model.predict(sample_data)
    
    assert result is not None
    assert len(result) == len(sample_data)
    assert np.all(np.isfinite(result))

def test_input_validation():
    """Test input validation."""
    with pytest.raises(ValueError):
        validate_input({"invalid": "data"})
```

## Documentation

```python
def predict_price(
    symbol: str,
    timeframe: str,
    data_points: int = 100
) -> Dict[str, float]:
    """
    Predict cryptocurrency price using LSTM model.
    
    This function fetches historical data, preprocesses it,
    and generates price predictions using a trained LSTM model.
    
    Args:
        symbol: Cryptocurrency symbol (e.g., 'BTC', 'ETH')
        timeframe: Time interval ('1h', '4h', '1d')
        data_points: Number of historical data points to use
    
    Returns:
        Dictionary containing:
            - predicted_price: Predicted price value
            - confidence: Confidence score (0-1)
            - timestamp: Prediction timestamp
    
    Raises:
        ValueError: If symbol or timeframe is invalid
        PredictionError: If prediction fails
    
    Example:
        >>> result = predict_price('BTC', '1h', 100)
        >>> print(result['predicted_price'])
        50000.0
    """
    pass
```

## Configuration

```python
from dataclasses import dataclass
from typing import Optional

@dataclass
class ModelConfig:
    """Configuration for AI models."""
    model_type: str
    input_size: int
    hidden_size: int
    num_layers: int
    dropout: float = 0.2
    learning_rate: float = 0.001
    batch_size: int = 32
    epochs: int = 100
    
    def validate(self) -> None:
        """Validate configuration."""
        if self.dropout < 0 or self.dropout > 1:
            raise ValueError("Dropout must be between 0 and 1")
        if self.learning_rate <= 0:
            raise ValueError("Learning rate must be positive")
```
