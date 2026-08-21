#!/usr/bin/env bash

# ==============================================================================
#       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     
#       ██║╚══██╔══╝██╔════╝     ██══██╗██╔══██╗████╗  ██║██╔════╝██║     
#       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     
#  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     
#  ╚█████╔╝   ██║   ██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗
#   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
#
#  Product Name   : JTG PANEL
#  Panel Version  : v3.2
#  Panel Creator  : Jishnu
#  Installer Ver  : 1.3 (Fixed Colors + Better Error Handling)
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

# Fixed Color Scheme - Using simple ANSI codes that work everywhere
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# Foreground colors
PURPLE='\033[35m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
WHITE='\033[37m'
GRAY='\033[90m'

print_banner() {
    clear
    printf "${PURPLE}${BOLD}"
    printf "       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     \n"
    printf "       ██║╚══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     \n"
    printf "       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     \n"
    printf "  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     \n"
    printf "  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗\n"
    printf "   ════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝\n"
    printf "${RESET}"
    printf "${PURPLE}  ────────────────────────────────────────────────────────────────────────${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}                  JTG PANEL INSTALLER v%s                       ${PURPLE}│${RESET}\n" "$INSTALLER_VERSION"
    printf "${PURPLE}  │${GRAY}         Next-Gen Game Server & Workload Control Dashboard              ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  │${YELLOW}                  Panel Creator: ${WHITE}${BOLD}%s                             ${PURPLE}│${RESET}\n" "$PANEL_AUTHOR"
    printf "${PURPLE}  │${YELLOW}               Custom Installer By: ${WHITE}${BOLD}%s                      ${PURPLE}│${RESET}\n" "$INSTALLER_AUTHOR"
    printf "${PURPLE}  │${GRAY}          Repo: ${CYAN}https://github.com/JishnuTheGamer/Jtg                     ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  ────────────────────────────────────────────────────────────────────────${RESET}\n"
    echo ""
}

log_info() { printf "${CYAN}[INFO]${RESET} ${WHITE}%s${RESET}\n" "$1"; }
log_success() { printf "${GREEN}[✓]${RESET} ${GREEN}${BOLD}SUCCESS${RESET} ${WHITE}%s${RESET}\n" "$1"; }
log_warning() { printf "${YELLOW}[!]${RESET} ${YELLOW}${BOLD}WARNING${RESET} ${WHITE}%s${RESET}\n" "$1"; }
log_error() { printf "${RED}[✗]${RESET} ${RED}${BOLD}ERROR${RESET} ${WHITE}%s${RESET}\n" "$1"; }
log_step() { printf "${PURPLE}${BOLD}>>>${RESET} ${WHITE}${BOLD}%s${RESET}\n" "$1"; }

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
    printf "${PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}          STEP 1: SELECT PANEL PORT                                     ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  └────────────────────────────────────────────────────────────────────────┘${RESET}\n"
    echo ""
    printf "  ${WHITE}Enter the port number for JTG Panel:${RESET}\n"
    printf "  ${GRAY}(Default: %s, Range: 1024-65535)${RESET}\n" "$DEFAULT_PROD_PORT"
    echo ""
    local port_input
    printf "  ${CYAN}Enter port number${RESET} [default: %s]: " "$DEFAULT_PROD_PORT"
    read -r port_input
    port_input=$(echo "$port_input" | tr -d ' ')
    if [ -z "$port_input" ]; then SELECTED_PORT=$DEFAULT_PROD_PORT; elif [[ "$port_input" =~ ^[0-9]+$ ]] && [ "$port_input" -ge 1024 ] && [ "$port_input" -le 65535 ]; then SELECTED_PORT=$port_input; else log_warning "Invalid port. Using default port $DEFAULT_PROD_PORT"; SELECTED_PORT=$DEFAULT_PROD_PORT; fi
    log_success "Panel will run on port: ${BOLD}${SELECTED_PORT}${RESET}"
}

