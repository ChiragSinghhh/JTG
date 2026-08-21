#!/usr/bin/env bash

# ==============================================================================
#       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     
#       ██║╚══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██════╝██║     
#       ██║   ██║   ██║  ███╗    ██████╝███████║██╔██╗ ██║█████╗  ██║     
#  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██══╝  ██║     
#  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗
#   ╚════╝    ═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
#
#  Script Name    : JTG PANEL UPDATER v1.3
#  Script By      : ChiragSingh
# ==============================================================================

C_RESET='\033[0m'; C_BOLD='\033[1m'; C_CYAN='\033[38;5;51m'; C_WHITE='\033[38;5;255m'; C_SUCCESS='\033[38;5;82m'; C_ERROR='\033[38;5;196m'

echo -e "${C_CYAN}${C_BOLD}"
echo "       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     "
echo "       ██║╚══██══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     "
echo "       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     "
echo "  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     "
echo "  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗"
echo "   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝"
echo -e "${C_RESET}"
echo -e "${C_CYAN}  ────────────────────────────────────────────────────────────────────────${C_RESET}"
echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}                     JTG PANEL UPDATER v1.3                       ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}  │ ${C_WHITE}                  Script By: ${C_BOLD}ChiragSingh                            ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}  ────────────────────────────────────────────────────────────────────────${C_RESET}"
echo ""

if [ -d "Jtg" ]; then cd Jtg; elif [ -f "package.json" ] && grep -q "jtg-panel" "package.json" 2>/dev/null; then echo -e "${C_CYAN}[INFO]${C_RESET} Already in project directory."; else echo -e "${C_ERROR}[ERROR]${C_RESET} Could not find JTG Panel directory."; exit 1; fi

echo -e "${C_CYAN}[INFO]${C_RESET} Pulling latest updates from GitHub..."
git pull origin main 2>/dev/null || git pull origin master 2>/dev/null
echo -e "${C_CYAN}[INFO]${C_RESET} Updating dependencies..."
npm install --no-audit --no-fund --quiet
echo -e "${C_CYAN}[INFO]${C_RESET} Rebuilding application..."
npm run build
echo -e "${C_CYAN}[INFO]${C_RESET} Restarting PM2 service..."
pm2 restart jtg-panel 2>/dev/null || npx pm2 restart jtg-panel

echo ""
echo -e "${C_SUCCESS}[✓ SUCCESS]${C_RESET} ${C_WHITE}Panel updated and restarted successfully!${C_RESET}"
echo ""
