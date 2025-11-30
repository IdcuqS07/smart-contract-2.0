/**
 * Vercel Serverless Function untuk AI Engine
 */

class AIEngine {
  constructor() {
    this.models = {
      'price_prediction': this.pricePrediction,
      'risk_analysis': this.riskAnalysis,
      'fraud_detection': this.fraudDetection
    };
  }

  pricePrediction(data) {
    const prices = data.prices || [];
    if (prices.length < 2) {
      return { error: 'Insufficient data' };
    }

    const recentPrices = prices.slice(-5);
    const avg = recentPrices.reduce((a, b) => a + b, 0) / recentPrices.length;
    const trend = (prices[prices.length - 1] - prices[0]) / prices.length;
    const predicted = avg + trend * 2;

    const volatility = Math.sqrt(
      recentPrices.reduce((sum, p) => sum + Math.pow(p - avg, 2), 0) / recentPrices.length
    );
    const confidence = Math.max(50, Math.min(95, Math.floor(100 - volatility * 10)));

    return {
      prediction: parseFloat(predicted.toFixed(2)),
      confidence,
      timestamp: new Date().toISOString(),
      model: 'price_prediction'
    };
  }

  riskAnalysis(data) {
    const amount = data.amount || 0;
    const historyScore = data.history_score || 50;
    const volatility = data.volatility || 0.5;

    let riskScore = 0;
    if (amount > 10000) riskScore += 30;
    else if (amount > 5000) riskScore += 20;
    else riskScore += 10;

    riskScore += (100 - historyScore) * 0.3;
    riskScore += volatility * 40;
    riskScore = Math.min(100, Math.max(0, Math.floor(riskScore)));

    return {
      risk_score: riskScore,
      risk_level: riskScore > 70 ? 'HIGH' : riskScore > 40 ? 'MEDIUM' : 'LOW',
      confidence: 85,
      timestamp: new Date().toISOString(),
      model: 'risk_analysis'
    };
  }

  fraudDetection(data) {
    const amount = data.amount || 0;
    const userHistory = data.user_history || [];
    const speed = data.speed || 1;

    let fraudScore = 0;
    if (userHistory.length > 0) {
      const avgAmount = userHistory.reduce((a, b) => a + b, 0) / userHistory.length;
      if (amount > avgAmount * 3) fraudScore += 40;
    }

    if (speed > 10) fraudScore += 30;
    fraudScore += Math.floor(Math.random() * 20);
    fraudScore = Math.min(100, fraudScore);

    return {
      fraud_score: fraudScore,
      is_fraud: fraudScore > 60,
      confidence: fraudScore > 70 || fraudScore < 30 ? 80 : 65,
      timestamp: new Date().toISOString(),
      model: 'fraud_detection'
    };
  }

  predict(modelType, data) {
    if (!this.models[modelType]) {
      return { error: 'Model not found' };
    }
    return this.models[modelType].call(this, data);
  }
}

const aiEngine = new AIEngine();

export default async function handler(req, res) {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET' && req.url === '/api/ai/health') {
    return res.status(200).json({
      status: 'healthy',
      timestamp: new Date().toISOString()
    });
  }

  if (req.method === 'GET' && req.url === '/api/ai/models') {
    return res.status(200).json({
      models: Object.keys(aiEngine.models),
      timestamp: new Date().toISOString()
    });
  }

  if (req.method === 'POST' && req.url === '/api/ai/predict') {
    try {
      const { model_type, data } = req.body;

      if (!model_type) {
        return res.status(400).json({ error: 'model_type required' });
      }

      const result = aiEngine.predict(model_type, data || {});
      return res.status(200).json(result);
    } catch (error) {
      return res.status(500).json({ error: error.message });
    }
  }

  return res.status(404).json({ error: 'Not found' });
}