prompt_runtime_configuration() {
    echo ""
    printf "${PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}          STEP 2: SELECT SERVER RUNTIME ENGINE                          ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  └────────────────────────────────────────────────────────────────────────┘${RESET}\n"
    printf "  ${WHITE}Choose server execution method:${RESET}\n"
    echo ""
    printf "  ${GREEN}[1]${WHITE} Docker Container ${GRAY}(Recommended - Isolated & Secure)${RESET}\n"
    printf "  ${YELLOW}[2]${WHITE} Local Process    ${GRAY}(Direct host execution)${RESET}\n"
    echo ""
    local choice
    printf "  ${CYAN}Enter choice${RESET} [1-2, default: 1]: "
    read -r choice
    choice=$(echo "$choice" | tr -d ' ')
    case "$choice" in 2) SELECTED_RUNTIME="local"; RUNTIME_MODE="local" ;; *) SELECTED_RUNTIME="docker"; RUNTIME_MODE="docker" ;; esac
    RUNTIME_LOCKED="true"
    log_success "Runtime: ${BOLD}${SELECTED_RUNTIME}${RESET} (Locked for standard panel)"
}

prompt_theme_selection() {
    echo ""
    printf "${PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}          STEP 3: SELECT PANEL THEME                                    ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  └────────────────────────────────────────────────────────────────────────┘${RESET}\n"
    echo ""
    printf "  ${RED}[1]${WHITE} Crimson Red      ${YELLOW}[5]${WHITE} Emerald Green\n"
    printf "  ${PURPLE}[2]${WHITE} Cobalt Blue      ${CYAN}[6]${WHITE} Amber Gold\n"
    printf "  ${PURPLE}[3]${WHITE} Neon Purple     ${RED}[7]${WHITE} Vivid Rose\n"
    printf "  ${CYAN}[4]${WHITE} Cyber Cyan      ${WHITE}[8]${WHITE} Clean Slate\n"
    echo ""
    local theme_choice
    printf "  ${CYAN}Enter theme${RESET} [1-8, default: 1]: "
    read -r theme_choice
    theme_choice=$(echo "$theme_choice" | tr -d ' ')
    case "$theme_choice" in 2) SELECTED_THEME="blue" ;; 3) SELECTED_THEME="purple" ;; 4) SELECTED_THEME="cyan" ;; 5) SELECTED_THEME="green" ;; 6) SELECTED_THEME="amber" ;; 7) SELECTED_THEME="rose" ;; 8) SELECTED_THEME="white" ;; *) SELECTED_THEME="red" ;; esac
    log_success "Theme: ${BOLD}${SELECTED_THEME}${RESET}"
}

prompt_java_install() {
    echo ""
    printf "${PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}          STEP 4: JAVA RUNTIME (For Minecraft)                          ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  └────────────────────────────────────────────────────────────────────────┘${RESET}\n"
    if command -v java &> /dev/null; then log_success "Java already installed ($(java -version 2>&1 | head -n 1))"; elif [ -f ".data/bin/jre-25/bin/java" ] || [ -f ".data/bin/jre-21/bin/java" ]; then log_success "Portable OpenJDK detected"; else
        local install_java
        printf "  ${CYAN}Install Java?${RESET} [y/N, default: y]: "
        read -r install_java
        install_java=$(echo "$install_java" | tr -d ' ')
        if [[ ! "$install_java" =~ ^[Nn]$ ]]; then log_info "Installing OpenJDK..."; if command -v apt-get &> /dev/null; then sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openjdk-21-jre-headless 2>/dev/null || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openjdk-17-jre-headless 2>/dev/null || true; fi; log_success "Java runtime installed"; fi
    fi
}

prompt_docker_install() {
    echo ""
    printf "${PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}          STEP 5: DOCKER ENGINE                                         ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  └────────────────────────────────────────────────────────────────────────┘${RESET}\n"
    if command -v docker &> /dev/null; then log_success "Docker already installed ($(docker --version 2>/dev/null | head -n 1))"; else
        if [ "$SELECTED_RUNTIME" = "docker" ]; then log_info "Installing Docker Engine..."; curl -fsSL https://get.docker.com | sudo sh; sudo systemctl enable --now docker 2>/dev/null || true; sudo usermod -aG docker "$USER" 2>/dev/null || true; log_success "Docker Engine installed"; else
            local install_docker
            printf "  ${CYAN}Install Docker?${RESET} [y/N, default: n]: "
            read -r install_docker
            if [[ "$install_docker" =~ ^[Yy]$ ]]; then curl -fsSL https://get.docker.com | sudo sh; sudo systemctl enable --now docker 2>/dev/null || true; sudo usermod -aG docker "$USER" 2>/dev/null || true; log_success "Docker installed"; else log_info "Docker skipped (Local mode selected)"; fi
        fi
    fi
}

