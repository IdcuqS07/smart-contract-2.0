/**
 * Test script for Linera Oracle Client
 */

require('dotenv').config();
const LineraOracleClient = require('./linera-oracle');

async function main() {
  console.log('🧪 Testing Linera Oracle Client\n');

  // Initialize client
  const oracle = new LineraOracleClient({
    graphqlEndpoint: process.env.GRAPHQL_ENDPOINT,
    chainId: process.env.CHAIN_ID,
    applicationId: process.env.APPLICATION_ID,
    ownerAddress: process.env.OWNER_ADDRESS,
    aiEngineUrl: process.env.AI_ENGINE_URL || 'http://localhost:5001'
  });

  console.log('📋 Configuration:');
  console.log('  GraphQL:', process.env.GRAPHQL_ENDPOINT);
  console.log('  Chain ID:', process.env.CHAIN_ID);
  console.log('  App ID:', process.env.APPLICATION_ID);
  console.log('  AI Engine:', process.env.AI_ENGINE_URL || 'http://localhost:5001');
  console.log('');

  try {
    // Test 1: Create Adaptive Contract
    console.log('📝 Test 1: Creating adaptive contract...');
    const createResult = await oracle.createAdaptiveContract('insurance', 7000);
    
    if (createResult.success) {
      console.log('✅ Contract created successfully!');
      console.log('   Contract ID:', createResult.contractId);
      console.log('   TX Hash:', createResult.hash);
      
      const contractId = createResult.contractId;
      
      // Test 2: Submit AI Prediction
      console.log('\n🤖 Test 2: Submitting AI prediction...');
      const predictionResult = await oracle.requestAndSubmitPrediction(
        contractId,
        'risk_analysis',
        {
          amount: 5000,
          history_score: 75,
          volatility: 0.3
        }
      );
      
      if (predictionResult.success) {
        console.log('✅ Prediction submitted successfully!');
        console.log('   Risk Score:', predictionResult.prediction.risk_score);
        console.log('   Risk Level:', predictionResult.prediction.risk_level);
        console.log('   Confidence:', predictionResult.prediction.confidence + '%');
        console.log('   TX Hash:', predictionResult.blockchain.hash);
      } else {
        console.log('❌ Prediction failed:', predictionResult.error);
      }
      
      // Test 3: Query Contract
      console.log('\n📊 Test 3: Querying contract...');
      const contract = await oracle.getContract(contractId);
      
      if (contract) {
        console.log('✅ Contract retrieved:');
        console.log('   ID:', contract.id);
        console.log('   Type:', contract.contract_type);
        console.log('   Threshold:', contract.threshold);
        console.log('   Active:', contract.is_active);
      } else {
        console.log('❌ Failed to retrieve contract');
      }
      
      // Test 4: Get Latest Prediction
      console.log('\n🔍 Test 4: Getting latest prediction...');
      const latestPrediction = await oracle.getLatestPrediction(contractId);
      
      if (latestPrediction) {
        console.log('✅ Latest prediction retrieved:');
        console.log('   Type:', latestPrediction.prediction_type);
        console.log('   Value:', latestPrediction.value);
        console.log('   Confidence:', latestPrediction.confidence + '%');
      } else {
        console.log('❌ Failed to retrieve prediction');
      }
      
      // Test 5: Price Prediction
      console.log('\n📈 Test 5: Testing price prediction...');
      const priceResult = await oracle.requestAndSubmitPrediction(
        contractId,
        'price_prediction',
        {
          prices: [100, 105, 110, 108, 112]
        }
      );
      
      if (priceResult.success) {
        console.log('✅ Price prediction successful!');
        console.log('   Predicted Price:', priceResult.prediction.prediction);
        console.log('   Confidence:', priceResult.prediction.confidence + '%');
      }
      
      // Test 6: Fraud Detection
      console.log('\n🔍 Test 6: Testing fraud detection...');
      const fraudResult = await oracle.requestAndSubmitPrediction(
        contractId,
        'fraud_detection',
        {
          amount: 10000,
          user_history: [1000, 1200, 1100],
          speed: 5
        }
      );
      
      if (fraudResult.success) {
        console.log('✅ Fraud detection successful!');
        console.log('   Fraud Score:', fraudResult.prediction.fraud_score);
        console.log('   Is Fraud:', fraudResult.prediction.is_fraud);
        console.log('   Confidence:', fraudResult.prediction.confidence + '%');
      }
      
      console.log('\n🎉 All tests completed successfully!');
      
    } else {
      console.log('❌ Failed to create contract:', createResult.error);
    }
    
  } catch (error) {
    console.error('\n❌ Test failed with error:', error.message);
    console.error(error.stack);
  }
}

// Run tests
main().catch(console.error);
