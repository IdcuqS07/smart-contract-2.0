// Binance API Wrapper - Based on Ai-power-trade implementation
const axios = require('axios');

class BinanceAPI {
    constructor() {
        this.baseURL = 'https://api.binance.com/api/v3';
        this.cache = new Map();
        this.cacheDuration = 10000; // 10 seconds
        this.apiAvailable = true;
        this.lastCheckTime = 0;
        this.checkInterval = 60000; // 60 seconds
    }

    isCacheValid(key) {
        if (!this.cache.has(key)) return false;
        const cached = this.cache.get(key);
        return (Date.now() - cached.timestamp) < this.cacheDuration;
    }

    async getPrice(symbol) {
        try {
            const now = Date.now();
            if (!this.apiAvailable && (now - this.lastCheckTime) < this.checkInterval) {
                return null;
            }

            const binanceSymbol = `${symbol}USDT`;
            const cacheKey = `price_${binanceSymbol}`;

            if (this.isCacheValid(cacheKey)) {
                return this.cache.get(cacheKey).price;
            }

            const response = await axios.get(`${this.baseURL}/ticker/price`, {
                params: { symbol: binanceSymbol },
                timeout: 500
            });

            const price = parseFloat(response.data.price);
            this.cache.set(cacheKey, { price, timestamp: Date.now() });
            this.apiAvailable = true;

            return price;
        } catch (error) {
            this.apiAvailable = false;
            this.lastCheckTime = Date.now();
            return null;
        }
    }

    async get24hStats(symbol) {
        try {
            const now = Date.now();
            if (!this.apiAvailable && (now - this.lastCheckTime) < this.checkInterval) {
                return null;
            }

            const binanceSymbol = `${symbol}USDT`;
            const cacheKey = `stats_${binanceSymbol}`;

            if (this.isCacheValid(cacheKey)) {
                return this.cache.get(cacheKey).stats;
            }

            const response = await axios.get(`${this.baseURL}/ticker/24hr`, {
                params: { symbol: binanceSymbol },
                timeout: 500
            });

            const data = response.data;
            const stats = {
                price: parseFloat(data.lastPrice),
                change24h: parseFloat(data.priceChangePercent),
                high24h: parseFloat(data.highPrice),
                low24h: parseFloat(data.lowPrice),
                volume24h: parseFloat(data.volume)
            };

            this.cache.set(cacheKey, { stats, timestamp: Date.now() });
            this.apiAvailable = true;

            return stats;
        } catch (error) {
            this.apiAvailable = false;
            this.lastCheckTime = Date.now();
            return null;
        }
    }

    async getKlines(symbol, interval = '1h', limit = 50) {
        try {
            const binanceSymbol = `${symbol}USDT`;
            const cacheKey = `klines_${binanceSymbol}_${interval}_${limit}`;

            if (this.isCacheValid(cacheKey)) {
                return this.cache.get(cacheKey).klines;
            }

            const response = await axios.get(`${this.baseURL}/klines`, {
                params: { symbol: binanceSymbol, interval, limit },
                timeout: 2000
            });

            const klines = response.data.map(k => parseFloat(k[4])); // closing prices
            this.cache.set(cacheKey, { klines, timestamp: Date.now() });

            return klines;
        } catch (error) {
            console.error(`Binance klines error: ${error.message}`);
            return null;
        }
    }
}

module.exports = BinanceAPI;
