# Personal Dotfiles & NixOS Configuration

A comprehensive, multi-platform dotfiles repository managing Linux, macOS, and specialized devices through Nix flakes, NixOS, nix-darwin, and Home Manager.

## 📊 Architecture Overview

This repository manages **7 devices** across multiple platforms and architectures:

- **3 Servers**: mirai (main), deoxys (VM), tsuba (Raspberry Pi)  
- **1 Workstation**: ryu (primary desktop)
- **3 Portable devices**: kuro (MacBook), SteamDeck, and 1 desktop Mac Mini (shiro)

> 📈 **Visual Architecture**: See [Device Architecture Diagram](assets/devices-diagram.svg) for a complete visual overview.

## 🖥️ Device Portfolio

### Server Infrastructure
| Device | Architecture | Role | Services |
|--------|-------------|------|----------|
| **mirai** | x86_64-linux | Main Server | Nextcloud, Gitea, Grafana, Minecraft, Immich, Paperless, +20 more |
| **deoxys** | x86_64-linux | VM Server | Testing & isolation environment |
| **tsuba** | aarch64-linux | Raspberry Pi | ARM-based lightweight services |

### Development Environment
| Device | Architecture | Setup | Features |
|--------|-------------|-------|----------|
| **ryu** | x86_64-linux | Main Desktop | Hyprland+GNOME, 3-monitor setup, gaming, audio production |
| **shiro** | aarch64-darwin | Mac Mini Desktop | nix-darwin + Home Manager, build server |

### Portable Devices  
| Device | Architecture | Platform | Configuration |
|--------|-------------|----------|---------------|
| **kuro** | aarch64-darwin | MacBook | nix-darwin + Home Manager |
| **SteamDeck** | x86_64-linux | SteamOS | Home Manager only |

## 🚀 Quick Start

### Prerequisites
```bash
# Install Nix with flakes support
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Installation

#### NixOS (Linux)
```bash
sudo nixos-rebuild switch --flake .#<device-name>
```

#### macOS (nix-darwin)
```bash
nix run nix-darwin -- switch --flake .#<device-name>
```

#### Home Manager only (SteamDeck)
```bash
nix run home-manager/master -- switch --flake .#deck
```

### Available Devices
- `mirai` - Main server
- `ryu` - Primary desktop  
- `deoxys` - VM server
- `tsuba` - Raspberry Pi
- `kuro` - MacBook (fs0c131y)
- `shiro` - MacBook (servius)
- `deck` - SteamDeck

## 🛠️ Development Tools

### Using Just (Recommended)
```bash
# Install on current system
just install

# Build without switching
just build

# Try Neovim configuration
just nvim

# Home Manager for non-NixOS
just home
```

### Core Technologies
- **OS**: NixOS, macOS, SteamOS
- **Shells**: Fish (primary), Nushell 
- **Editor**: Neovim with custom nixvim configuration
- **Desktop**: Hyprland (Linux), Yabai + Aerospace (macOS)
- **Terminals**: Foot, Wezterm, Kitty
- **Package Management**: Nix Flakes with distributed building

## 🎯 Key Features

### 🔧 Multi-Platform Configuration Management
- **NixOS**: Complete system configuration for servers and workstations
- **nix-darwin**: macOS system management with Homebrew integration
- **Home Manager**: User environment configuration across all platforms

### 🌐 Network Infrastructure
- **Tailscale VPN**: Secure mesh networking across all devices
- **ZeroTier**: Secondary network layer for specific services
- **SSH Deployment**: Automated deployment via deploy-rs

### ⚡ Development Environment
- **Nixvim**: Custom Neovim configuration with LSP, tree-sitter, and plugins
- **Multi-monitor support**: Professional 3-monitor setup on ryu
- **Cross-compilation**: ARM64 and x86_64 support with distributed builds

### 🔒 Security & Secrets Management
- **SOPS**: Encrypted secrets management across all devices
- **SSH Keys**: Centralized key distribution
- **Secure Boot**: Lanzaboote implementation on ryu
- **TPM Support**: Hardware security module integration

### 🏗️ Build Infrastructure
- **Distributed Building**: mirai, shiro as build servers
- **Binary Caches**: nix-community and custom caches
- **Cross-platform**: ARM64 and x86_64 builds

## 📦 Self-Hosted Services (mirai)

### Core Services
- **Nextcloud**: File storage and synchronization
- **Gitea**: Self-hosted Git server
- **Grafana**: Monitoring and dashboards
- **Immich**: Photo management and AI-powered search
- **Paperless**: Document management and OCR

### Development Tools
- **Atuin**: Shell history synchronization
- **LLDAP**: Lightweight LDAP server
- **VS Code Server**: Remote development environment

### Entertainment & Media
- **Minecraft Server**: Gaming server
- **Navidrome**: Music streaming server
- **Polaris**: Alternative music server

### Networking & Security
- **Tailscale**: VPN coordination node
- **ZeroTier**: Network management
- **Fail2ban**: Intrusion prevention
- **Caddy**: Reverse proxy and SSL termination

## 🎮 Gaming & Entertainment

### Gaming Setup (ryu)
- **Steam**: Native Linux gaming
- **Wine/Proton**: Windows game compatibility
- **Controller support**: Multiple gamepad configurations
- **Performance**: NVIDIA GPU with CUDA support

### Audio Production
- **Musnix**: Real-time audio kernel optimization
- **Professional audio**: Low-latency audio pipeline
- **Hardware support**: Audio interfaces and MIDI controllers

## 📱 Portable Configuration

### macOS Features (kuro - MacBook, shiro - Mac Mini)
- **Touch ID**: Sudo authentication integration (kuro)
- **Keyboard remapping**: Custom modifier key layouts
- **Aerospace/Yabai**: Tiling window management
- **Homebrew**: Package management for macOS-specific applications
- **Build server**: shiro serves as ARM64 build machine

### SteamDeck Integration
- **Home Manager**: User environment without system changes
- **Tailscale**: VPN connectivity for remote access
- **Development tools**: Portable development environment

## 🔄 Deployment & Management

### Automated Deployment
```bash
# Deploy to all servers from ryu
deploy .

