#!/usr/bin/env bash

# ==============================================================================
#       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     
#       ██║╚══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██════╝██║     
#       ██║   ██║   ██║  ███╗    ██████╝███████║██╔██╗ ██║█████╗  ██║     
#  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██══╝  ██║     
#  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗
#   ╚════╝    ═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
#
#  Script Name    : JTG PANEL UNINSTALLER v1.3
#  Script By      : ChiragSingh
# ==============================================================================

RESET='\033[0m'
BOLD='\033[1m'
RED='\033[31m'
WHITE='\033[37m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'

printf "${RED}${BOLD}"
printf "       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     \n"
printf "       ██║╚══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     \n"
printf "       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     \n"
printf "  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     \n"
printf "  ╚█████╔╝   ██║   ╚██████╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗\n"
printf "   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝\n"
printf "${RESET}"
printf "${RED}  ───────────────────────────────────────────────────────────────────────${RESET}\n"
printf "${RED}  │ ${WHITE}${BOLD}                   JTG PANEL UNINSTALLER v1.3                     ${RED}│${RESET}\n"
printf "${RED}  │ ${WHITE}                  Script By: ${BOLD}ChiragSingh                            ${RED}│${RESET}\n"
printf "${RED}  ────────────────────────────────────────────────────────────────────────${RESET}\n"
echo ""

printf "${RED}⚠️  Are you sure you want to completely uninstall JTG Panel? [y/N]: ${RESET}"
read -r confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then printf "${CYAN}Uninstall cancelled.${RESET}\n"; exit 0; fi

echo ""
printf "${CYAN}[INFO] Stopping services...${RESET}\n"
pm2 delete jtg-panel 2>/dev/null || npx pm2 delete jtg-panel 2>/dev/null || true
pm2 save 2>/dev/null || true

printf "${CYAN}[INFO] Removing PM2 startup scripts...${RESET}\n"
pm2 unstartup systemd 2>/dev/null || true

printf "${CYAN}[INFO] Removing application files...${RESET}\n"

# Remove Jtg directory completely
if [ -d "Jtg" ]; then
    rm -rf Jtg
    printf "  ${GREEN}✓${RESET} Removed Jtg directory\n"
fi

# Remove files if run from inside the directory
rm -rf .env .data .logs backups node_modules dist src scripts 2>/dev/null || true
rm -f package.json package-lock.json 2>/dev/null || true
printf "  ${GREEN}✓${RESET} Removed configuration and data files\n"

# Remove from parent directory if exists
if [ -d "../Jtg" ]; then
    rm -rf ../Jtg
    printf "  ${GREEN}✓${RESET} Removed Jtg directory from parent\n"
fi

# Remove cloudflared if installed
printf "${CYAN}[INFO] Removing Cloudflare Tunnel...${RESET}\n"
if command -v cloudflared &> /dev/null; then
    sudo systemctl stop cloudflared 2>/dev/null || true
    sudo systemctl disable cloudflared 2>/dev/null || true
    sudo rm -f /etc/systemd/system/cloudflared.service 2>/dev/null || true
    sudo rm -rf /etc/cloudflared ~/.cloudflared 2>/dev/null || true
    sudo apt-get purge -y cloudflared 2>/dev/null || sudo dpkg --purge cloudflared 2>/dev/null || true
    sudo rm -f /usr/local/bin/cloudflared 2>/dev/null || true
    sudo systemctl daemon-reload 2>/dev/null || true
    printf "  ${GREEN}✓${RESET} Removed Cloudflare Tunnel\n"
fi

# Remove 24/7 uptime monitor if running
printf "${CYAN}[INFO] Removing 24/7 uptime monitor...${RESET}\n"
pkill -f "24-7" 2>/dev/null || true
rm -f 24.py 24.sh 2>/dev/null || true
printf "  ${GREEN}✓${RESET} Removed uptime monitor\n"

echo ""
printf "${RED}${BOLD}  ───────────────────────────────────────────────────────────────────────${RESET}\n"
printf "${RED}${BOLD}  │                   JTG PANEL UNINSTALLED SUCCESSFULLY!                    │${RESET}\n"
printf "${RED}${BOLD}  ────────────────────────────────────────────────────────────────────────${RESET}\n"
echo ""
printf "${GREEN}All JTG Panel files, services, and configurations have been removed.${RESET}\n"
echo ""
