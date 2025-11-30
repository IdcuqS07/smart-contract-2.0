#!/bin/bash

# Redeploy to Correct Vercel Account
# This script helps redeploy to idcuq-santosos-projects

set -e

echo "🔄 Redeploying Smart Contract 2.0 to Correct Vercel Account"
echo "=========================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Get project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo ""
echo -e "${BLUE}Step 1: Checking Vercel CLI...${NC}"
if ! command -v vercel &> /dev/null; then
    echo -e "${RED}❌ Vercel CLI not found${NC}"
    echo "Install: npm install -g vercel"
    exit 1
fi
echo -e "${GREEN}✅ Vercel CLI found${NC}"

echo ""
echo -e "${BLUE}Step 2: Current Vercel Account${NC}"
CURRENT_USER=$(vercel whoami 2>&1 | grep -v "Vercel CLI" | grep -v "Update available" | grep -v "Changelog" | grep -v "Run" | grep -v "^$" | head -1 | sed 's/> //' | xargs)

if [ -z "$CURRENT_USER" ]; then
    echo -e "${YELLOW}⚠️  Not logged in${NC}"
else
    echo -e "Current account: ${YELLOW}$CURRENT_USER${NC}"
    
    if [ "$CURRENT_USER" != "idcuq-santosos" ] && [ "$CURRENT_USER" != "idcuqsantoso" ]; then
        echo -e "${YELLOW}⚠️  Wrong account detected${NC}"
        echo ""
        echo -e "${BLUE}Logging out...${NC}"
        vercel logout
        echo -e "${GREEN}✅ Logged out${NC}"
    else
        echo -e "${GREEN}✅ Correct account${NC}"
    fi
fi

echo ""
echo -e "${BLUE}Step 3: Login to Correct Account${NC}"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT:${NC}"
echo "1. Browser will open"
echo "2. Login with: idcuq-santosos (or similar)"
echo "3. Authorize Vercel CLI"
echo ""
echo -e "${BLUE}Press ENTER to continue...${NC}"
read

vercel login

echo ""
echo -e "${GREEN}✅ Login complete${NC}"

echo ""
echo -e "${BLUE}Step 4: Verify Account${NC}"
NEW_USER=$(vercel whoami 2>&1 | grep -v "Vercel CLI" | grep -v "Update available" | grep -v "Changelog" | grep -v "Run" | grep -v "^$" | head -1 | sed 's/> //' | xargs)
echo -e "Logged in as: ${GREEN}$NEW_USER${NC}"

echo ""
echo -e "${BLUE}Step 5: Remove Old Deployment Config${NC}"
rm -rf .vercel
echo -e "${GREEN}✅ Old config removed${NC}"

echo ""
echo -e "${BLUE}Step 6: Deploy to Production${NC}"
echo ""
echo -e "${YELLOW}⚠️  During deployment:${NC}"
echo "- Select scope: idcuq-santosos-projects (or similar)"
echo "- Project name: smartcontract2-linera (or keep default)"
echo "- Confirm all settings"
echo ""
echo -e "${BLUE}Press ENTER to start deployment...${NC}"
read

vercel --prod

echo ""
echo "=========================================="
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo "=========================================="
echo ""
echo -e "${BLUE}Step 7: Get Production URL${NC}"
echo ""
vercel ls --prod | head -5

echo ""
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "1. Copy the production URL above"
echo "2. Update README.md with new URL"
echo "3. Update SUBMISSION.md with new URL"
echo "4. Commit and push changes"
echo ""
echo -e "${GREEN}Done! 🚀${NC}"
