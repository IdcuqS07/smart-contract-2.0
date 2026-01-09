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
        
        // Fallback to CoinGecko with caching
        const coinIds = { 'BTC': 'bitcoin', 'ETH': 'ethereum', 'SOL': 'solana', 'BNB': 'binancecoin' };
        const coinId = coinIds[symbol];
        
        if (!coinId) {
            throw new Error(`Unsupported symbol: ${symbol}`);
        }
        
        // Check cache first
        const cacheKey = `coingecko_${coinId}_${limit}`;
        if (this.binance.isCacheValid(cacheKey)) {
            return this.binance.cache.get(cacheKey).prices;
        }
        
        // Add delay to avoid rate limit
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        const response = await axios.get(
            `https://api.coingecko.com/api/v3/coins/${coinId}/market_chart`,
            {
                params: { vs_currency: 'usd', days: 2 },
                timeout: 5000
            }
        );
        
        const prices = response.data.prices.slice(-limit).map(p => p[1]);
        
        // Cache for 60 seconds
        this.binance.cache.set(cacheKey, { prices, timestamp: Date.now() });
        
        return prices;
    }

    // Simple Moving Average
    calculateSMA(prices, period) {
        const sum = prices.slice(-period).reduce((a, b) => a + b, 0);
        return sum / period;
    }

    // Exponential Moving Average (lebih responsive)
    calculateEMA(prices, period) {
        const k = 2 / (period + 1);
        let ema = prices[0];
        for (let i = 1; i < prices.length; i++) {
            ema = prices[i] * k + ema * (1 - k);
        }
        return ema;
    }

    // RSI (Relative Strength Index)
    calculateRSI(prices, period = 14) {
        const changes = [];
        for (let i = 1; i < prices.length; i++) {
            changes.push(prices[i] - prices[i - 1]);
        }
        
        const gains = changes.map(c => c > 0 ? c : 0);
        const losses = changes.map(c => c < 0 ? -c : 0);
        
        const avgGain = gains.slice(-period).reduce((a, b) => a + b, 0) / period;
        const avgLoss = losses.slice(-period).reduce((a, b) => a + b, 0) / period;
        
        if (avgLoss === 0) return 100;
        const rs = avgGain / avgLoss;
        return 100 - (100 / (1 + rs));
    }

    // MACD (Moving Average Convergence Divergence)
    calculateMACD(prices) {
        const ema12 = this.calculateEMA(prices, 12);
        const ema26 = this.calculateEMA(prices, 26);
        return ema12 - ema26;
    }

    // Bollinger Bands
    calculateBollingerBands(prices, period = 20) {
        const sma = this.calculateSMA(prices, period);
        const slice = prices.slice(-period);
        const variance = slice.reduce((sum, price) => sum + Math.pow(price - sma, 2), 0) / period;
        const stdDev = Math.sqrt(variance);
        
        return {
            upper: sma + (stdDev * 2),
            middle: sma,
            lower: sma - (stdDev * 2)
        };
    }

    // Advanced prediction using multiple indicators
    async predict(symbol, timeframe = '1h') {
        const prices = await this.getHistoricalData(symbol, timeframe, 50);
        const currentPrice = prices[prices.length - 1];
        
        // Calculate all indicators
        const sma10 = this.calculateSMA(prices, 10);
        const sma20 = this.calculateSMA(prices, 20);
        const sma50 = this.calculateSMA(prices, 50);
        const ema12 = this.calculateEMA(prices, 12);
        const ema26 = this.calculateEMA(prices, 26);
        const rsi = this.calculateRSI(prices);
        const macd = this.calculateMACD(prices);
        const bb = this.calculateBollingerBands(prices);
        
        // Trend detection (multiple signals)
        let bullishSignals = 0;
        let bearishSignals = 0;
        
        // SMA trend
        if (sma10 > sma20 && sma20 > sma50) bullishSignals++;
        if (sma10 < sma20 && sma20 < sma50) bearishSignals++;
        
        // EMA crossover
        if (ema12 > ema26) bullishSignals++;
        if (ema12 < ema26) bearishSignals++;
        
        // RSI signals
        if (rsi < 30) bullishSignals += 2; // Oversold - strong buy
        if (rsi > 70) bearishSignals += 2; // Overbought - strong sell
        if (rsi > 40 && rsi < 60) bullishSignals++; // Neutral momentum
        
        // MACD signal
        if (macd > 0) bullishSignals++;
        if (macd < 0) bearishSignals++;
        
        // Bollinger Bands
        if (currentPrice < bb.lower) bullishSignals += 2; // Price below lower band
        if (currentPrice > bb.upper) bearishSignals += 2; // Price above upper band
        
        // Calculate momentum
        const momentum = ((currentPrice - prices[prices.length - 10]) / prices[prices.length - 10]) * 100;
        
        // Determine direction and confidence
        const totalSignals = bullishSignals + bearishSignals;
        const direction = bullishSignals > bearishSignals ? 'UP' : 'DOWN';
        const signalStrength = Math.abs(bullishSignals - bearishSignals);
        
        // Confidence based on signal strength and RSI
        let confidence = Math.min((signalStrength / totalSignals) * 100, 95);
        
        // Adjust confidence based on RSI extremes
        if (rsi < 25 || rsi > 75) confidence = Math.min(confidence + 10, 98);
        
        // Price prediction using weighted indicators
        const trendFactor = (sma10 - sma20) / sma20;
        const predictedPrice = currentPrice * (1 + trendFactor + (momentum / 100));
        
        return {
            symbol,
            currentPrice: currentPrice.toFixed(2),
            predictedPrice: predictedPrice.toFixed(2),
            direction,
            confidence: confidence.toFixed(1),
            momentum: momentum.toFixed(2),
            timeframe,
            timestamp: new Date().toISOString(),
            action: this.getAction(direction, confidence, rsi),
            indicators: {
                rsi: rsi.toFixed(2),
                macd: macd.toFixed(2),
                sma10: sma10.toFixed(2),
                sma20: sma20.toFixed(2),
                ema12: ema12.toFixed(2),
                ema26: ema26.toFixed(2),
                bollingerUpper: bb.upper.toFixed(2),
                bollingerLower: bb.lower.toFixed(2),
                bullishSignals,
                bearishSignals
            }
        };
    }

    // Get trading action based on prediction and RSI
    getAction(direction, confidence, rsi) {
        // Strong signals
        if (rsi < 30 && confidence > 75) return 'BUY'; // Oversold + high confidence
        if (rsi > 70 && confidence > 75) return 'SELL'; // Overbought + high confidence
        
        // Normal signals
        if (confidence < 65) return 'HOLD'; // Low confidence
        
        return direction === 'UP' ? 'BUY' : 'SELL';
    }
}

module.exports = AIPrediction;
