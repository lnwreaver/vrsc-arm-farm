#!/data/data/com.termux/files/usr/bin/bash

set -e

BASE="$HOME/vrsc"
REPO_URL="https://github.com/lnwreaver/vrsc-arm-farm.git"

echo "== VRSC ARM FARM INSTALLER =="

# 1) เตรียมโฟลเดอร์
mkdir -p "$BASE/conf" "$BASE/bin"

# 2) clone หรือ update config กลาง
if [ ! -d "$BASE/.git" ]; then
  echo "[+] Cloning central config..."
  git clone "$REPO_URL" "$BASE/tmp"
  cp -r "$BASE/tmp/conf" "$BASE/"
  rm -rf "$BASE/tmp"
else
  echo "[+] Updating central config..."
  cd "$BASE"
  git pull
fi

# 3) สร้าง worker.conf ถ้ายังไม่มี
if [ ! -f "$BASE/conf/worker.conf" ]; then
  WORKER_NAME="$(getprop ro.product.model 2>/dev/null | tr ' ' '_' )"
  [ -z "$WORKER_NAME" ] && WORKER_NAME="$(hostname)"

  echo "WORKER_NAME=\"$WORKER_NAME\"" > "$BASE/conf/worker.conf"
  echo "[+] Worker set to: $WORKER_NAME"
else
  echo "[=] Worker already exists (kept safe)"
fi

echo "== INSTALL DONE =="
echo "Next: run miner-menu"
