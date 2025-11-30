// 🌐 VPS Configuration for Smart Contract 2.0
// VPS IP: 143.198.205.88

const API_CONFIG = {
  // Backend Services
  AI_ENGINE: 'http://143.198.205.88/api/ai',
  ORACLE_SERVICE: 'http://143.198.205.88/api/oracle',
  
  // Linera Blockchain
  GRAPHQL_ENDPOINT: 'http://143.198.205.88/graphql',
  WS_ENDPOINT: 'ws://143.198.205.88/ws',
  
  // API Endpoints
  ENDPOINTS: {
    // AI Engine (port 5001)
    AI_PREDICT: 'http://143.198.205.88/api/ai/predict',
    AI_HEALTH: 'http://143.198.205.88/api/ai/health',
    AI_MODELS: 'http://143.198.205.88/api/ai/models',
    
    // Oracle Service
    ORACLE_REQUEST: 'http://143.198.205.88/api/oracle/request',
    ORACLE_STATUS: 'http://143.198.205.88/api/oracle/status',
    ORACLE_HEALTH: 'http://143.198.205.88/api/oracle/health',
    
    // GraphQL
    GRAPHQL: 'http://143.198.205.88/graphql',
    GRAPHQL_WS: 'ws://143.198.205.88/ws'
  },
  
  // Configuration
  TIMEOUT: 30000, // 30 seconds
  RETRY_ATTEMPTS: 3,
  MODE: 'production'
};

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
  module.exports = API_CONFIG;
}
