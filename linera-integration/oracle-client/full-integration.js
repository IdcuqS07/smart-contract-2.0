#!/usr/bin/env node

/**
 * Full Integration Test for Smart Contract 2.0 with Linera
 * Tests complete flow: AI Engine -> Oracle -> Linera Blockchain
 */

const LineraOracleClient = require('./linera-oracle');
const axios = require('axios');
const fs = require('fs');
const path = require('path');

// Load deployment config
const configPath = path.join(__dirname, '..', 'deployment-config.json');
let config = {};

if (fs.existsSync(configPath)) {
  config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  console.log('✅ Loaded deployment config');
} else {
  console.log('⚠️  No deployment config found, using defaults');
  config = {
    applicationId: 'YOUR_APP_ID',
    chainId: 'YOUR_CHAIN_ID',
    graphqlEndpoint: 'http://localhost:8080/graphql',
    aiEngineUrl: 'http://localhost:5001'
  };
}

// Initialize Oracle Client
const oracle = new LineraOracleClient({
  graphqlEndpoint: config.graphqlEndpoint,
  chainId: config.chainId,
  applicationId: config.applicationId,
  aiEngineUrl: config.aiEngineUrl
});

// Test scenarios
const scenarios = [
  {
    name: 'Price Prediction Contract',
    contractType: 'price_prediction',
    threshold: 50000,
    modelType: 'price_prediction',
    testData: { symbol: 'BTC', timeframe: '1h' }
  },
  {
    name: 'Risk Analysis Contract',
    contractType: 'risk_analysis',
    threshold: 75,
    modelType: 'risk_analysis',
    testData: { transaction_amount: 10000, user_history: 'good' }
  },
  {
    name: 'Fraud Detection Contract',
    contractType: 'fraud_detection',
    threshold: 80,
    modelType: 'fraud_detection',
    testData: { transaction_pattern: 'unusual', amount: 5000 }
  }
];

async function checkServices() {
  console.log('\n🔍 Checking Services...\n');
  
  // Check AI Engine
  try {
    const aiResponse = await axios.get(`${config.aiEngineUrl}/health`);
    console.log('✅ AI Engine: Running');
  } catch (error) {
    console.log('❌ AI Engine: Not running');
    console.log('   Start with: cd ai-engine && python main.py');
    return false;
  }
  
  // Check Linera GraphQL
  try {
    const lineraResponse = await axios.post(config.graphqlEndpoint, {
      query: '{ chains { list } }'
    });
    console.log('✅ Linera GraphQL: Running');
  } catch (error) {
    console.log('❌ Linera GraphQL: Not running');
    console.log('   Start with: linera service --port 8080');
    return false;
  }
  
  return true;
}

