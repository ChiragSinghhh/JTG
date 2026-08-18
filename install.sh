#!/usr/bin/env bash

# ==============================================================================
#       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     
#       ██║╚══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     
#       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     
#  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     
#  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗
#   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
#
#  Product Name   : JTG PANEL
#  Panel Version  : v3.0
#  Panel Creator  : Jishnu
#  Installer Ver  : 1.2 (Custom UI & Cloudflare Integration)
#  Installer By   : ChiragSingh
#  Repository     : https://github.com/JishnuTheGamer/Jtg
# ==============================================================================

# Panel & Installer Core Configuration
PANEL_TITLE="JTG PANEL"
PANEL_AUTHOR="Jishnu"
INSTALLER_AUTHOR="ChiragSingh"
INSTALLER_VERSION="1.2"
DEFAULT_PROD_PORT=6767
DEFAULT_DEV_PORT=30000
REPO_URL="https://github.com/JishnuTheGamer/Jtg.git"

# Custom High-Contrast UI Palette (Cyan, Gold, White, Dark)
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_CYAN='\033[38;5;51m'
C_GOLD='\033[38;5;220m'
C_WHITE='\033[38;5;255m'
C_MUTED='\033[38;5;244m'
C_SUCCESS='\033[38;5;82m'
C_ERROR='\033[38;5;196m'

# Background Badges
BG_CYAN='\033[48;5;51;38;5;235m'
BG_GOLD='\033[48;5;220;38;5;235m'

print_banner() {
    clear
    echo -e "${C_CYAN}${C_BOLD}"
    echo "       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     "
    echo "       ██║══██╔══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     "
    echo "       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     "
    echo "  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║     "
    echo "  ╚█████╔╝   ██║   ╚██████╔╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗"
    echo "   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝"
    echo -e "${C_RESET}"
    echo -e "${C_CYAN}  ╭──────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}                     JTG PANEL INSTALLER v${INSTALLER_VERSION}                      ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_MUTED}         Next-Gen Game Server & Workload Control Dashboard                ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_GOLD}                  Panel Creator: ${C_WHITE}${C_BOLD}${PANEL_AUTHOR}                              ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_GOLD}                  Custom Installer By: ${C_WHITE}${C_BOLD}${INSTALLER_AUTHOR}                   ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_MUTED}         Repo: ${C_WHITE}https://github.com/JishnuTheGamer/Jtg                      ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  ╰──────────────────────────────────────────────────────────────────────────╯${C_RESET}"
    echo ""
}

log_info() {
    echo -e " ${C_CYAN}[INFO]${C_RESET} ${C_WHITE}$1${C_RESET}"
}

log_success() {
    echo -e " ${C_SUCCESS}${C_BOLD}[✓ SUCCESS]${C_RESET} ${C_WHITE}$1${C_RESET}"
}

log_warning() {
    echo -e " ${C_GOLD}${C_BOLD}[! WARNING]${C_RESET} ${C_WHITE}$1${C_RESET}"
}