# Deploy specific device
deploy .#mirai
```

### Build Management
- **Local builds**: Fast builds on powerful workstations
- **Remote builds**: Offload to build servers for efficiency
- **Binary caches**: Minimize rebuild times across devices

### Configuration Updates
- **Git-based**: All configurations version controlled
- **Atomic updates**: Rollback capability for all changes
- **Testing**: Safe deployment with easy rollback

## 📚 Try My Configurations

### Neovim Configuration
```bash
# Try my Neovim setup without installation
nix run github:uttarayan21/dotfiles#neovim
```

### Standalone Packages
The flake provides packages for:
- Custom Neovim configuration
- Development shells with tools
- Custom applications and scripts

## 🛡️ Security Practices

- **Encrypted secrets**: All sensitive data managed via SOPS
- **SSH hardening**: Key-based authentication only
- **Network segmentation**: VPN-based access control
- **Regular updates**: Automated security updates via Nix channels
- **Hardware security**: TPM and secure boot where available

## 📖 Documentation

- **[Device Architecture](DEVICE_ARCHITECTURE.md)**: Detailed device specifications and relationships
- **[Visual Diagram](assets/devices-diagram.svg)**: Complete infrastructure overview
- **Module documentation**: Inline documentation for custom Nix modules

## 🧰 Included Tools

### Command Line Utilities
| Tool | Purpose | Repository |
|------|---------|------------|
| `bat` | Enhanced cat with syntax highlighting | [sharkdp/bat](https://github.com/sharkdp/bat) |
| `dust` | Intuitive du replacement | [bootandy/dust](https://github.com/bootandy/dust) |
| `eza` | Modern ls replacement | [eza-community/eza](https://github.com/eza-community/eza) |
| `fd` | Simple, fast find alternative | [sharkdp/fd](https://github.com/sharkdp/fd) |
| `fzf` | Command-line fuzzy finder | [junegunn/fzf](https://github.com/junegunn/fzf) |
| `just` | Command runner | [casey/just](https://github.com/casey/just) |
| `ripgrep` | Fast text search | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) |
| `starship` | Cross-shell prompt | [starship/starship](https://github.com/starship/starship) |
| `zoxide` | Smarter cd command | [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide) |

### GUI Applications
- **Anyrun**: Application launcher for Hyprland
- **Hyprland**: Modern Wayland compositor
- **Ghostty**: GPU-accelerated terminal
- **Firefox**: Web browser with custom CSS
- **And many more...**

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Use configurations as inspiration
- Report issues or suggest improvements
- Fork for your own use (please respect licenses)

## 📄 License

This repository contains configurations and scripts for personal use. Individual tools and applications maintain their respective licenses.

---

**Infrastructure Status**: 7 devices managed • 20+ services hosted • Multi-platform deployment ready