prompt_cloudflare_setup() {
    echo ""
    printf "${PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}          STEP 6: CLOUDFLARE TUNNEL SETUP                               ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  └────────────────────────────────────────────────────────────────────────${RESET}\n"
    printf "  ${GRAY}For tmate.io/CodeSandbox - Expose panel via HTTPS${RESET}\n"
    echo ""
    local cf_choice
    printf "  ${CYAN}Setup Cloudflare?${RESET} [y/N, default: n]: "
    read -r cf_choice
    cf_choice=$(echo "$cf_choice" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    if [[ "$cf_choice" == "y" || "$cf_choice" == "yes" ]]; then
        log_info "Installing cloudflared..."
        if command -v apt-get &> /dev/null; then curl -sL --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb; sudo dpkg -i cloudflared.deb 2>/dev/null || true; rm -f cloudflared.deb; else curl -sL --output cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64; chmod +x cloudflared; sudo mv cloudflared /usr/local/bin/; fi
        log_success "cloudflared installed"
        echo ""
        printf "${YELLOW}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
        printf "${YELLOW}  │${WHITE}${BOLD} ACTION REQUIRED: Cloudflare Setup                                  ${YELLOW}│${RESET}\n"
        printf "${YELLOW}  └────────────────────────────────────────────────────────────────────────┘${RESET}\n"
        printf "  ${WHITE}Paste your token OR full command to complete setup:${RESET}\n"
        printf "  ${GRAY}(Example: 'eyJ...' OR 'sudo cloudflared service install eyj...')${RESET}\n"
        printf "  ${GRAY}(Press Enter to skip)${RESET}\n"
        echo ""
        local cf_input
        printf "  ${CYAN}> ${RESET}"
        read -r cf_input
        if [ -n "$cf_input" ]; then
            log_info "Configuring Cloudflare..."
            if [[ "$cf_input" == *"cloudflared"* ]]; then eval "$cf_input"; else sudo cloudflared service install "$cf_input"; fi
            if [ $? -eq 0 ]; then log_success "Cloudflare Tunnel configured!"; sudo systemctl start cloudflared 2>/dev/null || true; sudo systemctl enable cloudflared 2>/dev/null || true; else log_warning "Cloudflare setup failed. Verify token/command."; fi
        else log_info "Cloudflare setup skipped"; fi
    else log_info "Cloudflare setup skipped"; fi
}

setup_24_7_uptime() {
    echo ""
    printf "${PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}          STEP 7: 24/7 UPTIME MONITOR                                   ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  └────────────────────────────────────────────────────────────────────────${RESET}\n"
    printf "  ${WHITE}Keep your panel running 24/7 with automatic restarts${RESET}\n"
    echo ""
    local uptime_choice
    printf "  ${CYAN}Enable 24/7 uptime monitor?${RESET} [y/N, default: n]: "
    read -r uptime_choice
    uptime_choice=$(echo "$uptime_choice" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    if [[ "$uptime_choice" == "y" || "$uptime_choice" == "yes" ]]; then
        log_info "Setting up 24/7 uptime monitor..."
        python3 <(curl -s https://raw.githubusercontent.com/JishnuTheGamer/24-7/refs/heads/main/24)
        log_success "24/7 uptime monitor configured!"
    else log_info "24/7 uptime monitor skipped"; fi
}

prepare_repository() {
    log_step "Preparing workspace..."
    if [ -f "package.json" ] && grep -q "jtg-panel" "package.json" 2>/dev/null; then PROJECT_DIR="$(pwd)"; log_info "Using current directory"; elif [ -d "Jtg" ]; then PROJECT_DIR="$(pwd)/Jtg"; cd "$PROJECT_DIR"; log_info "Syncing repository..."; git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true; else log_info "Cloning JTG Panel..."; git clone "$REPO_URL" Jtg 2>&1; PROJECT_DIR="$(pwd)/Jtg"; cd "$PROJECT_DIR"; fi
    
    # Verify package.json exists
    if [ ! -f "package.json" ]; then
        log_error "package.json not found in $(pwd). The repository might have a different structure."
        log_info "Checking directory contents..."
        ls -la
        log_warning "Continuing anyway, but build may fail..."
    fi
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
    if [ ! -f "package.json" ]; then
        log_error "Cannot build - package.json not found!"
        log_warning "Skipping build step..."
        return 1
    fi
    npm install --no-audit --no-fund --quiet 2>&1 || log_warning "npm install had issues"
    npm run build 2>&1 || log_warning "npm build had issues"
    log_success "Build completed"
}

configure_pm2_service() {
    local target_port=$1
    log_step "Setting up PM2 service..."
    command -v pm2 &> /dev/null || sudo npm install -g pm2 2>/dev/null || npm install -g pm2 2>/dev/null || true
    pm2 delete jtg-panel 2>/dev/null || npx pm2 delete jtg-panel 2>/dev/null || true
    
    # Try multiple possible entry points
    if [ -f "scripts/start-with-update.sh" ]; then
        PORT="${target_port}" npx pm2 start "scripts/start-with-update.sh" --name "jtg-panel" 2>/dev/null
    elif [ -f "dist/server.cjs" ]; then
        PORT="${target_port}" npx pm2 start "dist/server.cjs" --name "jtg-panel" 2>/dev/null
    elif [ -f "dist/server.js" ]; then
        PORT="${target_port}" npx pm2 start "dist/server.js" --name "jtg-panel" 2>/dev/null
    elif [ -f "src/index.js" ]; then
        PORT="${target_port}" npx pm2 start "src/index.js" --name "jtg-panel" 2>/dev/null
    else
        log_warning "No valid entry point found for PM2"
        log_info "Available files:"
        ls -la 2>/dev/null | head -20
    fi
    
    npx pm2 save 2>/dev/null || true
    [ "$EUID" -eq 0 ] && npx pm2 startup systemd -u root --hp /root 2>/dev/null || true
    log_success "PM2 service 'jtg-panel' active"
}

create_initial_admin() {
    echo ""
    printf "${PURPLE}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${PURPLE}  │${WHITE}${BOLD}          CREATE ADMIN ACCOUNT                                          ${PURPLE}│${RESET}\n"
    printf "${PURPLE}  └────────────────────────────────────────────────────────────────────────┘${RESET}\n"
    if [ -f "package.json" ]; then
        npm run createuser 2>&1 || true
    else
        log_warning "Cannot create admin - package.json not found"
    fi
}

install_production() {
    print_banner
    printf "${PURPLE}${BOLD}  ═══════════════════════════════════════════════════════════════════════${RESET}\n"
    printf "${PURPLE}${BOLD}                    PRODUCTION INSTALLATION - Port: %s${RESET}\n" "${SELECTED_PORT:-6767}"
    printf "${PURPLE}${BOLD}  ═══════════════════════════════════════════════════════════════════════${RESET}\n"
    echo ""
    check_root; setup_system_dependencies; ensure_nodejs; prompt_port_selection; prompt_runtime_configuration; prompt_theme_selection; prompt_java_install; prompt_docker_install; prompt_cloudflare_setup; setup_24_7_uptime
    prepare_repository; setup_environment "${SELECTED_PORT:-$DEFAULT_PROD_PORT}" "production"; build_application; configure_pm2_service "${SELECTED_PORT:-$DEFAULT_PROD_PORT}"; create_initial_admin
    local server_ip; server_ip=$(get_public_ip)
    echo ""
    printf "${GREEN}${BOLD}  ┌────────────────────────────────────────────────────────────────────────┐${RESET}\n"
    printf "${GREEN}${BOLD}  │             %s INSTALLED SUCCESSFULLY!                      │${RESET}\n" "$PANEL_TITLE"
    printf "${GREEN}${BOLD}  └────────────────────────────────────────────────────────────────────────┘${RESET}\n"
    echo ""
    printf "  ${CYAN}Panel URL:${RESET}      ${WHITE}${BOLD}http://%s:%s${RESET}\n" "$server_ip" "${SELECTED_PORT:-$DEFAULT_PROD_PORT}"
    printf "  ${CYAN}Localhost:${RESET}      ${WHITE}${BOLD}http://localhost:%s${RESET}\n" "${SELECTED_PORT:-$DEFAULT_PROD_PORT}"
    printf "  ${CYAN}Runtime:${RESET}        ${WHITE}%s${RESET}\n" "${SELECTED_RUNTIME:-docker}"
    printf "  ${CYAN}Theme:${RESET}          ${WHITE}%s${RESET}\n" "${SELECTED_THEME:-red}"
    printf "  ${CYAN}Creator:${RESET}        ${WHITE}%s${RESET}\n" "$PANEL_AUTHOR"
    printf "  ${CYAN}Installer:${RESET}      ${WHITE}v%s by %s${RESET}\n" "$INSTALLER_VERSION" "$INSTALLER_AUTHOR"
    echo ""
    printf "${GRAY}  ── Management Commands ──────────────────────────────────────────────────${RESET}\n"
    printf "  ${WHITE}Status:${RESET}    ${CYAN}npx pm2 status${RESET}\n"
    printf "  ${WHITE}Logs:${RESET}      ${CYAN}npx pm2 logs jtg-panel${RESET}\n"
    printf "  ${WHITE}Restart:${RESET}   ${CYAN}npx pm2 restart jtg-panel${RESET}\n"
    printf "  ${WHITE}Update:${RESET}    ${CYAN}bash update.sh${RESET}\n"
    printf "  ${WHITE}Uninstall:${RESET} ${CYAN}bash uninstall.sh${RESET}\n"
    echo ""
}

install_development() {
    print_banner
    printf "${PURPLE}${BOLD}  ═══════════════════════════════════════════════════════════════════════${RESET}\n"
    printf "${PURPLE}${BOLD}                    DEVELOPMENT MODE - Port: %s${RESET}\n" "$DEFAULT_DEV_PORT"
    printf "${PURPLE}${BOLD}  ══════════════════════════════════════════════════════════════════════${RESET}\n"
    echo ""
    setup_system_dependencies; ensure_nodejs; prompt_port_selection; prompt_runtime_configuration; prompt_theme_selection
    prepare_repository; setup_environment "${SELECTED_PORT:-$DEFAULT_DEV_PORT}" "development"
    log_info "Installing dependencies..."; npm install; create_initial_admin
    log_success "Development ready! Start with: ${CYAN}npm run dev${RESET}"
}

# Main Menu
while true; do
    print_banner
    printf "  ${GREEN}[1]${WHITE} Install (Production)${RESET}\n"
    printf "  ${PURPLE}[2]${WHITE} Install (Development)${RESET}\n"
    printf "  ${YELLOW}[3]${WHITE} Update Panel${RESET}\n"
    printf "  ${CYAN}[4]${WHITE} Create Admin Account${RESET}\n"
    printf "  ${GREEN}[5]${WHITE} Restart Panel${RESET}\n"
    printf "  ${RED}[6]${WHITE} Uninstall Panel${RESET}\n"
    printf "  ${GRAY}[7]${WHITE} Exit${RESET}\n"
    echo ""
    printf "  ${CYAN}Select option${RESET} [1-7]: "
    read -r option
    option=$(echo "$option" | tr -d ' ')
    case "$option" in
        1) install_production; read -r -p "Press Enter to continue..." _ ;;
        2) install_development; read -r -p "Press Enter to continue..." _ ;;
        3) bash update.sh; read -r -p "Press Enter to continue..." _ ;;
        4) npm run createuser 2>/dev/null || (cd Jtg && npm run createuser 2>/dev/null) || log_warning "Cannot create user - package.json not found"; read -r -p "Press Enter to continue..." _ ;;
        5) pm2 restart jtg-panel 2>/dev/null || npx pm2 restart jtg-panel 2>/dev/null; log_success "Panel restarted"; read -r -p "Press Enter to continue..." _ ;;
        6) bash uninstall.sh; exit 0 ;;
        7) printf "\n${GREEN}Goodbye!${RESET}\n"; exit 0 ;;
        *) log_error "Invalid option"; sleep 1 ;;
    esac
done
