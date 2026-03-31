#!/usr/bin/env bash
# ============================================================================
# Axios Supply-Chain Compromise Scanner
# Created: 2026-03-31
# Detects the Axios npm attack (axios@1.14.1, axios@0.30.4 + plain-crypto-js)
# Works on Linux (including COSMIC Desktop), macOS, and Windows (WSL)
# ============================================================================

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

FOUND_ISSUES=0

banner() {
  echo -e "\n${BOLD}========================================${NC}"
  echo -e "${BOLD}  Axios Compromise Scanner (2026-03-31)${NC}"
  echo -e "${BOLD}========================================${NC}\n"
}

section() { echo -e "\n${CYAN}[*] $1${NC}"; echo -e "${CYAN}$(printf '%.0s-' {1..60})${NC}"; }
found() { echo -e "${RED}[!!!] FOUND: $1${NC}"; FOUND_ISSUES=$((FOUND_ISSUES + 1)); }
safe() { echo -e "${GREEN}[✓] $1${NC}"; }
warn() { echo -e "${YELLOW}[!] $1${NC}"; }
info() { echo -e "    $1"; }

SCAN_ROOT="${1:-$HOME}"

banner
echo "Platform: $(uname -s)"
echo "Scan root: $SCAN_ROOT"
echo "Date:      $(date -u '+%Y-%m-%d %H:%M:%SZ')"

# 1. Linux Stage-2 Payload
section "Checking for Linux stage-2 payload (/tmp/ld.py)"
if [[ -f "/tmp/ld.py" ]]; then
  found "Linux stage-2 payload found at /tmp/ld.py"
  ls -la /tmp/ld.py
else
  safe "No Linux stage-2 payload found"
fi

# 2. C2 Server Check
section "Checking for active connections to sfrclak.com"
if command -v ss >/dev/null && ss -tunap 2>/dev/null | grep -qi "sfrclak\|142.11.206.73"; then
  found "Active C2 connection to sfrclak.com detected!"
elif command -v netstat >/dev/null && netstat -an 2>/dev/null | grep -qi "sfrclak\|142.11.206.73"; then
  found "Active C2 connection to sfrclak.com detected!"
else
  safe "No active C2 connections detected"
fi

# 3. Quick Lockfile & node_modules Scan
section "Scanning lockfiles and node_modules under $SCAN_ROOT"
LOCK_COUNT=0
while IFS= read -r -d '' file; do
  if grep -qE 'axios@(1\.14\.1|0\.30\.4)|plain-crypto-js' "$file" 2>/dev/null; then
    found "Compromised reference found in $(basename "$file")"
  else
    LOCK_COUNT=$((LOCK_COUNT + 1))
  fi
done < <(find "$SCAN_ROOT" -maxdepth 8 \( -name "package-lock.json" -o -name "yarn.lock" -o -name "pnpm-lock.yaml" \) -print0 2>/dev/null || true)

safe "$LOCK_COUNT lockfiles scanned clean"

# node_modules check
NM_COUNT=0
while IFS= read -r -d '' dir; do
  NM_COUNT=$((NM_COUNT + 1))
  if [[ -d "$dir/plain-crypto-js" ]]; then
    found "Malicious plain-crypto-js found at $dir/plain-crypto-js"
  fi
  if [[ -f "$dir/axios/package.json" ]]; then
    VER=$(node -p "try{require('$dir/axios/package.json').version}catch(e){''}" 2>/dev/null || true)
    if [[ "$VER" == "1.14.1" || "$VER" == "0.30.4" ]]; then
      found "Compromised axios@$VER found"
    fi
  fi
done < <(find "$SCAN_ROOT" -maxdepth 7 -type d -name "node_modules" -print0 2>/dev/null || true)

safe "$NM_COUNT node_modules folders scanned"

# Summary
echo -e "\n${BOLD}========================================${NC}"
echo -e "${BOLD}  SCAN COMPLETE${NC}"
echo -e "${BOLD}========================================${NC}\n"

if [[ $FOUND_ISSUES -gt 0 ]]; then
  echo -e "${RED}${BOLD}⚠️  $FOUND_ISSUES ISSUE(S) FOUND — TAKE ACTION IMMEDIATELY${NC}"
  echo ""
  echo "Recommended cleanup:"
  echo "  rm -f /tmp/ld.py"
  echo "  npm uninstall axios plain-crypto-js"
  echo "  npm install axios@1.14.0"
  echo "  npm cache clean --force"
  echo "  Block sfrclak.com in /etc/hosts"
else
  echo -e "${GREEN}${BOLD}✅ No indicators of compromise found.${NC}"
fi

echo -e "\nScanner finished at $(date -u '+%Y-%m-%d %H:%M:%SZ')"
