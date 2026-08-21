#!/usr/bin/env bash

# ==============================================================================
#       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     
#       ██║╚══██╔══╝██════╝     ██╔══██╗██══██╗████╗  ██║██╔════╝██║     
#       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     
#  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     
#  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ████║███████╗███████╗
#   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ═╝  ╚═╝╚═╝  ╚═══╝╚══════╝══════╝
#
#  Product Name   : JTG PANEL
#  Panel Version  : v3.2
#  Panel Creator  : Jishnu
#  Installer Ver  : 1.3 (Redesigned UI + 24/7 Uptime + Port Selection)
#  Installer By   : ChiragSingh
#  Repository     : https://github.com/JishnuTheGamer/Jtg
# ==============================================================================

# Panel Configuration
PANEL_TITLE="JTG PANEL"
PANEL_AUTHOR="Jishnu"
INSTALLER_AUTHOR="ChiragSingh"
INSTALLER_VERSION="1.3"
DEFAULT_PROD_PORT=6767
DEFAULT_DEV_PORT=30000
REPO_URL="https://github.com/JishnuTheGamer/Jtg.git"

# Modern UI Color Scheme - Purple & Cyan Theme
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_PURPLE='\033[38;5;141m'
C_CYAN='\033[38;5;51m'
C_GREEN='\033[38;5;82m'
C_YELLOW='\033[38;5;226m'
C_RED='\033[38;5;196m'
C_WHITE='\033[38;5;255m'
C_GRAY='\033[38;5;244m'

print_banner() {
    clear
    echo -e "${C_PURPLE}${C_BOLD}"
    echo "       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     "
    echo "       ██║╚══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██════╝██║     "
    echo "       ██║   ██║   ██║  ███╗    ██████╔╝███████║████╗ ██║█████╗  ██║     "
    echo "  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     "
    echo "  ╚█████╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗"
    echo "   ╚════╝    ═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝"
    echo -e "${C_RESET}"
    echo -e "${C_PURPLE}  ────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}                  JTG PANEL INSTALLER v${INSTALLER_VERSION}                       ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  │${C_GRAY}         Next-Gen Game Server & Workload Control Dashboard              ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  │${C_YELLOW}                  Panel Creator: ${C_WHITE}${C_BOLD}${PANEL_AUTHOR}                             ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  │${C_YELLOW}               Custom Installer By: ${C_WHITE}${C_BOLD}${INSTALLER_AUTHOR}                      ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  │${C_GRAY}          Repo: ${C_CYAN}https://github.com/JishnuTheGamer/Jtg                     ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  ────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo ""
}

log_info() { echo -e "${C_CYAN}[INFO]${C_RESET} ${C_WHITE}$1${C_RESET}"; }
log_success() { echo -e "${C_GREEN}[✓]${C_RESET} ${C_GREEN}${C_BOLD}SUCCESS${C_RESET} ${C_WHITE}$1${C_RESET}"; }
log_warning() { echo -e "${C_YELLOW}[!]${C_RESET} ${C_YELLOW}${C_BOLD}WARNING${C_RESET} ${C_WHITE}$1${C_RESET}"; }
log_error() { echo -e "${C_RED}[]${C_RESET} ${C_RED}${C_BOLD}ERROR${C_RESET} ${C_WHITE}$1${C_RESET}"; }
log_step() { echo -e "${C_PURPLE}${C_BOLD}>>>${C_RESET} ${C_WHITE}${C_BOLD}$1${C_RESET}"; }

check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_warning "Running as non-root user. If package installation fails, please execute: sudo bash install.sh"
    fi
}