async function runScenario(scenario, index) {
  console.log(`\n${'='.repeat(60)}`);
  console.log(`📋 Scenario ${index + 1}: ${scenario.name}`);
  console.log('='.repeat(60));
  
  try {
    // Step 1: Create Adaptive Contract
    console.log('\n1️⃣  Creating adaptive contract on Linera...');
    const createResult = await oracle.createAdaptiveContract(
      scenario.contractType,
      scenario.threshold
    );
    
    if (!createResult.success) {
      throw new Error(`Failed to create contract: ${createResult.error}`);
    }
    
    const contractId = createResult.contractId;
    console.log(`   ✅ Contract created with ID: ${contractId}`);
    console.log(`   📝 Transaction hash: ${createResult.hash}`);
    
    // Step 2: Wait a bit for blockchain confirmation
    await sleep(2000);
    
    // Step 3: Query contract details
    console.log('\n2️⃣  Querying contract details...');
    const contractDetails = await oracle.getContract(contractId);
    if (contractDetails) {
      console.log('   ✅ Contract details retrieved:');
      console.log(`      - Type: ${contractDetails.contract_type}`);
      console.log(`      - Threshold: ${contractDetails.threshold}`);
      console.log(`      - Active: ${contractDetails.is_active}`);
      console.log(`      - Creator: ${contractDetails.creator}`);
    }
    
    // Step 4: Request AI Prediction and Submit
    console.log('\n3️⃣  Requesting AI prediction and submitting to blockchain...');
    const predictionResult = await oracle.requestAndSubmitPrediction(
      contractId,
      scenario.modelType,
      scenario.testData
    );
    
    if (!predictionResult.success) {
      throw new Error(`Failed to submit prediction: ${predictionResult.error}`);
    }
    
    console.log('   ✅ AI Prediction:');
    console.log(`      - Model: ${scenario.modelType}`);
    console.log(`      - Confidence: ${predictionResult.prediction.confidence}%`);
    
    if (predictionResult.prediction.prediction !== undefined) {
      console.log(`      - Predicted Price: $${predictionResult.prediction.prediction.toFixed(2)}`);
    } else if (predictionResult.prediction.risk_score !== undefined) {
      console.log(`      - Risk Score: ${predictionResult.prediction.risk_score}`);
    } else if (predictionResult.prediction.fraud_score !== undefined) {
      console.log(`      - Fraud Score: ${predictionResult.prediction.fraud_score}`);
    }
    
    console.log('\n   ✅ Blockchain Submission:');
    console.log(`      - Transaction hash: ${predictionResult.blockchain.hash}`);
    console.log(`      - Events: ${predictionResult.blockchain.events.length}`);
    
    // Step 5: Wait and query latest prediction
    await sleep(2000);
    
    console.log('\n4️⃣  Querying latest prediction from blockchain...');
    const latestPrediction = await oracle.getLatestPrediction(contractId);
    if (latestPrediction) {
      console.log('   ✅ Latest prediction retrieved:');
      console.log(`      - Type: ${latestPrediction.prediction_type}`);
      console.log(`      - Value: ${latestPrediction.value}`);
      console.log(`      - Confidence: ${latestPrediction.confidence}%`);
      console.log(`      - Oracle: ${latestPrediction.oracle}`);
      console.log(`      - Timestamp: ${new Date(latestPrediction.timestamp / 1000).toISOString()}`);
    }
    
    // Step 6: Check if contract was auto-executed
    console.log('\n5️⃣  Checking contract execution status...');
    const updatedContract = await oracle.getContract(contractId);
    if (updatedContract) {
      if (!updatedContract.is_active) {
        console.log('   🎯 Contract was AUTO-EXECUTED (threshold reached)!');
      } else {
        console.log('   ⏳ Contract still active (threshold not reached)');
      }
    }
    
    console.log(`\n✅ Scenario ${index + 1} completed successfully!`);
    
    return {
      success: true,
      contractId,
      scenario: scenario.name
    };
    
  } catch (error) {
    console.error(`\n❌ Scenario ${index + 1} failed:`, error.message);
    return {
      success: false,
      scenario: scenario.name,
      error: error.message
    };
  }
}

async function runFullIntegration() {
  console.log('\n🚀 Smart Contract 2.0 - Full Linera Integration Test');
  console.log('='.repeat(60));
  
  // Check services
  const servicesOk = await checkServices();
  if (!servicesOk) {
    console.log('\n❌ Please start all required services first!');
    process.exit(1);
  }
  
  // Run all scenarios
  const results = [];
  for (let i = 0; i < scenarios.length; i++) {
    const result = await runScenario(scenarios[i], i);
    results.push(result);
    
    // Wait between scenarios
    if (i < scenarios.length - 1) {
      console.log('\n⏳ Waiting 3 seconds before next scenario...');
      await sleep(3000);
    }
  }
  
  // Summary
  console.log('\n' + '='.repeat(60));
  console.log('📊 Integration Test Summary');
  console.log('='.repeat(60));
  
  const successful = results.filter(r => r.success).length;
  const failed = results.filter(r => !r.success).length;
  
  console.log(`\n✅ Successful: ${successful}/${results.length}`);
  console.log(`❌ Failed: ${failed}/${results.length}`);
  
  results.forEach((result, index) => {
    const icon = result.success ? '✅' : '❌';
    console.log(`\n${icon} ${result.scenario}`);
    if (result.success) {
      console.log(`   Contract ID: ${result.contractId}`);
    } else {
      console.log(`   Error: ${result.error}`);
    }
  });
  
  console.log('\n' + '='.repeat(60));
  
  if (failed === 0) {
    console.log('🎉 All integration tests passed!');
    console.log('\n📝 Next steps:');
    console.log('   1. Open frontend: cd frontend && open index.html');
    console.log('   2. Test WebSocket subscriptions');
    console.log('   3. Deploy to testnet: ./scripts/deploy-testnet.sh');
  } else {
    console.log('⚠️  Some tests failed. Please check the errors above.');
  }
  
  console.log('');
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Run if called directly
if (require.main === module) {
  runFullIntegration()
    .then(() => process.exit(0))
    .catch(error => {
      console.error('\n💥 Fatal error:', error);
      process.exit(1);
    });
}

module.exports = { runFullIntegration };
