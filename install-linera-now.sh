#!/bin/bash

# Install Linera CLI from source
# This will take 10-15 minutes

echo "🚀 Installing Linera CLI from source..."
echo "This will take 10-15 minutes. Please wait..."
echo ""

cd ~/linera-protocol

# Install linera-service
echo "📦 Building and installing linera-service..."
cargo install --path linera-service 2>&1 | grep -E "(Compiling|Installing|Finished)" | tail -20

# Check installation
if command -v linera &> /dev/null; then
    echo ""
    echo "✅ Linera CLI installed successfully!"
    echo ""
    linera --version
    echo ""
    echo "📍 Installation location:"
    which linera
    echo ""
else
    echo ""
    echo "❌ Installation failed or linera not in PATH"
    echo ""
    echo "Try adding to PATH:"
    echo "  export PATH=\"\$HOME/.cargo/bin:\$PATH\""
    echo ""
fi