get_public_ip() {
    local ip
    ip=$(curl -s --max-time 4 https://api.ipify.org 2>/dev/null || curl -s --max-time 4 https://ifconfig.me 2>/dev/null || curl -s --max-time 4 https://icanhazip.com 2>/dev/null || echo "127.0.0.1")
    echo "$ip" | tr -d '\n' | tr -d '\r'
}

setup_system_dependencies() {
    log_step "Installing System Dependencies..."
    if command -v apt-get &> /dev/null; then
        sudo dpkg --configure -a 2>/dev/null || true
        sudo apt-get clean 2>/dev/null || true
        local needed=()
        command -v curl &>/dev/null || needed+=("curl")
        command -v git &>/dev/null || needed+=("git")
        command -v tar &>/dev/null || needed+=("tar")
        command -v xz &>/dev/null || needed+=("xz-utils")
        command -v jq &>/dev/null || needed+=("jq")
        command -v ufw &>/dev/null || needed+=("ufw")
        [ -f /etc/ssl/certs/ca-certificates.crt ] || needed+=("ca-certificates")
        command -v make &>/dev/null || needed+=("build-essential")
        if [ ${#needed[@]} -gt 0 ]; then
            sudo DEBIAN_FRONTEND=noninteractive apt-get update -y -qq 2>/dev/null || true
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends "${needed[@]}" 2>/dev/null || true
        fi
    elif command -v yum &> /dev/null; then
        sudo yum update -y -q || true
        sudo yum install -y -q curl git make gcc-c++ ca-certificates tar xz jq || true
    fi
    log_success "System dependencies configured"
}

ensure_nodejs() {
    log_step "Checking Node.js Runtime..."
    local need_install=0
    if ! command -v node &> /dev/null; then need_install=1; else
        local node_ver; node_ver=$(node -v | cut -d'.' -f1 | tr -d 'v')
        if [ "$node_ver" -lt 20 ]; then log_warning "Legacy Node.js detected. Upgrading to Node.js 22 LTS..."; need_install=1; fi
    fi
    if [ "$need_install" -eq 1 ]; then
        log_info "Installing Node.js 22.x LTS..."
        if command -v apt-get &> /dev/null; then curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -; sudo apt-get install -y nodejs; elif command -v yum &> /dev/null; then curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -; sudo yum install -y nodejs; fi
    fi
    log_success "Node.js $(node -v) & npm $(npm -v) ready"
}

prompt_port_selection() {
    echo ""
    echo -e "${C_PURPLE}  ────────────────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}          STEP 1: SELECT PANEL PORT                                     ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  └────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}Enter the port number for JTG Panel:${C_RESET}"
    echo -e "  ${C_GRAY}(Default: ${DEFAULT_PROD_PORT}, Range: 1024-65535)${C_RESET}"
    echo ""
    local port_input
    read -r -p "  ${C_CYAN}Enter port number${C_RESET} [default: ${DEFAULT_PROD_PORT}]: " port_input
    port_input=$(echo "$port_input" | tr -d ' ')
    if [ -z "$port_input" ]; then SELECTED_PORT=$DEFAULT_PROD_PORT; elif [[ "$port_input" =~ ^[0-9]+$ ]] && [ "$port_input" -ge 1024 ] && [ "$port_input" -le 65535 ]; then SELECTED_PORT=$port_input; else log_warning "Invalid port. Using default port ${DEFAULT_PROD_PORT}"; SELECTED_PORT=$DEFAULT_PROD_PORT; fi
    log_success "Panel will run on port: ${C_BOLD}${SELECTED_PORT}${C_RESET}"
}

prompt_runtime_configuration() {
    echo ""
    echo -e "${C_PURPLE}  ┌────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}          STEP 2: SELECT SERVER RUNTIME ENGINE                          ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  └────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo -e "  ${C_WHITE}Choose server execution method:${C_RESET}"
    echo ""
    echo -e "  ${C_GREEN}[1]${C_WHITE} Docker Container ${C_GRAY}(Recommended - Isolated & Secure)${C_RESET}"
    echo -e "  ${C_YELLOW}[2]${C_WHITE} Local Process    ${C_GRAY}(Direct host execution)${C_RESET}"
    echo ""
    local choice; read -r -p "  ${C_CYAN}Enter choice${C_RESET} [1-2, default: 1]: " choice; choice=$(echo "$choice" | tr -d ' ')
    case "$choice" in 2) SELECTED_RUNTIME="local"; RUNTIME_MODE="local" ;; *) SELECTED_RUNTIME="docker"; RUNTIME_MODE="docker" ;; esac
    RUNTIME_LOCKED="true"
    log_success "Runtime: ${C_BOLD}${SELECTED_RUNTIME}${C_RESET} (Locked for standard panel)"
}

prompt_theme_selection() {
    echo ""
    echo -e "${C_PURPLE}  ┌────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}          STEP 3: SELECT PANEL THEME                                    ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  └────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo ""
    echo -e "  ${C_RED}[1]${C_WHITE} Crimson Red      ${C_YELLOW}[5]${C_WHITE} Emerald Green"
    echo -e "  ${C_PURPLE}[2]${C_WHITE} Cobalt Blue      ${C_CYAN}[6]${C_WHITE} Amber Gold"
    echo -e "  ${C_PURPLE}[3]${C_WHITE} Neon Purple     ${C_RED}[7]${C_WHITE} Vivid Rose"
    echo -e "  ${C_CYAN}[4]${C_WHITE} Cyber Cyan      ${C_WHITE}[8]${C_WHITE} Clean Slate"
    echo ""
    local theme_choice; read -r -p "  ${C_CYAN}Enter theme${C_RESET} [1-8, default: 1]: " theme_choice; theme_choice=$(echo "$theme_choice" | tr -d ' ')
    case "$theme_choice" in 2) SELECTED_THEME="blue" ;; 3) SELECTED_THEME="purple" ;; 4) SELECTED_THEME="cyan" ;; 5) SELECTED_THEME="green" ;; 6) SELECTED_THEME="amber" ;; 7) SELECTED_THEME="rose" ;; 8) SELECTED_THEME="white" ;; *) SELECTED_THEME="red" ;; esac
    log_success "Theme: ${C_BOLD}${SELECTED_THEME}${C_RESET}"
}

