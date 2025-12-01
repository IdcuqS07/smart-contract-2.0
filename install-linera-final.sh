#!/bin/bash

# Final Linera CLI Installation Script
# This will take 10-15 minutes

echo "🚀 Installing Linera CLI"
echo "======================="
echo ""
echo "⏰ This will take 10-15 minutes..."
echo "☕ Time for coffee!"
echo ""

# Check if repository exists
if [ ! -d "$HOME/linera-protocol" ]; then
    echo "📥 Cloning Linera repository..."
    git clone --depth 1 https://github.com/linera-io/linera-protocol.git ~/linera-protocol
    echo "✅ Repository cloned"
    echo ""
fi

# Navigate to repository
cd ~/linera-protocol

# Install linera-service
echo "🔨 Building and installing Linera CLI..."
echo "   (This is the long part - 10-15 minutes)"
echo ""

cargo install --path linera-service

# Check installation
echo ""
echo "🔍 Verifying installation..."
echo ""

if command -v linera &> /dev/null; then
    echo "✅ SUCCESS! Linera CLI installed!"
    echo ""
    echo "📍 Version:"
    linera --version
    echo ""
    echo "📍 Location:"
    which linera
    echo ""
    echo "🎉 Installation complete!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Initialize wallet: linera wallet init --with-new-chain"
    echo "   2. Start service: linera service --port 8080"
    echo "   3. Deploy contract: See LINERA_SETUP_COMPLETE.md"
    echo ""
else
    echo "❌ Installation failed or linera not in PATH"
    echo ""
    echo "Try adding to PATH:"
    echo "   export PATH=\"\$HOME/.cargo/bin:\$PATH\""
    echo "   echo 'export PATH=\"\$HOME/.cargo/bin:\$PATH\"' >> ~/.zshrc"
    echo ""
    echo "Then verify:"
    echo "   linera --version"
    echo ""
fi
