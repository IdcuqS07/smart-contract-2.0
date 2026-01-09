// API Server - Connect AI + Smart Contract
const express = require('express');
const cors = require('cors');
const AIPrediction = require('./ai-prediction');
const SmartContractExecutor = require('./smart-contract-executor');
const BinanceAPI = require('./binance-api');

const app = express();
const ai = new AIPrediction();
const executor = new SmartContractExecutor();
const binance = new BinanceAPI();

app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'live', service: 'AI + Blockchain Integration' });
});

// Get current price (Binance API with CoinGecko fallback)
app.get('/api/price/:symbol', async (req, res) => {
    try {
        const { symbol } = req.params;
        
        // Try Binance first
        let price = await binance.getPrice(symbol);
        
        // Fallback to CoinGecko if Binance fails
        if (!price) {
            const axios = require('axios');
            const coinIds = { 'BTC': 'bitcoin', 'ETH': 'ethereum', 'SOL': 'solana', 'BNB': 'binancecoin' };
            const coinId = coinIds[symbol] || 'bitcoin';
            
            try {
                const response = await axios.get(`https://api.coingecko.com/api/v3/simple/price?ids=${coinId}&vs_currencies=usd`, {
                    timeout: 3000
                });
                price = response.data[coinId].usd;
            } catch (error) {
                return res.status(503).json({ success: false, error: 'All price APIs unavailable' });
            }
        }
        
        res.json({ 
            success: true, 
            symbol,
            price: price.toFixed(2),
            timestamp: new Date().toISOString()
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Get AI prediction
app.post('/api/predict', async (req, res) => {
    try {
        const { symbol, timeframe } = req.body;
        const prediction = await ai.predict(symbol || 'BTC', timeframe || '1h');
        res.json({ success: true, prediction });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Create smart contract from prediction
app.post('/api/contract/create', async (req, res) => {
    try {
        const { symbol, timeframe, amount, riskLevel } = req.body;
        
        const prediction = await ai.predict(symbol || 'BTC', timeframe || '1h');
        const contract = executor.createContract(prediction, amount || 100, riskLevel || 'MEDIUM');
        
        res.json({ 
            success: true, 
            contract,
            message: `Contract created: ${contract.action} ${contract.symbol} at $${contract.entryPrice}`
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Execute contract
app.post('/api/contract/execute/:id', async (req, res) => {
    try {
        const contractId = parseInt(req.params.id);
        const { currentPrice } = req.body;
        
        const contract = executor.executeContract(contractId, currentPrice);
        
        res.json({ 
            success: true, 
            contract,
            message: `Contract executed at $${contract.executionPrice}`
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Get contract status
app.get('/api/contract/:id', (req, res) => {
    try {
        const contractId = parseInt(req.params.id);
        const contract = executor.getContract(contractId);
        
        if (!contract) {
            return res.status(404).json({ success: false, error: 'Contract not found' });
        }
        
        res.json({ success: true, contract });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Get all contracts
app.get('/api/contracts', (req, res) => {
    try {
        const contracts = executor.getAllContracts();
        res.json({ success: true, contracts, total: contracts.length });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Auto-execute flow: Predict + Create + Execute
app.post('/api/auto-trade', async (req, res) => {
    try {
        const { symbol, timeframe, amount, riskLevel } = req.body;
        
        const prediction = await ai.predict(symbol || 'BTC', timeframe || '1h');
        const contract = executor.createContract(prediction, amount || 100, riskLevel || 'MEDIUM');
        
        if (prediction.action !== 'HOLD') {
            executor.executeContract(contract.id, prediction.currentPrice);
        }
        
        res.json({ 
            success: true, 
            prediction,
            contract: executor.getContract(contract.id),
            message: `Auto-trade completed: ${contract.action} ${contract.symbol}`
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`🚀 AI + Blockchain server running on port ${PORT}`);
    console.log(`📊 AI Prediction: http://localhost:${PORT}/api/predict`);
    console.log(`💰 Live Price: http://localhost:${PORT}/api/price/BTC`);
    console.log(`⚡ Auto-Trade: http://localhost:${PORT}/api/auto-trade`);
});