prompt_java_install() {
    echo ""
    echo -e "${C_PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}          STEP 4: JAVA RUNTIME (For Minecraft)                          ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  └────────────────────────────────────────────────────────────────────────${C_RESET}"
    if command -v java &> /dev/null; then log_success "Java already installed ($(java -version 2>&1 | head -n 1))"; elif [ -f ".data/bin/jre-25/bin/java" ] || [ -f ".data/bin/jre-21/bin/java" ]; then log_success "Portable OpenJDK detected"; else
        local install_java; read -r -p "  ${C_CYAN}Install Java?${C_RESET} [y/N, default: y]: " install_java; install_java=$(echo "$install_java" | tr -d ' ')
        if [[ ! "$install_java" =~ ^[Nn]$ ]]; then log_info "Installing OpenJDK..."; if command -v apt-get &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openjdk-21-jre-headless 2>/dev/null || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openjdk-17-jre-headless 2>/dev/null || true; fi; log_success "Java runtime installed"; fi
    fi
}

prompt_docker_install() {
    echo ""
    echo -e "${C_PURPLE}  ┌────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}          STEP 5: DOCKER ENGINE                                         ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  └────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    if command -v docker &> /dev/null; then log_success "Docker already installed ($(docker --version 2>/dev/null | head -n 1))"; else
        if [ "$SELECTED_RUNTIME" = "docker" ]; then log_info "Installing Docker Engine..."; curl -fsSL https://get.docker.com | sudo sh; sudo systemctl enable --now docker 2>/dev/null || true; sudo usermod -aG docker "$USER" 2>/dev/null || true; log_success "Docker Engine installed"; else
            local install_docker; read -r -p "  ${C_CYAN}Install Docker?${C_RESET} [y/N, default: n]: " install_docker
            if [[ "$install_docker" =~ ^[Yy]$ ]]; then curl -fsSL https://get.docker.com | sudo sh; sudo systemctl enable --now docker 2>/dev/null || true; sudo usermod -aG docker "$USER" 2>/dev/null || true; log_success "Docker installed"; else log_info "Docker skipped (Local mode selected)"; fi
        fi
    fi
}

