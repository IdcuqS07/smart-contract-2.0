# 📝 Manual Redeploy Guide - Step by Step

## Tujuan
Deploy ulang ke account: `idcuq-santosos-projects`

---

## 🚀 Langkah-Langkah (Copy-Paste Commands)

### 1. Logout dari Account Lama
```bash
vercel logout
```
**Expected:** `Success! Logged out!`

---

### 2. Login ke Account yang Benar
```bash
vercel login
```

**Yang Terjadi:**
- Terminal akan show URL: `https://vercel.com/oauth/device?user_code=XXXX-XXXX`
- Browser akan terbuka otomatis
- Login dengan account `idcuq-santosos`
- Klik "Authorize"
- Kembali ke terminal

**Expected:** `Success! Logged in as idcuq-santosos`

---

### 3. Verify Account
```bash
vercel whoami
```
**Expected:** Harus show `idcuq-santosos` atau `idcuqsantoso`

---

### 4. Hapus Config Lama
```bash
rm -rf .vercel
```
**Expected:** No output (silent success)

---

### 5. Deploy ke Production
```bash
vercel --prod
```

**Yang Terjadi:**
- Vercel akan ask beberapa pertanyaan
- **Set up and deploy:** Yes
- **Which scope:** Pilih `idcuq-santosos-projects`
- **Link to existing project:** No
- **Project name:** `smartcontract2-linera` (atau biarkan default)
- **Directory:** `.` (default)
- **Override settings:** No

**Expected:** 
```
✅ Production: https://smartcontract2-linera-xxx.vercel.app
```

---

### 6. Verify Deployment
```bash
vercel ls --prod
```
**Expected:** List deployments under `idcuq-santosos-projects`

---

### 7. Get Production URL
```bash
vercel --prod
```
**Expected:** Shows production URL

---

## 📋 Quick Copy-Paste All Commands

```bash
# Run these one by one
vercel logout
vercel login
# (login via browser)
vercel whoami
rm -rf .vercel
vercel --prod
# (answer questions)
vercel ls --prod
```

---

## ✅ Success Indicators

After successful deployment, you should see:

1. **Account:** `idcuq-santosos` or `idcuqsantoso`
2. **Scope:** `idcuq-santosos-projects`
3. **URL:** `https://smartcontract2-linera-xxx-idcuq-santosos-projects.vercel.app`
   or `https://smartcontract2-linera.vercel.app`

---

## 📝 After Deployment

### Update Documentation with New URL

**Files to update:**
1. `README.md`
2. `SUBMISSION.md`
3. `FINAL_STATUS.md`
4. `DEPLOYMENT_SUMMARY.md`

**Find and replace:**
```
OLD: https://smartcontract2-linera-k55m8vkgz-0xcryptotechs-projects.vercel.app
NEW: <your-new-production-url>
```

**Commands:**
```bash
# Get new URL
NEW_URL=$(vercel --prod 2>&1 | grep "https://" | head -1 | awk '{print $NF}')
echo "New URL: $NEW_URL"

# Update files (manual or use sed)
# Then commit
git add -A
git commit -m "chore: update deployment URL to correct account"
git push origin main
```

---

## 🐛 Troubleshooting

### Problem: "Project already exists"
```bash
vercel --prod --name smartcontract2-linera-v2
```

### Problem: "Authentication failed"
```bash
vercel logout
vercel login
# Make sure to complete browser authentication
```

### Problem: "Wrong scope selected"
```bash
rm -rf .vercel
vercel --prod
# Carefully select correct scope this time
```

### Problem: "Deployment failed"
```bash
# Check logs
vercel logs

# Try again
vercel --prod --force
```

---

## 💡 Tips

1. **Browser Authentication:** Make sure browser opens and you complete the login
2. **Scope Selection:** Carefully select `idcuq-santosos-projects` when asked
3. **Project Name:** Use `smartcontract2-linera` for consistency
4. **Patience:** Deployment takes 1-2 minutes

---

## 🎯 Expected Final Result

**Production URL:**
```
https://smartcontract2-linera.vercel.app
```
or
```
https://smartcontract2-linera-<hash>-idcuq-santosos-projects.vercel.app
```

**Vercel Dashboard:**
```
https://vercel.com/idcuq-santosos-projects/smartcontract2-linera
```

---

**Ready? Start with Step 1! 🚀**

**Command to start:**
```bash
vercel logout
```
