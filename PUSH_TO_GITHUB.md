# 🚀 Push to GitHub - Authentication Guide

## ❌ Error: Permission Denied (403)

You're getting this error because Git needs authentication to push to GitHub.

## ✅ Solution: Choose One Method

### Method 1: GitHub CLI (Recommended - Easiest)

```bash
# Install GitHub CLI
brew install gh

# Login to GitHub
gh auth login

# Follow the prompts:
# - Choose: GitHub.com
# - Choose: HTTPS
# - Authenticate with: Login with a web browser
# - Copy the code and paste in browser

# After authentication, push again
git push -u origin main
```

### Method 2: Personal Access Token (PAT)

#### Step 1: Create Personal Access Token

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Note: `Smart Contract 2.0 - Push Access`
4. Expiration: 90 days (or your preference)
5. Select scopes:
   - ✅ `repo` (Full control of private repositories)
6. Click "Generate token"
7. **COPY THE TOKEN** (you won't see it again!)

#### Step 2: Use Token to Push

```bash
# Remove old remote
git remote remove origin

# Add remote with token
git remote add origin https://YOUR_TOKEN@github.com/IdcuqS07/smart-contract-2.0.git

# Push
git push -u origin main
```

**Replace `YOUR_TOKEN` with the token you copied!**

### Method 3: SSH Key (Most Secure)

#### Step 1: Generate SSH Key

```bash
# Generate new SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Press Enter to accept default location
# Enter passphrase (optional but recommended)

# Start ssh-agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519
```

#### Step 2: Add SSH Key to GitHub

```bash
# Copy SSH public key to clipboard
pbcopy < ~/.ssh/id_ed25519.pub

# Or display it to copy manually
cat ~/.ssh/id_ed25519.pub
```

1. Go to: https://github.com/settings/keys
2. Click "New SSH key"
3. Title: `MacBook Air - Smart Contract 2.0`
4. Paste the key
5. Click "Add SSH key"

#### Step 3: Change Remote to SSH

```bash
# Remove HTTPS remote
git remote remove origin

# Add SSH remote
git remote add origin git@github.com:IdcuqS07/smart-contract-2.0.git

# Push
git push -u origin main
```

---

## 🎯 Quick Fix (Recommended)

**Use GitHub CLI - It's the easiest!**

```bash
# Install
brew install gh

# Login
gh auth login

# Push
git push -u origin main
```

---

## ✅ After Successful Push

You should see:

```
Enumerating objects: 65, done.
Counting objects: 100% (65/65), done.
Delta compression using up to 8 threads
Compressing objects: 100% (60/60), done.
Writing objects: 100% (65/65), 150.23 KiB | 5.01 MiB/s, done.
Total 65 (delta 5), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (5/5), done.
To https://github.com/IdcuqS07/smart-contract-2.0.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

---

## 🏷️ Create Release Tag

After successful push:

```bash
# Create tag
git tag -a v1.0.0 -m "Release v1.0.0 - Initial stable release"

# Push tag
git push origin v1.0.0
```

---

## 🎉 Verify on GitHub

Visit: https://github.com/IdcuqS07/smart-contract-2.0

You should see all your files!

---

## 🆘 Still Having Issues?

### Check Git Configuration

```bash
# Check current config
git config --list

# Check remote
git remote -v

# Check branch
git branch
```

### Reset and Try Again

```bash
# Remove remote
git remote remove origin

# Add remote again (with correct authentication)
git remote add origin https://github.com/IdcuqS07/smart-contract-2.0.git

# Push
git push -u origin main
```

---

## 💡 Pro Tips

1. **Use GitHub CLI** - Simplest method, handles auth automatically
2. **Use SSH** - Most secure for long-term use
3. **Use PAT** - Good for automation/scripts
4. **Never commit tokens** - Add to .gitignore

---

**Need help?** Run one of the methods above and try pushing again!