prompt_cloudflare_setup() {
    echo ""
    echo -e "${C_PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}          STEP 6: CLOUDFLARE TUNNEL SETUP                               ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  └────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo -e "  ${C_GRAY}For tmate.io/CodeSandbox - Expose panel via HTTPS${C_RESET}"
    echo ""
    read -r -p "  ${C_CYAN}Setup Cloudflare?${C_RESET} [y/N, default: n]: " cf_choice; cf_choice=$(echo "$cf_choice" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    if [[ "$cf_choice" == "y" || "$cf_choice" == "yes" ]]; then
        log_info "Installing cloudflared..."
        if command -v apt-get &> /dev/null; then curl -sL --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb; sudo dpkg -i cloudflared.deb 2>/dev/null || true; rm -f cloudflared.deb; else curl -sL --output cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64; chmod +x cloudflared; sudo mv cloudflared /usr/local/bin/; fi
        log_success "cloudflared installed"
        echo ""
        echo -e "${C_YELLOW}  ┌────────────────────────────────────────────────────────────────────────┐${C_RESET}"
        echo -e "${C_YELLOW}  │${C_WHITE}${C_BOLD} ACTION REQUIRED: Cloudflare Setup                                  ${C_YELLOW}│${C_RESET}"
        echo -e "${C_YELLOW}  └────────────────────────────────────────────────────────────────────────${C_RESET}"
        echo -e "  ${C_WHITE}Paste your token OR full command to complete setup:${C_RESET}"
        echo -e "  ${C_GRAY}(Example: 'eyJ...' OR 'sudo cloudflared service install eyj...')${C_RESET}"
        echo -e "  ${C_GRAY}(Press Enter to skip)${C_RESET}"
        echo ""
        read -r -p "  ${C_CYAN}> ${C_RESET}" cf_input
        if [ -n "$cf_input" ]; then
            log_info "Configuring Cloudflare..."
            if [[ "$cf_input" == *"cloudflared"* ]]; then eval "$cf_input"; else sudo cloudflared service install "$cf_input"; fi
            if [ $? -eq 0 ]; then log_success "Cloudflare Tunnel configured!"; sudo systemctl start cloudflared 2>/dev/null || true; sudo systemctl enable cloudflared 2>/dev/null || true; else log_warning "Cloudflare setup failed. Verify token/command."; fi
        else log_info "Cloudflare setup skipped"; fi
    else log_info "Cloudflare setup skipped"; fi
}

setup_24_7_uptime() {
    echo ""
    echo -e "${C_PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}          STEP 7: 24/7 UPTIME MONITOR                                   ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  └────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo -e "  ${C_WHITE}Keep your panel running 24/7 with automatic restarts${C_RESET}"
    echo ""
    read -r -p "  ${C_CYAN}Enable 24/7 uptime monitor?${C_RESET} [y/N, default: n]: " uptime_choice; uptime_choice=$(echo "$uptime_choice" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    if [[ "$uptime_choice" == "y" || "$uptime_choice" == "yes" ]]; then
        log_info "Setting up 24/7 uptime monitor..."
        python3 <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/24-7/refs/heads/main/24)
        log_success "24/7 uptime monitor configured!"
    else log_info "24/7 uptime monitor skipped"; fi
}

prepare_repository() {
    log_step "Preparing workspace..."
    if [ -f "package.json" ] && grep -q "jtg-panel" "package.json" 2>/dev/null; then PROJECT_DIR="$(pwd)"; log_info "Using current directory"; elif [ -d "Jtg" ]; then PROJECT_DIR="$(pwd)/Jtg"; cd "$PROJECT_DIR"; log_info "Syncing repository..."; git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true; else log_info "Cloning JTG Panel..."; git clone "$REPO_URL" Jtg; PROJECT_DIR="$(pwd)/Jtg"; cd "$PROJECT_DIR"; fi
}

setup_environment() {
    local target_port=$1; local run_mode=$2
    log_step "Configuring environment..."
    [ -f ".logs" ] && rm -f ".logs"
    mkdir -p .data/servers .data/temp .data/logs backups .logs 2>/dev/null || true
    local jwt_secret; jwt_secret=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))" 2>/dev/null || echo "jtg_secret_$(date +%s)")
    cat > .env <<EOF
