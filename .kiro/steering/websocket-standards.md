---
inclusion: always
---

# WebSocket Implementation Guidelines

## Server Setup

```javascript
const WebSocket = require('ws');
const http = require('http');

class WebSocketServer {
  constructor(server) {
    this.wss = new WebSocket.Server({ server });
    this.clients = new Map();
    this.subscriptions = new Map();
    
    this.setupHandlers();
  }
  
  setupHandlers() {
    this.wss.on('connection', (ws, req) => {
      const clientId = this.generateClientId();
      
      this.clients.set(clientId, {
        ws,
        subscriptions: new Set(),
        metadata: {
          connectedAt: Date.now(),
          ip: req.socket.remoteAddress
        }
      });
      
      console.log(`[WS] Client connected: ${clientId}`);
      
      // Send welcome message
      this.send(ws, {
        type: 'connected',
        clientId,
        timestamp: Date.now()
      });
      
      ws.on('message', (message) => {
        this.handleMessage(clientId, message);
      });
      
      ws.on('close', () => {
        this.handleDisconnect(clientId);
      });
      
      ws.on('error', (error) => {
        console.error(`[WS] Error for ${clientId}:`, error);
      });
      
      // Heartbeat
      ws.isAlive = true;
      ws.on('pong', () => {
        ws.isAlive = true;
      });
    });
    
    // Heartbeat interval
    this.heartbeatInterval = setInterval(() => {
      this.wss.clients.forEach((ws) => {
        if (ws.isAlive === false) {
          return ws.terminate();
        }
        ws.isAlive = false;
        ws.ping();
      });
    }, 30000);
  }
  
  handleMessage(clientId, message) {
    try {
      const data = JSON.parse(message);
      
      switch (data.type) {
        case 'subscribe':
          this.handleSubscribe(clientId, data.payload);
          break;
        case 'unsubscribe':
          this.handleUnsubscribe(clientId, data.payload);
          break;
        case 'ping':
          this.handlePing(clientId);
          break;
        default:
          this.sendError(clientId, `Unknown message type: ${data.type}`);
      }
    } catch (error) {
      this.sendError(clientId, `Invalid message format: ${error.message}`);
    }
  }
  
  handleSubscribe(clientId, { channel }) {
    const client = this.clients.get(clientId);
    if (!client) return;
    
    client.subscriptions.add(channel);
    
    if (!this.subscriptions.has(channel)) {
      this.subscriptions.set(channel, new Set());
    }
    this.subscriptions.get(channel).add(clientId);
    
    this.send(client.ws, {
      type: 'subscribed',
      channel,
      timestamp: Date.now()
    });
    
    console.log(`[WS] ${clientId} subscribed to ${channel}`);
  }
  
  handleUnsubscribe(clientId, { channel }) {
    const client = this.clients.get(clientId);
    if (!client) return;
    
    client.subscriptions.delete(channel);
    this.subscriptions.get(channel)?.delete(clientId);
    
    this.send(client.ws, {
      type: 'unsubscribed',
      channel,
      timestamp: Date.now()
    });
  }
  
  handleDisconnect(clientId) {
    const client = this.clients.get(clientId);
    if (!client) return;
    
    // Remove from all subscriptions
    client.subscriptions.forEach(channel => {
      this.subscriptions.get(channel)?.delete(clientId);
    });
    
    this.clients.delete(clientId);
    console.log(`[WS] Client disconnected: ${clientId}`);
  }
  
  broadcast(channel, data) {
    const subscribers = this.subscriptions.get(channel);
    if (!subscribers) return;
    
    const message = JSON.stringify({
      type: 'message',
      channel,
      data,
      timestamp: Date.now()
    });
    
    subscribers.forEach(clientId => {
      const client = this.clients.get(clientId);
      if (client && client.ws.readyState === WebSocket.OPEN) {
        client.ws.send(message);
      }
    });
  }
  
  send(ws, data) {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify(data));
    }
  }
  
  sendError(clientId, message) {
    const client = this.clients.get(clientId);
    if (client) {
      this.send(client.ws, {
        type: 'error',
        message,
        timestamp: Date.now()
      });
    }
  }
  
  generateClientId() {
    return `client_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
  
  close() {
    clearInterval(this.heartbeatInterval);
    this.wss.close();
  }
}

