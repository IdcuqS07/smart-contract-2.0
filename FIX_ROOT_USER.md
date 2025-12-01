# 🔧 Fix: Running as Root User

## ⚠️ Masalah

Script mendeteksi Anda running sebagai root user, yang tidak recommended untuk security.

---

## ✅ Solusi 1: Create Non-Root User (Recommended)

```bash
# 1. Create user baru
adduser smartcontract

# 2. Masukkan password ketika diminta
# (Pilih password yang kuat)

# 3. Skip info lainnya (tekan Enter)

# 4. Add user ke sudo group
usermod -aG sudo smartcontract

# 5. Copy project ke home directory user baru
cp -r /root/smart-contract-2.0 /home/smartcontract/
chown -R smartcontract:smartcontract /home/smartcontract/smart-contract-2.0

# 6. Switch ke user baru
su - smartcontract

# 7. Navigate ke project
cd ~/smart-contract-2.0

# 8. Jalankan deployment script
./scripts/deploy-to-vps.sh
```

---

## ⚡ Solusi 2: Use Root Script (Not Recommended)

Jika Anda tetap ingin menggunakan root (untuk testing/development):

```bash
# Di directory: /root/smart-contract-2.0

# Pull latest changes
git pull origin main

# Make script executable
chmod +x scripts/deploy-to-vps-root.sh

# Run root version
./scripts/deploy-to-vps-root.sh
```

Script akan meminta konfirmasi karena running as root tidak aman.

---

## 🎯 Kenapa Non-Root Lebih Baik?

### Security Risks dengan Root:
- ❌ Jika ada bug/exploit, attacker punya full system access
- ❌ Accidental commands bisa merusak system
- ❌ Services running as root = security vulnerability
- ❌ Tidak ada isolation antara services

### Benefits Non-Root User:
- ✅ Limited permissions = limited damage
- ✅ Better security isolation
- ✅ Industry best practice
- ✅ Easier to manage permissions
- ✅ Safer for production

---

## 📋 Quick Commands

### Create User (Copy-Paste Friendly)

```bash
# All in one command
adduser smartcontract && \
usermod -aG sudo smartcontract && \
cp -r /root/smart-contract-2.0 /home/smartcontract/ && \
chown -R smartcontract:smartcontract /home/smartcontract/smart-contract-2.0 && \
echo "✅ User created! Now run: su - smartcontract"
```

Then:
```bash
su - smartcontract
cd ~/smart-contract-2.0
./scripts/deploy-to-vps.sh
```

---

## 🔍 Verify User Setup

```bash
# Check if user exists
id smartcontract

# Check sudo access
sudo -l -U smartcontract

# Check file ownership
ls -la /home/smartcontract/smart-contract-2.0
```

---

## 💡 Pro Tips

1. **Use SSH Keys**: Setup SSH key authentication for the new user
2. **Disable Root SSH**: Edit `/etc/ssh/sshd_config` and set `PermitRootLogin no`
3. **Use Sudo**: Always use `sudo` for admin commands, not root login
4. **Monitor Access**: Check `/var/log/auth.log` for login attempts

---

## 🚀 After Creating User

Your workflow will be:

```bash
# SSH as regular user (not root)
ssh smartcontract@143.198.205.88

# Navigate to project
cd ~/smart-contract-2.0

# Run commands with sudo when needed
sudo systemctl restart nginx

# Check services
pm2 status
```

---

## ❓ FAQ

**Q: Saya sudah terlanjur clone di /root, harus clone ulang?**  
A: Tidak, tinggal copy ke home directory user baru (lihat command di atas)

**Q: Password user baru lupa?**  
A: Reset dengan: `sudo passwd smartcontract`

**Q: Bisa pakai username lain selain 'smartcontract'?**  
A: Bisa! Ganti 'smartcontract' dengan username pilihan Anda

**Q: Kalau tetap mau pakai root?**  
A: Gunakan `scripts/deploy-to-vps-root.sh` tapi tidak recommended

---

## 🎯 Recommended: Create User Now

Pilih salah satu:

### Option A: Manual Step-by-Step
```bash
adduser smartcontract
usermod -aG sudo smartcontract
cp -r /root/smart-contract-2.0 /home/smartcontract/
chown -R smartcontract:smartcontract /home/smartcontract/smart-contract-2.0
su - smartcontract
cd ~/smart-contract-2.0
./scripts/deploy-to-vps.sh
```

### Option B: One-Liner
```bash
adduser smartcontract && usermod -aG sudo smartcontract && cp -r /root/smart-contract-2.0 /home/smartcontract/ && chown -R smartcontract:smartcontract /home/smartcontract/smart-contract-2.0 && su - smartcontract
```

Then in new shell:
```bash
cd ~/smart-contract-2.0
./scripts/deploy-to-vps.sh
```

---

**Recommendation: Create non-root user untuk security yang lebih baik!** 🔒