# JTG PANEL Configuration - Installer v1.3 by ChiragSingh
NODE_ENV=${run_mode}
PORT=${target_port}
JWT_SECRET=${jwt_secret}
DEFAULT_RUNTIME=${SELECTED_RUNTIME:-docker}
ENABLE_DOCKER=$( [ "${SELECTED_RUNTIME:-docker}" = "docker" ] && echo "true" || echo "false" )
PANEL_RUNTIME_MODE=${RUNTIME_MODE:-docker}
PANEL_RUNTIME_LOCKED=${RUNTIME_LOCKED:-true}
PANEL_THEME=${SELECTED_THEME:-red}
DEV_MODE=$( [ "$run_mode" = "development" ] && echo "true" || echo "false" )
EOF
    log_success "Environment configured (Port: ${target_port}, Runtime: ${SELECTED_RUNTIME}, Theme: ${SELECTED_THEME})"
}

build_application() {
    log_step "Building application..."
    npm install --no-audit --no-fund --quiet
    npm run build
    log_success "Build completed"
}

configure_pm2_service() {
    local target_port=$1
    log_step "Setting up PM2 service..."
    command -v pm2 &> /dev/null || sudo npm install -g pm2 2>/dev/null || npm install -g pm2 2>/dev/null || true
    pm2 delete jtg-panel 2>/dev/null || npx pm2 delete jtg-panel 2>/dev/null || true
    PORT="${target_port}" npx pm2 start "scripts/start-with-update.sh" --name "jtg-panel" 2>/dev/null || PORT="${target_port}" npx pm2 start "dist/server.cjs" --name "jtg-panel"
    npx pm2 save 2>/dev/null || true
    [ "$EUID" -eq 0 ] && npx pm2 startup systemd -u root --hp /root 2>/dev/null || true
    log_success "PM2 service 'jtg-panel' active"
}

create_initial_admin() {
    echo ""
    echo -e "${C_PURPLE}  ┌────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo -e "${C_PURPLE}  │${C_WHITE}${C_BOLD}          CREATE ADMIN ACCOUNT                                          ${C_PURPLE}│${C_RESET}"
    echo -e "${C_PURPLE}  └────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    npm run createuser || true
}

install_production() {
    print_banner
    echo -e "${C_PURPLE}${C_BOLD}  ═══════════════════════════════════════════════════════════════════════${C_RESET}"
    echo -e "${C_PURPLE}${C_BOLD}                    PRODUCTION INSTALLATION - Port: ${SELECTED_PORT:-6767}${C_RESET}"
    echo -e "${C_PURPLE}${C_BOLD}  ═══════════════════════════════════════════════════════════════════════${C_RESET}"
    echo ""
    check_root; setup_system_dependencies; ensure_nodejs; prompt_port_selection; prompt_runtime_configuration; prompt_theme_selection; prompt_java_install; prompt_docker_install; prompt_cloudflare_setup; setup_24_7_uptime
    prepare_repository; setup_environment "${SELECTED_PORT:-$DEFAULT_PROD_PORT}" "production"; build_application; configure_pm2_service "${SELECTED_PORT:-$DEFAULT_PROD_PORT}"; create_initial_admin
    local server_ip; server_ip=$(get_public_ip)
    echo ""
    echo -e "${C_GREEN}${C_BOLD}  ┌────────────────────────────────────────────────────────────────────────${C_RESET}"
    echo -e "${C_GREEN}${C_BOLD}  │             ${PANEL_TITLE} INSTALLED SUCCESSFULLY!                      │${C_RESET}"
    echo -e "${C_GREEN}${C_BOLD}  └────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo ""
    echo -e "  ${C_CYAN}Panel URL:${C_RESET}      ${C_WHITE}${C_BOLD}http://${server_ip}:${SELECTED_PORT:-$DEFAULT_PROD_PORT}${C_RESET}"
    echo -e "  ${C_CYAN}Localhost:${C_RESET}      ${C_WHITE}${C_BOLD}http://localhost:${SELECTED_PORT:-$DEFAULT_PROD_PORT}${C_RESET}"
    echo -e "  ${C_CYAN}Runtime:${C_RESET}        ${C_WHITE}${SELECTED_RUNTIME:-docker}${C_RESET}"
    echo -e "  ${C_CYAN}Theme:${C_RESET}          ${C_WHITE}${SELECTED_THEME:-red}${C_RESET}"
    echo -e "  ${C_CYAN}Creator:${C_RESET}        ${C_WHITE}${PANEL_AUTHOR}${C_RESET}"
    echo -e "  ${C_CYAN}Installer:${C_RESET}      ${C_WHITE}v${INSTALLER_VERSION} by ${INSTALLER_AUTHOR}${C_RESET}"
    echo ""
    echo -e "${C_GRAY}  ── Management Commands ──────────────────────────────────────────────────${C_RESET}"
    echo -e "  ${C_WHITE}Status:${C_RESET}    ${C_CYAN}npx pm2 status${C_RESET}"
    echo -e "  ${C_WHITE}Logs:${C_RESET}      ${C_CYAN}npx pm2 logs jtg-panel${C_RESET}"
    echo -e "  ${C_WHITE}Restart:${C_RESET}   ${C_CYAN}npx pm2 restart jtg-panel${C_RESET}"
    echo -e "  ${C_WHITE}Update:${C_RESET}    ${C_CYAN}bash update.sh${C_RESET}"
    echo -e "  ${C_WHITE}Uninstall:${C_RESET} ${C_CYAN}bash uninstall.sh${C_RESET}"
    echo ""
}

