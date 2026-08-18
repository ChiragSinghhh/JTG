# 🚀 JTG Panel Custom Installer (v3.1)

A high-performance, fully automated, and custom-designed bash installer for the **JTG Panel**. Built from the ground up with a unique UI, robust error handling, and seamless **Cloudflare Tunnel** integration, making it perfect for restricted environments like `tmate.io` and `CodeSandbox`.

---

## 🏆 Credits & Copyright
- **Panel Creator:** [Jishnu](https://github.com/JishnuTheGamer)
- **Installer Creator, UI Designer & Copyright Holder:** **ChiragSingh**  
*(© 2026 ChiragSingh. All rights reserved for the Installer codebase, UI design, and automation logic.)*

---

## ✨ Features
- 🎨 **100% Custom UI:** Sleek Cyan, Gold, and White high-contrast terminal interface.
- ⚡ **Smart Dependency Management:** Auto-detects and installs only what's missing (Node.js 22 LTS, Docker, Java, Git, etc.).
- 🌐 **Cloudflare Tunnel Automation:** Specifically designed for `tmate.io` / `CodeSandbox`. Just paste your token or full command, and it handles the rest.
- 🛡️ **Crash-Resistant:** Removed aggressive `set -e` flags to prevent silent failures on minor sandbox warnings.
- ⚙️ **Flexible Runtime:** Choose between isolated Docker containers or direct Local Process execution.

---

## 📥 Quick Installation

Run this single command in your terminal to download and execute the installer:

```bash
curl -sSL https://raw.githubusercontent.com/ChiragSinghhh/JTG/main/install.sh | sudo bash
```

*Alternatively, using `wget`:*
```bash
wget -qO install.sh https://raw.githubusercontent.com/ChiragSinghhh/JTG/main/install.sh && sudo bash install.sh
```

---

## 🛠️ Manual Installation Steps
If you prefer to download it manually:
1. Download the script:  
   `wget -O install.sh https://raw.githubusercontent.com/ChiragSinghhh/JTG/main/install.sh`
2. Make it executable:  
   `chmod +x install.sh`
3. Run with root privileges:  
   `sudo bash install.sh`

---

## ☁️ Cloudflare Tunnel Setup (For tmate.io / CodeSandbox)
During the installation (Step 5), the installer will ask if you want to set up a Cloudflare Tunnel. 
- If you select **Yes**, it will prompt you:  
  *"Please send your token or the entire code for install to be completed."*
- You can paste **just the token** (e.g., `eyJ...`) OR the **full command** (e.g., `sudo cloudflared service install eyj...`).
- The installer is smart enough to detect which one you pasted and will configure it automatically, giving you a secure HTTPS link without port forwarding.

---

## ⚖️ License
This installer script is proprietary software created by **ChiragSingh**.  
Usage is permitted for installing the JTG Panel, but redistribution, modification, or claiming ownership of the installer code/UI without explicit permission is strictly prohibited.  
See the [LICENSE](LICENSE) file for full details.

---

## 📞 Support
If you face any issues during installation, please open an issue in this repository or contact the installer maintainer.