module.exports = WebSocketServer;
```

## Client Implementation

```javascript
class WebSocketClient {
  constructor(url) {
    this.url = url;
    this.ws = null;
    this.reconnectAttempts = 0;
    this.maxReconnectAttempts = 5;
    this.reconnectDelay = 1000;
    this.handlers = new Map();
  }
  
  connect() {
    return new Promise((resolve, reject) => {
      this.ws = new WebSocket(this.url);
      
      this.ws.onopen = () => {
        console.log('[WS] Connected');
        this.reconnectAttempts = 0;
        resolve();
      };
      
      this.ws.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          this.handleMessage(data);
        } catch (error) {
          console.error('[WS] Parse error:', error);
        }
      };
      
      this.ws.onclose = () => {
        console.log('[WS] Disconnected');
        this.attemptReconnect();
      };
      
      this.ws.onerror = (error) => {
        console.error('[WS] Error:', error);
        reject(error);
      };
    });
  }
  
  attemptReconnect() {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      console.error('[WS] Max reconnect attempts reached');
      return;
    }
    
    this.reconnectAttempts++;
    const delay = this.reconnectDelay * Math.pow(2, this.reconnectAttempts - 1);
    
    console.log(`[WS] Reconnecting in ${delay}ms (attempt ${this.reconnectAttempts})`);
    
    setTimeout(() => {
      this.connect().catch(console.error);
    }, delay);
  }
  
  subscribe(channel, handler) {
    this.handlers.set(channel, handler);
    this.send({
      type: 'subscribe',
      payload: { channel }
    });
  }
  
  unsubscribe(channel) {
    this.handlers.delete(channel);
    this.send({
      type: 'unsubscribe',
      payload: { channel }
    });
  }
  
  handleMessage(data) {
    const { type, channel, data: payload } = data;
    
    if (type === 'message' && channel) {
      const handler = this.handlers.get(channel);
      if (handler) {
        handler(payload);
      }
    }
  }
  
  send(data) {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(data));
    }
  }
  
  close() {
    if (this.ws) {
      this.ws.close();
    }
  }
}
```

## Linera WebSocket Integration

```javascript
// Subscribe to Linera chain events
function subscribeToLineraChain(chainId) {
  const ws = new WebSocket(process.env.LINERA_WS_URL);
  
  ws.on('open', () => {
    ws.send(JSON.stringify({
      query: `
        subscription {
          notifications(chainId: "${chainId}") {
            reason
            chainId
          }
        }
      `
    }));
  });
  
  ws.on('message', (data) => {
    const event = JSON.parse(data);
    console.log('Linera event:', event);
    
    // Broadcast to connected clients
    wsServer.broadcast('linera-events', event);
  });
}
```

## Security

```javascript
// Validate origin
wss.on('connection', (ws, req) => {
  const origin = req.headers.origin;
  const allowedOrigins = process.env.ALLOWED_ORIGINS.split(',');
  
  if (!allowedOrigins.includes(origin)) {
    ws.close(1008, 'Origin not allowed');
    return;
  }
  
  // Continue with connection
});

// Rate limiting per client
const rateLimits = new Map();

function checkRateLimit(clientId) {
  const now = Date.now();
  const limit = rateLimits.get(clientId) || { count: 0, resetAt: now + 60000 };
  
  if (now > limit.resetAt) {
    limit.count = 0;
    limit.resetAt = now + 60000;
  }
  
  limit.count++;
  rateLimits.set(clientId, limit);
  
  return limit.count <= 100; // 100 messages per minute
}
```
