#!/bin/bash

# Simple AI Engine Test - No Blockchain Required
# This tests the AI models without needing Linera

echo "🤖 Testing AI Engine - No Blockchain Required"
echo "=============================================="
echo ""

# Check if AI Engine is running
if curl -s http://localhost:5001/health > /dev/null 2>&1; then
    echo "✅ AI Engine already running"
else
    echo "⏳ Starting AI Engine..."
    cd ai-engine
    
    # Check if venv exists
    if [ ! -d "venv" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv venv
        source venv/bin/activate
        pip install -r requirements.txt
    else
        source venv/bin/activate
    fi
    
    # Start AI Engine in background
    python main.py &
    AI_PID=$!
    
    echo "Waiting for AI Engine to start..."
    sleep 5
    
    cd ..
fi

echo ""
echo "🧪 Running AI Tests..."
echo "====================="
echo ""

# Test 1: Price Prediction
echo "1️⃣  Testing Price Prediction Model..."
RESULT=$(curl -s -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type": "price_prediction", "data": {"symbol": "BTC", "timeframe": "1h"}}')

if echo "$RESULT" | grep -q "prediction"; then
    echo "✅ Price Prediction: WORKING"
    echo "   Result: $RESULT"
else
    echo "❌ Price Prediction: FAILED"
fi

echo ""

# Test 2: Risk Analysis
echo "2️⃣  Testing Risk Analysis Model..."
RESULT=$(curl -s -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type": "risk_analysis", "data": {"transaction_amount": 10000}}')

if echo "$RESULT" | grep -q "risk_score"; then
    echo "✅ Risk Analysis: WORKING"
    echo "   Result: $RESULT"
else
    echo "❌ Risk Analysis: FAILED"
fi

echo ""

# Test 3: Fraud Detection
echo "3️⃣  Testing Fraud Detection Model..."
RESULT=$(curl -s -X POST http://localhost:5001/predict \
  -H "Content-Type: application/json" \
  -d '{"model_type": "fraud_detection", "data": {"transaction_pattern": "unusual"}}')

if echo "$RESULT" | grep -q "fraud_score"; then
    echo "✅ Fraud Detection: WORKING"
    echo "   Result: $RESULT"
else
    echo "❌ Fraud Detection: FAILED"
fi

echo ""
echo "=============================================="
echo "🎉 AI Engine Testing Complete!"
echo ""
echo "📊 Summary:"
echo "  - All 3 AI models tested"
echo "  - No blockchain required"
echo "  - Ready for integration"
echo ""
echo "🚀 Next Steps:"
echo "  1. Install Linera CLI"
echo "  2. Deploy smart contract"
echo "  3. Run full integration"
echo ""
echo "📚 See QUICK_FIX.md for detailed instructions"
echo ""
