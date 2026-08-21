#!/usr/bin/env bash

# ==============================================================================
#       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     
#       ██║╚══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     
#       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     
#  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║██╗██║██╔══╝  ██║     
#  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗
#   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝═╝  ╚═══╝╚══════╝╚══════╝
#
#  Product Name   : JTG PANEL (v3.2)
#  Panel Creator  : Jishnu
#  Script Name    : Cloudflare Tunnel Installer (v1.3)
#  Script By      : ChiragSingh
#  Repository     : https://github.com/JishnuTheGamer/Jtg
# ==============================================================================

C_RESET='\033[0m'; C_BOLD='\033[1m'; C_CYAN='\033[38;5;51m'; C_GOLD='\033[38;5;220m'; C_WHITE='\033[38;5;255m'; C_MUTED='\033[38;5;244m'; C_SUCCESS='\033[38;5;82m'; C_ERROR='\033[38;5;196m'

print_banner() {
    clear
    echo -e "${C_CYAN}${C_BOLD}"
    echo "       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     "
    echo "       ██║╚══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     "
    echo "       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     "
    echo "  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     "
    echo "  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗"
    echo "   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝"
    echo -e "${C_RESET}"
    echo -e "${C_CYAN}  ────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}               JTG PANEL - CLOUDFLARE TUNNEL INSTALLER v1.3           ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_MUTED}         Expose your panel securely via HTTPS (Tmate/CodeSandbox)       ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_GOLD}                  Panel Creator: ${C_WHITE}${C_BOLD}Jishnu                               ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_GOLD}                  Script By: ${C_WHITE}${C_BOLD}ChiragSingh                            ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  ────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo ""
}

log_info() { echo -e " ${C_CYAN}[INFO]${C_RESET} ${C_WHITE}$1${C_RESET}"; }
log_success() { echo -e " ${C_SUCCESS}${C_BOLD}[✓ SUCCESS]${C_RESET} ${C_WHITE}$1${C_RESET}"; }
log_warning() { echo -e " ${C_GOLD}${C_BOLD}[! WARNING]${C_RESET} ${C_WHITE}$1${C_RESET}"; }
log_error() { echo -e " ${C_ERROR}${C_BOLD}[✗ ERROR]${C_RESET} ${C_WHITE}$1${C_RESET}"; }

install_cloudflared() {
    log_info "Preparing system and installing prerequisites (curl/wget)..."
    apt-get update -qq >/dev/null 2>&1
    apt-get install -y -qq curl wget >/dev/null 2>&1
    log_info "Downloading cloudflared directly from GitHub (Bypassing apt GPG issues)..."
    local arch="amd64"
    if [ "$(uname -m)" = "aarch64" ] || [ "$(uname -m)" = "arm64" ]; then arch="arm64"; fi
    curl -sL --output cloudflared.deb "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${arch}.deb"
    if [ -f "cloudflared.deb" ]; then
        log_info "Installing package..."
        dpkg -i cloudflared.deb 2>/dev/null
        rm -f cloudflared.deb
        if command -v cloudflared &> /dev/null; then log_success "cloudflared binary installed successfully!"; return 0; else log_error "Failed to install cloudflared via dpkg."; return 1; fi
    else log_error "Failed to download cloudflared. Please check your internet connection."; return 1; fi
}

setup_tunnel() {
    echo ""
    echo -e "${C_GOLD}  ┌──────────────────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "${C_GOLD}  │ ${C_WHITE}${C_BOLD} ACTION REQUIRED: Complete Cloudflare Setup                           ${C_GOLD}│${C_RESET}"
    echo -e "${C_GOLD}  └──────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo -e "  ${C_WHITE}To finish the setup for tmate.io / CodeSandbox, we need to link the tunnel.${C_RESET}"
    echo -e "  ${C_WHITE}${C_BOLD}Please send your token or the entire code for install to be completed.${C_RESET}"
    echo -e "  ${C_MUTED}(e.g., 'eyJ...' OR 'sudo cloudflared service install eyj...')${C_RESET}"
    echo -e "  ${C_MUTED}(Press Enter to skip if you don't have it yet.)${C_RESET}"
    echo ""
    read -r -p "  > Paste Token or Full Command here: " cf_input
    if [ -n "$cf_input" ]; then
        log_info "Processing Cloudflare configuration..."
        if [[ "$cf_input" == *"cloudflared"* ]]; then eval "$cf_input"; else cloudflared service install "$cf_input"; fi
        if [ $? -eq 0 ]; then log_success "Cloudflare Tunnel installed and configured successfully!"; systemctl start cloudflared 2>/dev/null || true; systemctl enable cloudflared 2>/dev/null || true; echo -e "  ${C_CYAN}Tunnel Status:${C_RESET} ${C_SUCCESS}Active & Running${C_RESET}"; else log_warning "Cloudflare configuration failed. Please verify your token or command."; fi
    else log_info "Cloudflare setup skipped. You can run this script again later."; fi
}

print_banner
if command -v cloudflared &> /dev/null; then
    log_success "cloudflared is already installed."
    read -r -p "  Do you want to re-configure or add a new tunnel? [y/N, default: n]: " reconfig
    reconfig=$(echo "$reconfig" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    if [[ "$reconfig" == "y" || "$reconfig" == "yes" ]]; then setup_tunnel; else echo -e "\n  ${C_CYAN}Exiting. Tunnel is already active.${C_RESET}\n"; exit 0; fi
else
    if install_cloudflared; then setup_tunnel; else log_error "Installation aborted due to errors."; exit 1; fi
fi

echo ""
echo -e "${C_CYAN}  ┌──────────────────────────────────────────────────────────────────────────┐${C_RESET}"
echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD} MANAGEMENT COMMANDS                                                    ${C_CYAN}│${C_RESET}"
echo -e "${C_CYAN}  └──────────────────────────────────────────────────────────────────────────┘${C_RESET}"
echo -e "  ${C_MUTED}Check Status:${C_RESET}   ${C_WHITE}systemctl status cloudflared${C_RESET}"
echo -e "  ${C_MUTED}View Logs:${C_RESET}      ${C_WHITE}journalctl -u cloudflared -f${C_RESET}"
echo -e "  ${C_MUTED}Restart:${C_RESET}        ${C_WHITE}systemctl restart cloudflared${C_RESET}"
echo ""
