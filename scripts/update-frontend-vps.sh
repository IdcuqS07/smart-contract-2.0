#!/bin/bash

# 🚀 Update Frontend to Use VPS Backend
# VPS IP: 143.198.205.88

set -e

echo "🚀 Updating Frontend to Use VPS Backend"
echo "========================================"
echo ""
echo "VPS IP: 143.198.205.88"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Copy VPS config
echo -e "${GREEN}📝 Step 1: Copying VPS configuration...${NC}"
cp frontend/index-vps.html frontend/index.html
cp frontend/config-vps.js frontend/config.js

# Step 2: Update Vercel config
echo -e "${GREEN}📝 Step 2: Updating Vercel configuration...${NC}"
cat > vercel.json << 'EOF'
{
  "version": 2,
  "builds": [
    {
      "src": "frontend/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/frontend/$1"
    }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Access-Control-Allow-Origin",
          "value": "*"
        },
        {
          "key": "Access-Control-Allow-Methods",
          "value": "GET, POST, PUT, DELETE, OPTIONS"
        },
        {
          "key": "Access-Control-Allow-Headers",
          "value": "Content-Type, Authorization"
        }
      ]
    }
  ]
}
EOF

# Step 3: Git commit
echo -e "${GREEN}📝 Step 3: Committing changes...${NC}"
git add frontend/index.html frontend/config.js vercel.json
git commit -m "Update frontend to use VPS backend (143.198.205.88)" || echo "No changes to commit"

# Step 4: Push to GitHub
echo -e "${GREEN}📤 Step 4: Pushing to GitHub...${NC}"
git push origin main || git push origin master

# Step 5: Deploy to Vercel
echo -e "${GREEN}🚀 Step 5: Deploying to Vercel...${NC}"
cd frontend

if command -v vercel &> /dev/null; then
    vercel --prod
else
    echo -e "${YELLOW}⚠️  Vercel CLI not installed. Install with: npm i -g vercel${NC}"
    echo "Then run: cd frontend && vercel --prod"
fi

cd ..

echo ""
echo -e "${GREEN}✅ Frontend Updated!${NC}"
echo "========================================"
echo ""
echo -e "${YELLOW}📊 Configuration:${NC}"
echo "  VPS IP: 143.198.205.88"
echo "  AI Engine: http://143.198.205.88/api/ai"
echo "  Oracle: http://143.198.205.88/api/oracle"
echo "  GraphQL: http://143.198.205.88/graphql"
echo ""
echo -e "${YELLOW}🌐 Vercel URL:${NC}"
echo "  https://smartcontract2-linera-eight.vercel.app/"
echo ""
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "  1. Verify VPS backend is running"
echo "  2. Test frontend at Vercel URL"
echo "  3. Check all API connections"
echo ""
echo -e "${GREEN}🎉 Done!${NC}"