install_development() {
    print_banner
    echo -e "${C_PURPLE}${C_BOLD}  ═══════════════════════════════════════════════════════════════════════${C_RESET}"
    echo -e "${C_PURPLE}${C_BOLD}                    DEVELOPMENT MODE - Port: ${DEFAULT_DEV_PORT}${C_RESET}"
    echo -e "${C_PURPLE}${C_BOLD}  ═══════════════════════════════════════════════════════════════════════${C_RESET}"
    echo ""
    setup_system_dependencies; ensure_nodejs; prompt_port_selection; prompt_runtime_configuration; prompt_theme_selection
    prepare_repository; setup_environment "${SELECTED_PORT:-$DEFAULT_DEV_PORT}" "development"
    log_info "Installing dependencies..."; npm install; create_initial_admin
    log_success "Development ready! Start with: ${C_CYAN}npm run dev${C_RESET}"
}

# Main Menu
while true; do
    print_banner
    echo -e "  ${C_GREEN}[1]${C_WHITE} Install (Production)${C_RESET}"
    echo -e "  ${C_PURPLE}[2]${C_WHITE} Install (Development)${C_RESET}"
    echo -e "  ${C_YELLOW}[3]${C_WHITE} Update Panel${C_RESET}"
    echo -e "  ${C_CYAN}[4]${C_WHITE} Create Admin Account${C_RESET}"
    echo -e "  ${C_GREEN}[5]${C_WHITE} Restart Panel${C_RESET}"
    echo -e "  ${C_RED}[6]${C_WHITE} Uninstall Panel${C_RESET}"
    echo -e "  ${C_GRAY}[7]${C_WHITE} Exit${C_RESET}"
    echo ""
    read -r -p "  ${C_CYAN}Select option${C_RESET} [1-7]: " option; option=$(echo "$option" | tr -d ' ')
    case "$option" in
        1) install_production; read -r -p "Press Enter to continue..." _ ;;
        2) install_development; read -r -p "Press Enter to continue..." _ ;;
        3) bash update.sh; read -r -p "Press Enter to continue..." _ ;;
        4) npm run createuser || (cd Jtg && npm run createuser); read -r -p "Press Enter to continue..." _ ;;
        5) pm2 restart jtg-panel 2>/dev/null || npx pm2 restart jtg-panel 2>/dev/null; log_success "Panel restarted"; read -r -p "Press Enter to continue..." _ ;;
        6) bash uninstall.sh; exit 0 ;;
        7) echo -e "\n${C_GREEN}Goodbye!${C_RESET}\n"; exit 0 ;;
        *) log_error "Invalid option"; sleep 1 ;;
    esac
done
