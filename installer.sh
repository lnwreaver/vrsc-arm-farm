#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "======================================"
echo "  VRSC ARM FARM INSTALLER (FARM MODE) "
echo "======================================"

# ===== FARM MODE : no question =====
export DEBIAN_FRONTEND=noninteractive

yes | pkg update
yes | pkg upgrade
yes | pkg install git curl nano termux-api

# ===== BASIC VAR =====
BASE="$HOME/vrsc"
REPO_URL="https://github.com/lnwreaver/vrsc-arm-farm.git"

mkdir -p "$BASE"

# ===== CLEAN BROKEN GIT AUTH (กันถาม login) =====
git config --global --unset http.https://github.com/.extraheader 2>/dev/null || true

# ===== CLONE OR UPDATE =====
if [ ! -d "$BASE/.git" ]; then
  echo "[+] Cloning central config (public repo)..."
  git clone --depth=1 "$REPO_URL" "$BASE"
else
  echo "[+] Updating central config..."
  cd "$BASE"
  git pull
fi

# ===== PERMISSION =====
chmod +x "$BASE"/*.sh 2>/dev/null || true

# ===== CREATE WORKER CONFIG (ถามแค่ชื่อเครื่อง) =====
mkdir -p "$BASE/conf"
if [ ! -f "$BASE/conf/worker.conf" ]; then
  echo ""
  read -p "Enter WORKER NAME (ex: F01, F02): " WNAME
  cat > "$BASE/conf/worker.conf" <<EOF
WORKER_NAME="$WNAME"
EOF
fi

# ===== FIX .bashrc (สร้าง + ไม่พัง) =====
BASHRC="$HOME/.bashrc"
touch "$BASHRC"

# ลบ alias เก่าที่พัง (ถ้ามี)
sed -i '/VRSC FARM ALIAS/,$d' "$BASHRC" 2>/dev/null || true

cat >> "$BASHRC" <<'EOF'

# === VRSC FARM ALIAS ===
alias edit-menu='bash ~/vrsc/edit-menu.sh'
alias edit-miner='bash ~/vrsc/edit-menu.sh'
alias edit-worker='bash ~/vrsc/edit-worker.sh'
EOF

# โหลด alias ทันที
source "$BASHRC" || true

echo ""
echo "======================================"
echo " INSTALL DONE ✅"
echo " Next: type  👉 edit-menu"
echo "======================================"
