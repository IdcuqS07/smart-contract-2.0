# Steering Rules for Smart Contract 2.0

This directory contains coding standards and best practices for the Smart Contract 2.0 project.

## 📋 Available Rules

### 1. **rust-standards.md**
Rust coding standards for Linera smart contracts:
- Naming conventions (snake_case, PascalCase, SCREAMING_SNAKE_CASE)
- Project structure
- Error handling with `Result<T, E>`
- State management patterns
- Linera-specific contract and service implementations
- Security best practices
- Testing standards
- Documentation requirements

### 2. **python-standards.md**
Python standards for AI Engine:
- Type hints for all functions
- Flask API route structure
- Pydantic input validation
- Model class patterns
- Data preprocessing standards
- Error handling with custom exceptions
- Testing with pytest
- Comprehensive documentation

### 3. **javascript-standards.md**
JavaScript/Node.js standards for Oracle Service:
- Modern ES6+ syntax (const/let, arrow functions, destructuring)
- Express.js API patterns
- GraphQL schema and resolvers
- WebSocket implementation
- Security patterns (validation, rate limiting, authentication)
- Error handling
- Testing with Jest/Supertest
- JSDoc documentation

### 4. **security-standards.md**
Security best practices across all layers:
- Input validation at every layer
- Rate limiting (API and contract level)
- JWT authentication
- API key management
- Data sanitization
- CORS configuration
- Environment variable security
- Error handling without information leakage
- Logging best practices
- Dependency security
- Smart contract security (reentrancy, overflow protection)
- AI-Oracle integration security

### 5. **testing-standards.md**
Comprehensive testing guidelines:
- Unit tests (individual functions)
- Integration tests (component interactions)
- E2E tests (complete workflows)
- Test coverage targets (80%+)
- Mocking external services
- Test fixtures
- Coverage tools for each language

### 6. **websocket-standards.md**
WebSocket implementation patterns:
- Server setup with connection management
- Client implementation with reconnection logic
- Subscription/unsubscribe patterns
- Heartbeat mechanism
- Linera WebSocket integration
- Security (origin validation, rate limiting)
- Error handling

### 7. **graphql-standards.md**
GraphQL patterns for Linera integration:
- Schema design (types, queries, mutations, subscriptions)
- Resolver implementation
- Error handling with custom errors
- DataSources pattern
- Context setup
- Linera-specific queries and subscriptions

### 8. **linera-patterns.md**
Linera blockchain-specific patterns:
- Application structure
- Contract operations and messages
- Service queries
- GraphQL integration with Linera
- Cross-chain communication
- State management best practices
- Error handling
- Testing patterns

### 9. **deployment-checklist.md**
Pre-deployment checklist:
- Code quality checks
- Smart contract validation
- AI Engine verification
- Oracle Service testing
- Environment configuration
- Linera deployment steps
- Frontend build
- Security verification
- Monitoring setup
- Documentation updates
- Performance targets
- Post-deployment verification

## 🎯 How These Rules Work

### Always Included
All rules are set with `inclusion: always`, meaning they are automatically included in every AI interaction to ensure consistent code quality.

### Language-Specific
Rules are organized by technology stack:
- **Rust**: Smart contracts on Linera
- **Python**: AI/ML models and Flask APIs
- **JavaScript**: Oracle service, GraphQL, WebSocket

### Cross-Cutting Concerns
Some rules apply across all languages:
- Security standards
- Testing standards
- Deployment checklist

## 🚀 Usage

When working on the project, Kiro will automatically:
1. Apply relevant coding standards
2. Suggest best practices
3. Validate security patterns
4. Ensure consistent style
5. Follow Linera-specific patterns

## 📝 Updating Rules

To update or add new rules:
1. Edit existing `.md` files in `.kiro/steering/`
2. Add new files with frontmatter: `---\ninclusion: always\n---`
3. Use code examples to illustrate patterns
4. Keep rules concise and actionable

## 🔍 Quick Reference

### For Smart Contracts (Rust)
- Use `Result<T, E>` for errors
- `BTreeMap` for ordered collections
- `saturating_add` for arithmetic
- Validate all inputs
- Document with `///` comments

### For AI Engine (Python)
- Type hints everywhere
- Pydantic for validation
- Custom exceptions
- Comprehensive logging
- pytest for testing

### For Oracle Service (JavaScript)
- Modern ES6+ syntax
- Express middleware pattern
- GraphQL with Apollo
- WebSocket with reconnection
- Rate limiting on all endpoints

### For Security
- Validate at every layer
- Rate limit everything
- Never expose secrets
- Sanitize all inputs
- Use HTTPS in production

### For Testing
- 80%+ coverage
- Mock external services
- Test error cases
- E2E for critical flows
- CI/CD integration

## 📚 Related Documentation

- [ARCHITECTURE.md](../../ARCHITECTURE.md) - System architecture
- [DEPLOYMENT.md](../../DEPLOYMENT.md) - Deployment guide
- [TESTING_GUIDE.md](../../TESTING_GUIDE.md) - Testing procedures
- [CONTRIBUTING.md](../../CONTRIBUTING.md) - Contribution guidelines

## 🎓 Learning Resources

### Linera
- [Linera Documentation](https://linera.dev)
- [Linera SDK](https://docs.rs/linera-sdk)

### Rust
- [The Rust Book](https://doc.rust-lang.org/book/)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)

### Python
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [Flask Documentation](https://flask.palletsprojects.com/)

### JavaScript
- [MDN Web Docs](https://developer.mozilla.org/)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)

---

**Note**: These rules are living documents. Update them as the project evolves and new patterns emerge.
