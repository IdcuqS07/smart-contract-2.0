// AI Prediction Service
const BinanceAPI = require('./binance-api');
require('dotenv').config();

class AIPrediction {
    constructor() {
        this.binance = new BinanceAPI();
    }

    async getHistoricalData(symbol, interval = '1h', limit = 50) {
        const prices = await this.binance.getKlines(symbol, interval, limit);
        if (!prices) {
            throw new Error('Failed to fetch Binance data');
        }
        return prices;
    }

    // Simple Moving Average
    calculateSMA(prices, period) {
        const sum = prices.slice(-period).reduce((a, b) => a + b, 0);
        return sum / period;
    }

    // Predict price direction using trend analysis
    async predict(symbol, timeframe = '1h') {
        const prices = await this.getHistoricalData(symbol, timeframe, 50);
        const currentPrice = prices[prices.length - 1];
        
        // Calculate SMAs
        const sma10 = this.calculateSMA(prices, 10);
        const sma20 = this.calculateSMA(prices, 20);
        
        // Trend detection
        const shortTrend = sma10 > sma20 ? 'UP' : 'DOWN';
        const momentum = ((currentPrice - prices[prices.length - 10]) / prices[prices.length - 10]) * 100;
        
        // Price prediction (simple: current + momentum)
        const predictedPrice = currentPrice * (1 + (momentum / 100));
        
        // Confidence based on trend strength
        const confidence = Math.min(Math.abs(momentum) * 10 + 60, 95);
        
        return {
            symbol,
            currentPrice: currentPrice.toFixed(2),
            predictedPrice: predictedPrice.toFixed(2),
            direction: shortTrend,
            confidence: confidence.toFixed(1),
            momentum: momentum.toFixed(2),
            timeframe,
            timestamp: new Date().toISOString(),
            action: this.getAction(shortTrend, confidence)
        };
    }

    // Get trading action based on prediction
    getAction(direction, confidence) {
        if (confidence < 70) return 'HOLD';
        return direction === 'UP' ? 'BUY' : 'SELL';
    }
}

module.exports = AIPrediction;
