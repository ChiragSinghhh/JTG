<div align="center">

# 🚀 JTG Panel Custom Installer

**The Ultimate, High-Performance Bash Installer for JTG Panel**

[![Version](https://img.shields.io/badge/Installer-v1.3-purple?style=for-the-badge)](https://github.com/ChiragSinghhh/JTG)
[![Panel Version](https://img.shields.io/badge/Panel-v3.2-cyan?style=for-the-badge)](https://github.com/JishnuTheGamer/Jtg)
[![License](https://img.shields.io/badge/License-Custom-red?style=for-the-badge)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Active-green?style=for-the-badge)](https://github.com/ChiragSinghhh/JTG)

</div>

---

## 🌟 About The Project

Welcome to the **JTG Panel Custom Installer (v1.3)**. This is not just a basic setup script; it is a completely redesigned, robust, and feature-rich installation environment built from the ground up by **ChiragSingh**. 

Designed specifically to work flawlessly on minimal VPS environments (like tmate.io, CodeSandbox, and Meowlix), this installer automates the deployment of the **JTG Panel (v3.2)** with a sleek UI, smart error handling, and integrated Cloudflare tunneling.

---

## ✨ Next-Level Features

- 🎨 **Custom Redesigned UI:** A beautiful, high-contrast Purple & Cyan terminal interface that is easy to read and professional.
- ☁️ **Integrated Cloudflare Tunnel:** Step 6 automatically installs and configures `cloudflared` using a direct GitHub binary download (bypassing buggy apt GPG errors).
- 🔄 **24/7 Uptime Monitor:** Built-in Step 7 to keep your panel running forever with automatic restarts.
- ⚡ **Smart Dependency Management:** Automatically detects and installs missing tools (`curl`, `wget`, `git`, `node`) without crashing.
- 🛡️ **Crash-Resistant:** Optimized for restricted environments. No silent failures on minor sandbox warnings.
- 📦 **Modular Scripts:** Separate, standalone scripts for Cloudflare, Updating, and Uninstalling.

---

## 📥 Quick Installation

> **Note:** This installer requires `sudo` or `root` privileges.

### ⚡ One-Liner Install (Recommended)
Run this command in your terminal to start the interactive setup:

```bash
wget -qO - https://raw.githubusercontent.com/ChiragSinghhh/JTG/main/install.sh | sudo bash
```

### 📂 Manual Installation
If you prefer to download the script first:

```bash
# 1. Download the installer
wget -qO install.sh https://raw.githubusercontent.com/ChiragSinghhh/JTG/main/install.sh

# 2. Make it executable
chmod +x install.sh

# 3. Run the installer
sudo bash install.sh
```

---

## ☁️ Standalone Cloudflare Installer

Already installed the panel but need to set up a Cloudflare Tunnel later? Use the dedicated `cf.sh` script. It bypasses standard repository GPG errors by downloading the binary directly from GitHub.

```bash
wget -qO - https://raw.githubusercontent.com/ChiragSinghhh/JTG/main/cf.sh | sudo bash
```

---

## 🛠️ Management Commands

Once installed, you can manage your panel using these built-in scripts:

| Action | Command |
| :--- | :--- |
| **Update Panel** | `bash update.sh` |
| **Uninstall Panel** | `bash uninstall.sh` |
| **Restart Service** | `npx pm2 restart jtg-panel` |
| **View Live Logs** | `npx pm2 logs jtg-panel` |

---

##  Terminal Preview

```text
       ██╗████████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗     
       ██║╚══██══╝██╔════╝     ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     
       ██║   ██║   ██║  ███╗    ██████╔╝███████║██╔██╗ ██║█████╗  ██║     
  ██   ██║   ██║   ██║   ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██══╝  ██║     
  ╚█████╔╝   ██║   ╚██████╝    ██║     ██║  ██║██║ ╚████║███████╗███████╗
   ╚════╝    ╚═╝    ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

  ────────────────────────────────────────────────────────────────────────
  │                  JTG PANEL INSTALLER v1.3                       │
  │         Next-Gen Game Server & Workload Control Dashboard              │
  │                  Panel Creator: Jishnu                             │
  │               Custom Installer By: ChiragSingh                      │
  ────────────────────────────────────────────────────────────────────────

  [1] Install (Production)
  [2] Install (Development)
  [3] Update Panel
  [4] Create Admin Account
  [5] Restart Panel
  [6] Uninstall Panel
  [7] Exit
```

---

## 🏆 Credits & Copyright

This project consists of two distinct parts. Please respect the ownership of both:

- **🎮 Panel Core (v3.2):** Created and developed by **[Jishnu](https://github.com/JishnuTheGamer)**. All rights to the underlying panel software belong to him.
- **🛠️ Custom Installer (v1.3):** Designed, coded, and copyrighted by **ChiragSingh**. The UI design, automation logic, Cloudflare integration, and bash scripting are the exclusive intellectual property of ChiragSingh.

> © 2024 ChiragSingh. All rights reserved for the Installer codebase. Redistribution or claiming ownership of the installer UI/logic without permission is strictly prohibited.

---

<div align="center">
  
**Made with ❤️ by ChiragSingh**  
[GitHub](https://github.com/ChiragSinghhh) • [Report Issue](https://github.com/ChiragSinghhh/JTG/issues)

</div>
