# 🤝 Contributing to Smart Contract 2.0

First off, thank you for considering contributing to Smart Contract 2.0! It's people like you that make this project great.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## 🚀 Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/smart-contract-2.0.git`
3. Add upstream remote: `git remote add upstream https://github.com/ORIGINAL_OWNER/smart-contract-2.0.git`
4. Create a new branch: `git checkout -b feature/your-feature-name`

## 💻 Development Setup

### Prerequisites

- Node.js v18+
- Python 3.8+
- Rust (for Linera integration)
- Git

### Installation

```bash
# Install Node.js dependencies
npm install

# Install Python dependencies
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r ai-engine/requirements.txt

# Install Rust (for Linera)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup target add wasm32-unknown-unknown

# Compile contracts
npm run compile

# Build Linera contracts
cd linera-integration
cargo build --release --target wasm32-unknown-unknown
```

### Running Tests

```bash
# Ethereum contracts
npm test

# AI Engine
python -m pytest ai-engine/tests/

# Linera contracts
cd linera-integration
cargo test
```

## 🎯 How to Contribute

### Reporting Bugs

- Use the GitHub issue tracker
- Check if the bug has already been reported
- Use the bug report template
- Include detailed steps to reproduce
- Add screenshots if applicable

### Suggesting Features

- Use the GitHub issue tracker
- Use the feature request template
- Explain the use case
- Provide examples if possible

### Code Contributions

1. **Find an issue** to work on or create a new one
2. **Comment** on the issue to let others know you're working on it
3. **Fork** the repository
4. **Create a branch** from `develop`
5. **Make your changes**
6. **Write tests** for your changes
7. **Update documentation** if needed
8. **Submit a pull request**

## 📝 Coding Standards

### JavaScript/Node.js

- Use ES6+ features
- Follow Airbnb style guide
- Use meaningful variable names
- Add JSDoc comments for functions
- Keep functions small and focused

```javascript
/**
 * Submit AI prediction to blockchain
 * @param {number} contractId - Contract ID
 * @param {string} predictionType - Type of prediction
 * @param {number} value - Prediction value
 * @param {number} confidence - Confidence score (0-100)
 * @returns {Promise<Object>} Transaction result
 */
async function submitPrediction(contractId, predictionType, value, confidence) {
  // Implementation
}
```

### Python

- Follow PEP 8 style guide
- Use type hints
- Add docstrings for functions
- Keep functions small and focused

```python
def predict_price(prices: List[float]) -> Dict[str, Any]:
    """
    Predict future price based on historical data.
    
    Args:
        prices: List of historical prices
        
    Returns:
        Dictionary containing prediction and confidence
    """
    # Implementation
```

### Rust (Linera)

- Follow Rust style guide
- Use meaningful variable names
- Add documentation comments
- Handle errors properly

```rust
/// Submit AI prediction to contract
pub async fn submit_prediction(
    &mut self,
    contract_id: u64,
    prediction_type: String,
    value: i64,
    confidence: u8,
) -> Result<(), ContractError> {
    // Implementation
}
```

### Solidity

- Follow Solidity style guide
- Use NatSpec comments
- Follow security best practices
- Keep contracts modular

```solidity
/**
 * @notice Submit AI prediction from oracle
 * @param _contractId Contract ID
 * @param _predictionType Type of prediction
 * @param _value Prediction value
 * @param _confidence Confidence score (0-100)
 */
function submitAIPrediction(
    uint256 _contractId,
    string memory _predictionType,
    int256 _value,
    uint8 _confidence
) external {
    // Implementation
}
```

## 📝 Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```
feat(ai-engine): add sentiment analysis model

Add new sentiment analysis model for social media data.
Includes training data and evaluation metrics.

Closes #123
```

```
fix(oracle): resolve CORS issue in Linera client

Update CORS headers to allow cross-origin requests
from frontend application.

Fixes #456
```

## 🔄 Pull Request Process

1. **Update documentation** - Ensure README and other docs are updated
2. **Add tests** - All new features must have tests
3. **Pass CI/CD** - All tests must pass
4. **Update CHANGELOG** - Add entry for your changes
5. **Request review** - Tag relevant maintainers
6. **Address feedback** - Make requested changes
7. **Squash commits** - Keep history clean
8. **Merge** - Maintainer will merge when approved

### PR Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests passing
- [ ] No new warnings
- [ ] CHANGELOG updated

## 🏗️ Project Structure

```
smart-contract-2.0/
├── contracts/              # Ethereum contracts (Solidity)
├── linera-integration/     # Linera contracts (Rust)
├── ai-engine/             # AI models (Python)
├── oracle-service/        # Oracle service (Node.js)
├── frontend/              # Web interface
├── test/                  # Tests
├── scripts/               # Utility scripts
└── docs/                  # Documentation
```

## 🎨 Areas to Contribute

### High Priority

- [ ] Additional AI models
- [ ] Performance optimizations
- [ ] Security audits
- [ ] Documentation improvements
- [ ] Test coverage

### Medium Priority

- [ ] UI/UX improvements
- [ ] Additional blockchain integrations
- [ ] Monitoring and analytics
- [ ] Developer tools

### Low Priority

- [ ] Code refactoring
- [ ] Style improvements
- [ ] Minor bug fixes

## 📚 Resources

- [Ethereum Development](https://ethereum.org/developers)
- [Linera Documentation](https://linera.dev)
- [Solidity Docs](https://docs.soliditylang.org)
- [Rust Book](https://doc.rust-lang.org/book/)
- [Python Guide](https://docs.python-guide.org)

## 💬 Communication

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas
- **Discord**: Real-time chat (link in README)
- **Email**: For security issues only

## 🙏 Thank You!

Your contributions make Smart Contract 2.0 better for everyone. We appreciate your time and effort!

---

**Questions?** Feel free to ask in GitHub Discussions or Discord!
