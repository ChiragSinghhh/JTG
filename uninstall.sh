#!/usr/bin/env bash

# ==============================================================================
#       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     
#       ██║╚══██══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     
#       ██║   ██║   ██║  ███╗    ██████╔╝███████║████╗ ██║█████╗  ██║     
#  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██══██║██║╚██╗██║██╔══╝  ██║     
#  █████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗
#   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ═╝╚═╝  ╚═══╝╚══════╝╚══════╝
#
#  Script Name    : JTG PANEL UNINSTALLER v1.3
#  Script By      : ChiragSingh
# ==============================================================================

C_RESET='\033[0m'; C_BOLD='\033[1m'; C_RED='\033[38;5;196m'; C_WHITE='\033[38;5;255m'; C_CYAN='\033[38;5;51m'

echo -e "${C_RED}${C_BOLD}"
echo "       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     "
echo "       ██║╚══██╔══╝██════╝     ██╔══██╗██══██╗████╗  ██║██╔════╝██║     "
echo "       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     "
echo "  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     "
echo "  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗"
echo "   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝"
echo -e "${C_RESET}"
echo -e "${C_RED}  ───────────────────────────────────────────────────────────────────────${C_RESET}"
echo -e "${C_RED}  │ ${C_WHITE}${C_BOLD}                   JTG PANEL UNINSTALLER v1.3                     ${C_RED}│${C_RESET}"
echo -e "${C_RED}  │ ${C_WHITE}                  Script By: ${C_BOLD}ChiragSingh                            ${C_RED}│${C_RESET}"
echo -e "${C_RED}  ────────────────────────────────────────────────────────────────────────${C_RESET}"
echo ""

read -r -p "${C_RED}️  Are you sure you want to completely uninstall JTG Panel? [y/N]: ${C_RESET}" confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then echo -e "${C_CYAN}Uninstall cancelled.${C_RESET}"; exit 0; fi

echo ""
echo -e "${C_CYAN}[INFO] Stopping services...${C_RESET}"
pm2 delete jtg-panel 2>/dev/null || npx pm2 delete jtg-panel 2>/dev/null || true
echo -e "${C_CYAN}[INFO] Removing application files...${C_RESET}"
if [ -d "Jtg" ]; then rm -rf Jtg; echo -e "  ✓ Removed Jtg directory"; fi
rm -rf .env .data .logs backups node_modules dist 2>/dev/null || true
echo -e "  ✓ Removed configuration and data files"

echo ""
echo -e "${C_RED}${C_BOLD}  ───────────────────────────────────────────────────────────────────────${C_RESET}"
echo -e "${C_RED}${C_BOLD}  │                   JTG PANEL UNINSTALLED SUCCESSFULLY!                    │${C_RESET}"
echo -e "${C_RED}${C_BOLD}  ────────────────────────────────────────────────────────────────────────${C_RESET}"
echo ""
