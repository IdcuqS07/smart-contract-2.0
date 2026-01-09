// AI Prediction Service - Simple Moving Average + Trend Analysis
const axios = require('axios');
require('dotenv').config();

class AIPrediction {
    constructor() {
        this.binanceAPI = 'https://api.binance.com/api/v3';
        this.apiKey = process.env.BINANCE_API_KEY;
        this.apiSecret = process.env.BINANCE_API_SECRET;
    }

    // Get historical price data
    async getHistoricalData(symbol, interval = '1h', limit = 24) {
        const endpoints = [
            'https://api.binance.com/api/v3',
            'https://api1.binance.com/api/v3',
            'https://api2.binance.com/api/v3'
        ];

        for (const endpoint of endpoints) {
            try {
                const url = `${endpoint}/klines?symbol=${symbol}USDT&interval=${interval}&limit=${limit}`;
                const config = {
                    timeout: 8000,
                    headers: this.apiKey ? { 'X-MBX-APIKEY': this.apiKey } : {}
                };
                console.log(`Trying ${endpoint}...`);
                const response = await axios.get(url, config);
                console.log(`✅ Success!`);
                return response.data.map(candle => parseFloat(candle[4]));
            } catch (error) {
                console.log(`❌ ${endpoint} failed: ${error.message}`);
            }
        }
        
        throw new Error('All Binance endpoints failed. Check network/firewall.');
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
