#!/bin/bash

set -e

echo "🔨 Building Smart Contract 2.0 for Linera..."
echo ""

cd "$(dirname "$0")/.."

echo "Step 1: Clean previous builds"
cargo clean

echo ""
echo "Step 2: Build for WASM target"
cargo build --release --target wasm32-unknown-unknown

echo ""
echo "✅ Build successful!"
echo ""
echo "📦 WASM artifacts:"
ls -lh target/wasm32-unknown-unknown/release/*.wasm

echo ""
echo "📊 WASM file size:"
du -h target/wasm32-unknown-unknown/release/smart_contract_2_linera.wasm

echo ""
echo "🎉 Smart Contract 2.0 is ready for deployment!"
