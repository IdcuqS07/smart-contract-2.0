// AI Prediction Service
const BinanceAPI = require('./binance-api');
require('dotenv').config();

class AIPrediction {
    constructor() {
        this.binance = new BinanceAPI();
    }

    async getHistoricalData(symbol, interval = '1h', limit = 50) {
        const axios = require('axios');
        
        // Try Binance first
        try {
            const prices = await this.binance.getKlines(symbol, interval, limit);
            if (prices && prices.length > 0) {
                return prices;
            }
        } catch (e) {
            console.log('Binance failed, trying CoinGecko...');
        }
        
        // Fallback to CoinGecko
        const coinIds = { 'BTC': 'bitcoin', 'ETH': 'ethereum', 'SOL': 'solana', 'BNB': 'binancecoin' };
        const coinId = coinIds[symbol];
        
        if (!coinId) {
            throw new Error(`Unsupported symbol: ${symbol}`);
        }
        
        const response = await axios.get(
            `https://api.coingecko.com/api/v3/coins/${coinId}/market_chart`,
            {
                params: { vs_currency: 'usd', days: 2 },
                timeout: 5000
            }
        );
        
        const prices = response.data.prices.slice(-limit).map(p => p[1]);
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
