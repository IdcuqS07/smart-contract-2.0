"""
AI Engine untuk Smart Contract 2.0
Menyediakan berbagai model ML untuk prediksi dan analisis
"""

import numpy as np
from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime
import json

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

class AIEngine:
    """Engine utama untuk berbagai model AI"""
    
    def __init__(self):
        self.models = {
            'price_prediction': PricePredictionModel(),
            'risk_analysis': RiskAnalysisModel(),
            'fraud_detection': FraudDetectionModel()
        }
    
    def predict(self, model_type, data):
        """Routing ke model yang sesuai"""
        if model_type not in self.models:
            return {'error': 'Model not found'}
        
        return self.models[model_type].predict(data)


class PricePredictionModel:
    """Model prediksi harga menggunakan time series sederhana"""
    
    def predict(self, data):
        """Prediksi harga berdasarkan data historis"""
        try:
            historical_prices = data.get('prices', [])
            if len(historical_prices) < 2:
                return {'error': 'Insufficient data'}
            
            # Simple moving average prediction
            recent_prices = historical_prices[-5:]
            predicted_price = np.mean(recent_prices)
            
            # Calculate trend
            trend = (historical_prices[-1] - historical_prices[0]) / len(historical_prices)
            predicted_price += trend * 2
            
            # Confidence based on volatility
            volatility = np.std(recent_prices)
            confidence = max(50, min(95, int(100 - volatility * 10)))
            
            return {
                'prediction': float(predicted_price),
                'confidence': confidence,
                'timestamp': datetime.now().isoformat(),
                'model': 'price_prediction'
            }
        except Exception as e:
            return {'error': str(e)}


class RiskAnalysisModel:
    """Model analisis risiko"""
    
    def predict(self, data):
        """Analisis risiko berdasarkan berbagai faktor"""
        try:
            amount = data.get('amount', 0)
            history_score = data.get('history_score', 50)
            market_volatility = data.get('volatility', 0.5)
            
            # Risk calculation
            risk_score = 0
            
            # Amount risk (higher amount = higher risk)
            if amount > 10000:
                risk_score += 30
            elif amount > 5000:
                risk_score += 20
            else:
                risk_score += 10
            
            # History risk
            risk_score += (100 - history_score) * 0.3
            
            # Market volatility risk
            risk_score += market_volatility * 40
            
            risk_score = min(100, max(0, risk_score))
            confidence = 85
            
            return {
                'risk_score': int(risk_score),
                'risk_level': 'HIGH' if risk_score > 70 else 'MEDIUM' if risk_score > 40 else 'LOW',
                'confidence': confidence,
                'timestamp': datetime.now().isoformat(),
                'model': 'risk_analysis'
            }
        except Exception as e:
            return {'error': str(e)}


class FraudDetectionModel:
    """Model deteksi fraud"""
    
    def predict(self, data):
        """Deteksi kemungkinan fraud"""
        try:
            transaction_amount = data.get('amount', 0)
            user_history = data.get('user_history', [])
            transaction_speed = data.get('speed', 1)  # transactions per hour
            
            fraud_score = 0
            
            # Unusual amount
            if user_history:
                avg_amount = np.mean(user_history)
                if transaction_amount > avg_amount * 3:
                    fraud_score += 40
            
            # High transaction speed
            if transaction_speed > 10:
                fraud_score += 30
            
            # Random factor for demonstration
            fraud_score += np.random.randint(0, 20)
            
            fraud_score = min(100, fraud_score)
            is_fraud = fraud_score > 60
            confidence = 80 if fraud_score > 70 or fraud_score < 30 else 65
            
            return {
                'fraud_score': int(fraud_score),
                'is_fraud': is_fraud,
                'confidence': confidence,
                'timestamp': datetime.now().isoformat(),
                'model': 'fraud_detection'
            }
        except Exception as e:
            return {'error': str(e)}


# Initialize AI Engine
ai_engine = AIEngine()


@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'timestamp': datetime.now().isoformat()})


@app.route('/predict', methods=['POST'])
def predict():
    """Main prediction endpoint"""
    try:
        data = request.json
        model_type = data.get('model_type')
        input_data = data.get('data', {})
        
        if not model_type:
            return jsonify({'error': 'model_type required'}), 400
        
        result = ai_engine.predict(model_type, input_data)
        return jsonify(result)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/models', methods=['GET'])
def list_models():
    """List available models"""
    return jsonify({
        'models': list(ai_engine.models.keys()),
        'timestamp': datetime.now().isoformat()
    })


if __name__ == '__main__':
    print("🤖 AI Engine starting...")
    print("Available models:", list(ai_engine.models.keys()))
    app.run(host='0.0.0.0', port=5001, debug=True)