log_error() {
    echo -e " ${C_ERROR}${C_BOLD}[✗ ERROR]${C_RESET} ${C_WHITE}$1${C_RESET}"
}

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
    log_info "Updating system package registry and tools..."

    if command -v apt-get &> /dev/null; then
        sudo dpkg --configure -a 2>/dev/null || true
        sudo apt-get clean 2>/dev/null || true
        sudo rm -f /var/cache/apt/archives/*.deb 2>/dev/null || true

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
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
                -o Dpkg::Options::="--force-confdef" \
                -o Dpkg::Options::="--force-confold" \
                -o Dpkg::Options::="--force-overwrite" \
                "${needed[@]}" 2>/dev/null || {
                    for pkg in "${needed[@]}"; do
                        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends "$pkg" 2>/dev/null || true
                    done
                }
        fi
    elif command -v yum &> /dev/null; then
        sudo yum update -y -q || true
        sudo yum install -y -q curl git make gcc-c++ ca-certificates tar xz jq || true
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm curl git base-devel ca-certificates tar xz jq || true
    fi
    log_success "Base system dependencies configured."
}

ensure_nodejs() {
    log_info "Verifying Node.js 20+ runtime environment..."
    local need_install=0

    if ! command -v node &> /dev/null; then
        need_install=1
    else
        local node_ver
        node_ver=$(node -v | cut -d'.' -f1 | tr -d 'v')
        if [ "$node_ver" -lt 20 ]; then
            log_warning "Detected legacy Node.js ($(node -v)). Upgrading to Node.js 22 LTS..."
            need_install=1
        fi
    fi

    if [ "$need_install" -eq 1 ]; then
        log_info "Installing Node.js 22.x LTS..."
        if command -v apt-get &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v yum &> /dev/null; then
            curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
            sudo yum install -y nodejs
        fi
    fi

    log_success "Node.js $(node -v) & npm $(npm -v) verified."
}

prompt_runtime_configuration() {
    echo ""
    echo -e "${C_CYAN}  ╭──────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}           STEP 1: SELECT SERVER EXECUTION RUNTIME ENGINE                 ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  ╰──────────────────────────────────────────────────────────────────────────╯${C_RESET}"
    echo -e "  Choose how server processes (Minecraft, Node.js, Python) execute on this node:"
    echo ""
    echo -e "  ${C_CYAN}${C_BOLD} [ 1 ] Docker Container Sandbox ${C_WHITE}(Recommended for Production)${C_RESET}"
    echo -e "        ${C_MUTED}Isolated per-server Docker containers with memory & CPU limits.${C_RESET}"
    echo ""
    echo -e "  ${C_GOLD}${C_BOLD} [ 2 ] Local Process Engine ${C_MUTED}(Direct Host Execution via Node/Java/Python)${C_RESET}"
    echo -e "        ${C_MUTED}Spawns background child processes natively directly on the host.${C_RESET}"
    echo ""
    
    local choice
    read -r -p "  Enter Selection [1 or 2, default: 1]: " choice
    choice=$(echo "$choice" | tr -d ' ')

    case "$choice" in
        2)
            SELECTED_RUNTIME="local"
            RUNTIME_MODE="local"
            ;;
        *)
            SELECTED_RUNTIME="docker"
            RUNTIME_MODE="docker"
            ;;
    esac

    RUNTIME_LOCKED="true"
    echo ""
    log_success "Active Server Runtime: ${C_BOLD}${SELECTED_RUNTIME}${C_RESET} (Enforced & Locked for standard panel)"
}

prompt_theme_selection() {
    echo ""
    echo -e "${C_CYAN}  ╭──────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}               STEP 2: SELECT PANEL ACCENT COLOR THEME                    ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  ╰──────────────────────────────────────────────────────────────────────────╯${C_RESET}"
    echo -e "  Select the primary brand & accent color scheme for the panel interface:"
    echo ""
    echo -e "  ${C_CYAN} [ 1 ] ${C_WHITE}Crimson Red   ${C_MUTED}(Signature JTG Red)${C_RESET}"
    echo -e "  ${C_CYAN} [ 2 ] ${C_WHITE}Cobalt Blue   ${C_MUTED}(Classic Deep Blue)${C_RESET}"
    echo -e "  ${C_CYAN} [ 3 ] ${C_WHITE}Neon Purple   ${C_MUTED}(Cyberpunk Glow)${C_RESET}"
    echo -e "  ${C_CYAN} [ 4 ] ${C_WHITE}Cyber Cyan    ${C_MUTED}(Electric Aqua)${C_RESET}"
    echo -e "  ${C_CYAN} [ 5 ] ${C_WHITE}Emerald Green ${C_MUTED}(Vibrant Matrix)${C_RESET}"
    echo -e "  ${C_CYAN} [ 6 ] ${C_WHITE}Amber Gold    ${C_MUTED}(Warm Radiant)${C_RESET}"
    echo -e "  ${C_CYAN} [ 7 ] ${C_WHITE}Vivid Rose    ${C_MUTED}(Pastel Neon)${C_RESET}"
    echo -e "  ${C_CYAN} [ 8 ] ${C_WHITE}Clean Slate   ${C_MUTED}(Monochrome Minimal)${C_RESET}"
    echo ""
    
    local theme_choice
    read -r -p "  Enter Theme Selection [1-8, default: 1]: " theme_choice
    theme_choice=$(echo "$theme_choice" | tr -d ' ')

    case "$theme_choice" in
        2) SELECTED_THEME="blue" ;;
        3) SELECTED_THEME="purple" ;;
        4) SELECTED_THEME="cyan" ;;
        5) SELECTED_THEME="green" ;;
        6) SELECTED_THEME="amber" ;;
        7) SELECTED_THEME="rose" ;;
        8) SELECTED_THEME="white" ;;
        *) SELECTED_THEME="red" ;;
    esac

    echo ""
    log_success "Panel Accent Theme Set: ${C_BOLD}${SELECTED_THEME}${C_RESET}"
}

prompt_java_install() {
    echo ""
    echo -e "${C_CYAN}  ╭──────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}             STEP 3: JAVA RUNTIME (MINECRAFT LOCAL ENGINE)                ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  ╰──────────────────────────────────────────────────────────────────────────╯${C_RESET}"
    
    if command -v java &> /dev/null; then
        log_success "Java is already installed ($(java -version 2>&1 | head -n 1))."
    elif [ -f ".data/bin/jre-25/bin/java" ] || [ -f ".data/bin/jre-21/bin/java" ]; then
        log_success "Portable OpenJDK runtime detected in .data/bin."
    else
        local install_java
        read -r -p "  Install OpenJDK Java Runtime on host? [y/N, default: y]: " install_java
        install_java=$(echo "$install_java" | tr -d ' ')
        if [[ "$install_java" =~ ^[Nn]$ ]]; then
            log_info "Skipping host Java installation. (The panel auto-provisions portable OpenJDK on demand)."
        else
            log_info "Installing OpenJDK..."
            if command -v apt-get &> /dev/null; then
                sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends openjdk-21-jre-headless 2>/dev/null || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends openjdk-17-jre-headless 2>/dev/null || true
            elif command -v yum &> /dev/null; then
                sudo yum install -y -q java-21-openjdk-headless || sudo yum install -y -q java-17-openjdk-headless || true
            fi
            log_success "Java runtime verified."
        fi
    fi
}

prompt_docker_install() {
    echo ""
    echo -e "${C_CYAN}  ╭──────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}               STEP 4: DOCKER CONTAINER ENGINE VERIFICATION              ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  ──────────────────────────────────────────────────────────────────────────╯${C_RESET}"

    if command -v docker &> /dev/null; then
        log_success "Docker Engine is active ($(docker --version 2>/dev/null | head -n 1))."
    else
        if [ "$SELECTED_RUNTIME" = "docker" ]; then
            log_info "Installing Docker Engine for container isolation..."
            curl -fsSL https://get.docker.com | sudo sh
            sudo systemctl enable --now docker 2>/dev/null || true
            sudo usermod -aG docker "$USER" 2>/dev/null || true
            log_success "Docker Engine installed and started."
        else
            local install_docker
            read -r -p "  Install Docker Engine? [y/N, default: n]: " install_docker
            if [[ "$install_docker" =~ ^[Yy]$ ]]; then
                curl -fsSL https://get.docker.com | sudo sh
                sudo systemctl enable --now docker 2>/dev/null || true
                sudo usermod -aG docker "$USER" 2>/dev/null || true
                log_success "Docker installed."
            else
                log_info "Docker skipped (Local Process mode selected)."
            fi
        fi
    fi
}

# ==============================================================================
# CLOUDFLARE INSTALLER & SETUP (STEP 5)
# ==============================================================================
prompt_cloudflare_setup() {
    echo ""
    echo -e "${C_CYAN}  ╭──────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}           STEP 5: CLOUDFLARE TUNNEL SETUP (For Tmate/CodeSandbox)    ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  ╰──────────────────────────────────────────────────────────────────────────╯${C_RESET}"
    echo -e "  ${C_WHITE}Manual setup on tmate.io or CodeSandbox is difficult. This automates it.${C_RESET}"
    echo -e "  ${C_WHITE}It will expose your panel securely via HTTPS without opening router ports.${C_RESET}"
    echo ""
    read -r -p "  Do you want to set up Cloudflare Tunnel now? [y/N, default: n]: " cf_choice
    cf_choice=$(echo "$cf_choice" | tr -d ' ' | tr '[:upper:]' '[:lower:]')

    if [[ "$cf_choice" == "y" || "$cf_choice" == "yes" ]]; then
        log_info "Downloading and installing cloudflared daemon..."
        if command -v apt-get &> /dev/null; then
            curl -sL --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
            sudo dpkg -i cloudflared.deb 2>/dev/null || true
            rm -f cloudflared.deb
        elif command -v yum &> /dev/null; then
            sudo yum install -y https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm 2>/dev/null || true
        else
            curl -sL --output cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
            chmod +x cloudflared
            sudo mv cloudflared /usr/local/bin/
        fi
        
        log_success "cloudflared binary installed."
        echo ""
        echo -e "${C_GOLD}  ──────────────────────────────────────────────────────────────────────────┐${C_RESET}"
        echo -e "${C_GOLD}  │ ${C_WHITE}${C_BOLD} ACTION REQUIRED: Complete Cloudflare Setup                           ${C_GOLD}│${C_RESET}"
        echo -e "${C_GOLD}  └──────────────────────────────────────────────────────────────────────────┘${C_RESET}"
        echo -e "  ${C_WHITE}To finish the setup for tmate.io / CodeSandbox, we need to link the tunnel.${C_RESET}"
        echo -e "  ${C_WHITE}${C_BOLD}Please send your token or the entire code for install to be completed.${C_RESET}"
        echo -e "  ${C_MUTED}(e.g., 'eyJ...' OR 'sudo cloudflared service install eyj...')${C_RESET}"
        echo -e "  ${C_MUTED}(Press Enter to skip if you don't have it yet. You can do this later.)${C_RESET}"
        echo ""
        read -r -p "  > Paste Token or Full Command here: " cf_input
        
        if [ -n "$cf_input" ]; then
            log_info "Processing Cloudflare configuration..."
            # Smart detection: If they pasted the full command (contains 'cloudflared'), run it directly.
            if [[ "$cf_input" == *"cloudflared"* ]]; then
                eval "$cf_input"
            else
                # If they just pasted the token, wrap it in the install command.
                sudo cloudflared service install "$cf_input"
            fi
            
            if [ $? -eq 0 ]; then
                log_success "Cloudflare Tunnel installed and configured successfully!"
                sudo systemctl start cloudflared 2>/dev/null || true
                sudo systemctl enable cloudflared 2>/dev/null || true
            else
                log_warning "Cloudflare configuration failed. Please verify your token or command."
            fi
        else
            log_info "Cloudflare setup skipped. You can configure it manually later."
        fi
    else
        log_info "Cloudflare Tunnel setup skipped."
    fi
}

prepare_repository() {
    log_info "Preparing application workspace..."

    if [ -f "package.json" ] && grep -q "jtg-panel" "package.json" 2>/dev/null; then
        PROJECT_DIR="$(pwd)"
        log_info "Using current workspace directory: ${PROJECT_DIR}"
    elif [ -d "Jtg" ]; then
        PROJECT_DIR="$(pwd)/Jtg"
        cd "$PROJECT_DIR"
        log_info "Found existing 'Jtg' directory. Syncing repository..."
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true
    else
        log_info "Cloning JTG Panel from ${REPO_URL}..."
        git clone "$REPO_URL" Jtg
        PROJECT_DIR="$(pwd)/Jtg"
        cd "$PROJECT_DIR"
    fi
}

setup_environment() {
    local target_port=$1
    local run_mode=$2

    log_info "Initializing environment & data structures..."

    if [ -f ".logs" ]; then
        rm -f ".logs"
    fi
    mkdir -p .data/servers .data/temp .data/logs backups .logs 2>/dev/null || true

    local jwt_secret
    jwt_secret=$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))" 2>/dev/null || echo "jtg_secret_key_$(date +%s)")

    cat > .env <<EOF
# ==============================================================================
# JTG PANEL Configuration
# Panel Creator: Jishnu | Custom Installer v1.2 by ChiragSingh
# ==============================================================================
NODE_ENV=${run_mode}
PORT=${target_port}
JWT_SECRET=${jwt_secret}
DEFAULT_RUNTIME=${SELECTED_RUNTIME:-docker}
ENABLE_DOCKER=$( [ "${SELECTED_RUNTIME:-docker}" = "docker" ] && echo "true" || echo "false" )
PANEL_RUNTIME_MODE=${RUNTIME_MODE:-docker}
PANEL_RUNTIME_LOCKED=${RUNTIME_LOCKED:-true}
PANEL_THEME=${SELECTED_THEME:-red}
DEV_MODE=$( [ "$run_mode" = "development" ] && echo "true" || echo "false" )
PANEL_DEV_MODE=$( [ "$run_mode" = "development" ] && echo "true" || echo "false" )
EOF

    node -e '
      const fs = require("fs");
      const path = ".data/settings.json";
      let s = {};
      try { if (fs.existsSync(path)) s = JSON.parse(fs.readFileSync(path, "utf8")); } catch(e){}
      s.defaultRuntime = process.env.DEFAULT_RUNTIME || "docker";
      s.runtimeLocked = process.env.PANEL_RUNTIME_LOCKED === "true";
      if (process.env.PANEL_THEME) s.theme = process.env.PANEL_THEME;
      fs.writeFileSync(path, JSON.stringify(s, null, 2));
    ' 2>/dev/null || true

    log_success "Environment configured on port ${target_port} (Runtime: ${SELECTED_RUNTIME:-docker}, Theme: ${SELECTED_THEME:-red})."
}

build_application() {
    log_info "Installing NPM dependencies..."
    npm install --no-audit --no-fund --quiet

    log_info "Compiling frontend assets & bundling server..."
    npm run build

    log_success "Application compilation succeeded."
}

configure_pm2_service() {
    local target_port=$1
    log_info "Configuring high-availability background process daemon..."

    if ! command -v pm2 &> /dev/null; then
        sudo npm install -g pm2 2>/dev/null || npm install -g pm2 2>/dev/null || true
    fi

    pm2 delete jtg-panel 2>/dev/null || npx pm2 delete jtg-panel 2>/dev/null || true

    PORT="${target_port}" npx pm2 start "scripts/start-with-update.sh" --name "jtg-panel" 2>/dev/null || PORT="${target_port}" npx pm2 start "dist/server.cjs" --name "jtg-panel"
    npx pm2 save 2>/dev/null || true

    if [ "$EUID" -eq 0 ]; then
        npx pm2 startup systemd -u root --hp /root 2>/dev/null || true
    fi

    log_success "PM2 service 'jtg-panel' registered and active."
}

create_initial_admin() {
    echo ""
    echo -e "${C_CYAN}  ╭──────────────────────────────────────────────────────────────────────────╮${C_RESET}"
    echo -e "${C_CYAN}  │ ${C_WHITE}${C_BOLD}                   CREATE PRIMARY OWNER ACCOUNT                           ${C_CYAN}│${C_RESET}"
    echo -e "${C_CYAN}  ╰──────────────────────────────────────────────────────────────────────────╯${C_RESET}"
    npm run createuser || true
}

install_production() {
    print_banner
    echo -e " ${BG_CYAN}${C_BOLD} [ PRODUCTION INSTALLATION ] ${C_RESET} ${C_WHITE}Deploying ${PANEL_TITLE} on port ${DEFAULT_PROD_PORT}${C_RESET}\n"
    
    check_root
    setup_system_dependencies
    ensure_nodejs
    prompt_runtime_configuration
    prompt_theme_selection
    prompt_java_install
    prompt_docker_install
    prompt_cloudflare_setup

    prepare_repository
    setup_environment "$DEFAULT_PROD_PORT" "production"
    build_application
    configure_pm2_service "$DEFAULT_PROD_PORT"
    create_initial_admin

    local server_ip
    server_ip=$(get_public_ip)
    
    echo ""
    echo -e "${C_WHITE}${C_BOLD}  ╔══════════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_WHITE}${C_BOLD}  ║                   ${PANEL_TITLE} INSTALLED SUCCESSFULLY!                     ║${C_RESET}"
    echo -e "${C_WHITE}${C_BOLD}  ╚══════════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
    echo -e "  ${C_MUTED}>>${C_RESET} ${C_WHITE}${C_BOLD}Panel Web Interface:${C_RESET}    ${C_CYAN}${C_BOLD}http://${server_ip}:${DEFAULT_PROD_PORT}${C_RESET}"
    echo -e "  ${C_MUTED}>>${C_RESET} ${C_WHITE}${C_BOLD}Localhost Access:${C_RESET}       ${C_CYAN}${C_BOLD}http://localhost:${DEFAULT_PROD_PORT}${C_RESET}"
    echo -e "  ${C_MUTED}>>${C_RESET} ${C_WHITE}${C_BOLD}Enforced Runtime:${C_RESET}       ${C_WHITE}${SELECTED_RUNTIME:-docker}${C_RESET} (Locked: ${RUNTIME_LOCKED:-true})"
    echo -e "  ${C_MUTED}>>${C_RESET} ${C_WHITE}${C_BOLD}Accent Theme:${C_RESET}           ${C_WHITE}${SELECTED_THEME:-red}${C_RESET}"
    echo -e "  ${C_MUTED}>>${C_RESET} ${C_WHITE}${C_BOLD}Panel Creator:${C_RESET}          ${C_WHITE}${PANEL_AUTHOR}${C_RESET}"
    echo -e "  ${C_MUTED}>>${C_RESET} ${C_WHITE}${C_BOLD}Installer Version:${C_RESET}      ${C_GOLD}${INSTALLER_VERSION} by ${INSTALLER_AUTHOR}${C_RESET}"
    echo ""
    echo -e "  ${C_MUTED}┌── Useful Management Commands ───────────────────────────────────────────${C_RESET}"
    echo -e "  ${C_MUTED}│${C_RESET} Check Status:     ${C_CYAN}npx pm2 status${C_RESET}"
    echo -e "  ${C_MUTED}│${C_RESET} Live Logs:        ${C_CYAN}npx pm2 logs jtg-panel${C_RESET}"
    echo -e "  ${C_MUTED}│${C_RESET} Restart Panel:    ${C_CYAN}npx pm2 restart jtg-panel${C_RESET}"
    echo -e "  ${C_MUTED}│${C_RESET} Update Panel:     ${C_CYAN}bash update.sh${C_RESET}"
    echo -e "  ${C_MUTED}│${C_RESET} Uninstall:        ${C_CYAN}bash uninstall.sh${C_RESET}"
    echo -e "  ${C_MUTED}└─────────────────────────────────────────────────────────────────────────┘${C_RESET}"
    echo ""
}

install_development() {
    print_banner
    echo -e " ${BG_GOLD}${C_BOLD} [ DEVELOPMENT SETUP ] ${C_RESET} ${C_WHITE}Configuring ${PANEL_TITLE} Dev Environment on port ${DEFAULT_DEV_PORT}${C_RESET}\n"
    
    setup_system_dependencies
    ensure_nodejs
    prompt_runtime_configuration
    prompt_theme_selection
    prepare_repository
    setup_environment "$DEFAULT_DEV_PORT" "development"
    
    log_info "Installing dependencies..."
    npm install
    create_initial_admin

    echo ""
    log_success "Development workspace ready!"
    echo -e "  Start development server: ${C_CYAN}npm run dev${C_RESET}"
}

# Main Interactive Dispatcher
while true; do
    print_banner
    echo -e "  ${C_CYAN}${C_BOLD} [ 1 ] ${C_WHITE}Install ${PANEL_TITLE} (Production Deployment - Port ${DEFAULT_PROD_PORT})${C_RESET}"
    echo -e "  ${C_CYAN}${C_BOLD} [ 2 ] ${C_WHITE}Install ${PANEL_TITLE} (Development Mode - Port ${DEFAULT_DEV_PORT})${C_RESET}"
    echo -e "  ${C_CYAN}${C_BOLD} [ 3 ] ${C_WHITE}Update Panel (Pull GitHub updates & rebuild)${C_RESET}"
    echo -e "  ${C_CYAN}${C_BOLD} [ 4 ] ${C_WHITE}Create / Reset Administrator Account${C_RESET}"
    echo -e "  ${C_CYAN}${C_BOLD} [ 5 ] ${C_WHITE}Restart Panel Service${C_RESET}"
    echo -e "  ${C_CYAN}${C_BOLD} [ 6 ] ${C_WHITE}Uninstall Panel${C_RESET}"
    echo -e "  ${C_CYAN}${C_BOLD} [ 7 ] ${C_MUTED}Exit${C_RESET}"
    echo ""
    echo -e "  ${C_MUTED}──────────────────────────────────────────────────────────────────────────${C_RESET}"
    
    read -r -p "  Select an option [1-7]: " option
    option=$(echo "$option" | tr -d ' ')

    case "$option" in
        1)
            install_production
            echo ""
            read -r -p "  Press Enter to return to main menu..." _
            ;;
        2)
            install_development
            echo ""
            read -r -p "  Press Enter to return to main menu..." _
            ;;
        3)
            bash update.sh
            echo ""
            read -r -p "  Press Enter to return to main menu..." _
            ;;
        4)
            npm run createuser || (cd Jtg && npm run createuser)
            echo ""
            read -r -p "  Press Enter to return to main menu..." _
            ;;
        5)
            log_info "Restarting JTG Panel..."
            pm2 restart jtg-panel 2>/dev/null || npx pm2 restart jtg-panel 2>/dev/null || npm run start:auto-update
            log_success "Panel service restarted."
            echo ""
            read -r -p "  Press Enter to return to main menu..." _
            ;;
        6)
            bash uninstall.sh
            exit 0
            ;;
        7)
            echo -e "\n  ${C_CYAN}Exiting installer. Thank you for using ${PANEL_TITLE}!${C_RESET}\n"
            exit 0
            ;;
        *)
            log_error "Invalid selection. Please enter a number between 1 and 7."
            sleep 1.2
            ;;
    esac
done
