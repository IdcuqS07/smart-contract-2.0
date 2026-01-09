// Smart Contract Executor - Auto-execute based on AI prediction
class SmartContractExecutor {
    constructor() {
        this.contracts = new Map();
        this.contractIdCounter = 1000;
    }

    // Create contract based on AI prediction
    createContract(prediction, amount, riskLevel = 'MEDIUM') {
        const contractId = this.contractIdCounter++;
        
        const contract = {
            id: contractId,
            symbol: prediction.symbol,
            action: prediction.action,
            entryPrice: parseFloat(prediction.currentPrice),
            targetPrice: parseFloat(prediction.predictedPrice),
            amount: amount,
            confidence: parseFloat(prediction.confidence),
            status: 'PENDING',
            createdAt: new Date().toISOString(),
            riskLevel: riskLevel,
            stopLoss: this.calculateStopLoss(prediction, riskLevel),
            takeProfit: this.calculateTakeProfit(prediction, riskLevel)
        };

        this.contracts.set(contractId, contract);
        return contract;
    }

    // Calculate stop loss based on risk level
    calculateStopLoss(prediction, riskLevel) {
        const price = parseFloat(prediction.currentPrice);
        const riskPercent = {
            'LOW': 0.02,    // 2%
            'MEDIUM': 0.05, // 5%
            'HIGH': 0.10    // 10%
        }[riskLevel];

        return prediction.direction === 'UP' 
            ? (price * (1 - riskPercent)).toFixed(2)
            : (price * (1 + riskPercent)).toFixed(2);
    }

    // Calculate take profit
    calculateTakeProfit(prediction, riskLevel) {
        const price = parseFloat(prediction.currentPrice);
        const profitPercent = {
            'LOW': 0.03,    // 3%
            'MEDIUM': 0.08, // 8%
            'HIGH': 0.15    // 15%
        }[riskLevel];

        return prediction.direction === 'UP'
            ? (price * (1 + profitPercent)).toFixed(2)
            : (price * (1 - profitPercent)).toFixed(2);
    }

    // Execute contract (simulate blockchain execution)
    executeContract(contractId, currentPrice) {
        const contract = this.contracts.get(contractId);
        if (!contract) throw new Error('Contract not found');

        contract.status = 'EXECUTED';
        contract.executedAt = new Date().toISOString();
        contract.executionPrice = currentPrice;

        return contract;
    }

    // Check if contract should be executed
    shouldExecute(contractId, currentPrice) {
        const contract = this.contracts.get(contractId);
        if (!contract || contract.status !== 'PENDING') return false;

        const price = parseFloat(currentPrice);
        const stopLoss = parseFloat(contract.stopLoss);
        const takeProfit = parseFloat(contract.takeProfit);

        // Check stop loss or take profit hit
        if (contract.action === 'BUY') {
            return price <= stopLoss || price >= takeProfit;
        } else {
            return price >= stopLoss || price <= takeProfit;
        }
    }

    // Get contract status
    getContract(contractId) {
        return this.contracts.get(contractId);
    }

    // Get all contracts
    getAllContracts() {
        return Array.from(this.contracts.values());
    }
}

module.exports = SmartContractExecutor;
