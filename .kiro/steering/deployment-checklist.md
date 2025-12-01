---
inclusion: always
---

# Pre-Deployment Checklist for Linera

## Code Quality

- [ ] All tests passing (unit, integration, E2E)
- [ ] Code coverage >= 80%
- [ ] No linting errors
- [ ] No security vulnerabilities (`npm audit`, `cargo audit`)
- [ ] All dependencies up to date
- [ ] Code reviewed and approved

## Smart Contract (Rust)

- [ ] Contract compiles without warnings
- [ ] All operations tested
- [ ] State management validated
- [ ] Error handling comprehensive
- [ ] Rate limiting implemented
- [ ] Input validation on all operations
- [ ] Gas optimization reviewed
- [ ] Reentrancy protection in place

```bash
# Build and test
cd linera-integration
cargo build --release
cargo test
cargo clippy -- -D warnings
```

## AI Engine (Python)

- [ ] All models trained and saved
- [ ] Model accuracy validated
- [ ] API endpoints tested
- [ ] Error handling implemented
- [ ] Input validation on all routes
- [ ] Rate limiting configured
- [ ] Logging configured
- [ ] Environment variables set

```bash
# Test AI engine
cd ai-engine
python -m pytest tests/ -v
python -m pylint *.py
```

## Oracle Service (Node.js)

- [ ] All API routes tested
- [ ] GraphQL schema validated
- [ ] WebSocket connections tested
- [ ] Error handling comprehensive
- [ ] Rate limiting configured
- [ ] CORS properly configured
- [ ] Authentication implemented
- [ ] Logging configured

```bash
# Test oracle service
cd oracle-service
npm test
npm run lint
```

## Environment Configuration

- [ ] `.env.example` updated with all variables
- [ ] Production `.env` configured
- [ ] API keys secured
- [ ] Database credentials secured
- [ ] JWT secrets generated
- [ ] CORS origins configured
- [ ] Rate limits configured

```bash
# Required environment variables
LINERA_GRAPHQL_URL=
LINERA_WS_URL=
AI_ENGINE_URL=
ORACLE_API_KEY=
JWT_SECRET=
ALLOWED_ORIGINS=
```

## Linera Deployment

- [ ] Linera CLI installed
- [ ] Wallet configured
- [ ] Testnet connection verified
- [ ] Contract bytecode built
- [ ] Application published
- [ ] Chain created
- [ ] GraphQL endpoint accessible
- [ ] WebSocket endpoint accessible

```bash
# Deploy to Linera
linera wallet show
linera publish-and-create target/wasm32-unknown-unknown/release/*.wasm
linera service --port 8080
```

## Frontend

- [ ] Build successful
- [ ] All pages load correctly
- [ ] API integration tested
- [ ] WebSocket connection tested
- [ ] Error handling implemented
- [ ] Loading states implemented
- [ ] Mobile responsive
- [ ] Browser compatibility tested

```bash
# Build frontend
cd frontend
npm run build
npm run test
```

## Security

- [ ] All inputs validated
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Rate limiting active
- [ ] Authentication required
- [ ] Authorization checked
- [ ] Secrets not in code
- [ ] HTTPS enforced
- [ ] Security headers configured

## Monitoring & Logging

- [ ] Application logging configured
- [ ] Error tracking setup
- [ ] Performance monitoring setup
- [ ] Uptime monitoring configured
- [ ] Alert thresholds set
- [ ] Log rotation configured

## Documentation

- [ ] README updated
- [ ] API documentation complete
- [ ] Deployment guide updated
- [ ] Architecture documented
- [ ] Troubleshooting guide updated
- [ ] Examples provided

## Performance

- [ ] Load testing completed
- [ ] Response times acceptable
- [ ] Database queries optimized
- [ ] Caching implemented
- [ ] CDN configured (if applicable)
- [ ] Bundle size optimized

## Backup & Recovery

- [ ] Backup strategy defined
- [ ] Database backups configured
- [ ] Recovery procedure documented
- [ ] Rollback plan prepared

## Final Checks

- [ ] Staging environment tested
- [ ] Production environment ready
- [ ] DNS configured
- [ ] SSL certificates installed
- [ ] Monitoring dashboards setup
- [ ] Team notified
- [ ] Rollback plan ready
- [ ] Post-deployment tests prepared

## Post-Deployment

- [ ] Smoke tests passed
- [ ] Monitoring active
- [ ] Logs being collected
- [ ] Performance metrics normal
- [ ] No errors in logs
- [ ] Users can access application
- [ ] All features working
- [ ] Documentation updated with production URLs

## Linera-Specific Checks

### Contract Deployment

```bash
# Verify contract is deployed
linera query-application <APPLICATION_ID>

# Test GraphQL endpoint
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ chain { executionState { system { balance } } } }"}'

# Test WebSocket
wscat -c ws://localhost:8080/ws
```

### Performance Targets

- [ ] Transaction finality < 1 second
- [ ] GraphQL query response < 100ms
- [ ] WebSocket latency < 50ms
- [ ] API response time < 200ms
- [ ] AI prediction time < 3 seconds

### Scaling Considerations

- [ ] Multiple validator nodes configured
- [ ] Load balancer setup (if needed)
- [ ] Database connection pooling
- [ ] Redis caching (if needed)
- [ ] Horizontal scaling tested
