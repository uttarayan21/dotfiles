# Device Architecture Overview

This document provides a comprehensive overview of all devices managed by this NixOS/nix-darwin dotfiles repository.

> **Visual Diagram**: See [assets/devices-diagram.svg](assets/devices-diagram.svg) for a visual representation of this architecture.

## Device Categories

### 🖥️ Server Infrastructure (Headless)

#### mirai (Main Server)
- **Architecture**: x86_64-linux
- **User**: fs0c131y
- **Role**: Primary server hosting various services
- **Configuration**: NixOS + Home Manager
- **Hardware**: AMD CPU with NVME storage
- **Location**: Local network
- **Services**:
  - Nextcloud (file storage and sync)
  - Gitea (Git hosting)
  - Grafana (monitoring and dashboards)
  - Minecraft server
  - Immich (photo management)
  - Paperless (document management)
  - Tailscale VPN node
  - ZeroTier network node
  - Atuin (shell history sync)
  - LLDAP (LDAP server)
  - Navidrome (music streaming)
  - Searxng (search engine)
  - Syncthing
  - And many more services

#### deoxys (VM Server)
- **Architecture**: x86_64-linux
- **User**: servius
- **Role**: Virtual machine server for testing and isolation
- **Configuration**: NixOS + Home Manager
- **Location**: Local network

#### tsuba (Raspberry Pi)
- **Architecture**: aarch64-linux
- **User**: servius
- **Role**: ARM-based server for lightweight services
- **Configuration**: NixOS + Home Manager (using stable channel)
- **Hardware**: Raspberry Pi
- **Access**: External via tsuba.darksailor.dev
- **Special**: Uses nixos-raspberrypi input for hardware support

### 💻 Development Workstations

#### ryu (Main Desktop)
- **Architecture**: x86_64-linux
- **User**: servius
- **Role**: Primary development workstation
- **Configuration**: NixOS + Home Manager
- **Desktop Environment**: Hyprland (primary) + GNOME (fallback)
- **Features**:
  - Multi-monitor setup:
    - Primary: HDMI-A-1 (Gigabyte FO27Q3)
    - Secondary: DP-3 (Acer XV272U)
    - Tertiary: DP-1 (Gigabyte M27Q)
  - Audio production setup (musnix)
  - Gaming support (Wine, Steam)
  - Virtualization (virt-manager)
  - Hardware acceleration (CUDA support)
  - Secure boot with Lanzaboote
  - TPM2 support

#### shiro (Mac Mini)
- **Architecture**: aarch64-darwin (Apple Silicon)
- **User**: servius
- **Role**: macOS desktop and build server
- **Configuration**: nix-darwin + Home Manager
- **Features**:
  - ARM64 build server for distributed builds
  - Samba file sharing
  - Colima container runtime
  - Aerospace window management

### 📱 Portable/Mobile Devices

#### kuro (MacBook)
- **Architecture**: aarch64-darwin (Apple Silicon)
- **User**: fs0c131y
- **Role**: macOS development machine
- **Configuration**: nix-darwin + Home Manager
- **Features**:
  - Touch ID for sudo authentication
  - Custom keyboard mappings
  - Homebrew integration

#### SteamDeck (Gaming Handheld)
- **Architecture**: x86_64-linux
- **User**: deck
- **Role**: Portable gaming device
- **Configuration**: Home Manager only (no NixOS)
- **Special**: Uses SteamOS with Home Manager overlay

## Network Architecture

### VPN Networks
- **Tailscale**: Primary VPN connecting most devices
  - Devices: mirai, deoxys, tsuba, deck
- **ZeroTier**: Secondary network layer
  - Devices: mirai, ryu

### Local Network
- **Primary connection**: ryu (main desktop)
- **Wake-on-LAN**: Enabled for ryu (eno1 interface)

## Configuration Management

### NixOS Flake
- **Manages**: mirai, deoxys, tsuba, ryu
- **Features**: Unified configuration across Linux devices
- **Inputs**: Multiple flake inputs for extended functionality

### nix-darwin
- **Manages**: kuro, shiro
- **Features**: macOS system configuration

### Home Manager
- **Standalone**: deck (SteamDeck)
- **Integrated**: All other devices
- **Stable channel**: Used for tsuba

## Build Infrastructure

### Distributed Building
- **Build machines**: 
  - mirai (primary build server)
  - shiro (macOS builds)
  - tsuba (ARM builds, commented out)
- **Consumers**: 
  - ryu (uses remote builders)
  - kuro (uses remote builders)

### Cache Strategy
- **Substituters**:
  - nix-community.cachix.org
  - nixos-raspberrypi.cachix.org (for ARM builds)
- **Build optimization**: Auto-optimise-store enabled

## Deployment Strategy

### SSH-based Deployment
Using deploy-rs for automated deployments:

```
ryu → mirai, deoxys, tsuba, deck
kuro → mirai, shiro
```

### Special Access
- **tsuba**: Accessed via external domain (tsuba.darksailor.dev)
- **All servers**: SSH key authentication with authorized_keys

## Hardware-Specific Features

### ryu (Desktop)
- **Graphics**: NVIDIA with CUDA support
- **Audio**: Professional audio setup with musnix
- **Input devices**: QMK keyboard support
- **Monitors**: DDC/CI control with ddcutil
- **Security**: TPM2, secure boot (Lanzaboote)

### mirai (Server)
- **CPU**: AMD with virtualization support
- **Storage**: Custom disk layout with disko
- **Containers**: Docker with custom mount points
- **Emulation**: aarch64-linux binfmt support

### macOS Devices (kuro - MacBook, shiro - Mac Mini)
- **Authentication**: Touch ID integration (kuro)
- **Keyboard**: Custom modifier key mappings
- **Package management**: Homebrew + Nix hybrid approach
- **Build server**: shiro provides ARM64 builds for the network

## Security Features

- **SOPS**: Secrets management across all devices
- **SSH keys**: Centralized key management
- **Fail2ban**: Enabled on mirai
- **Secure boot**: Implemented on ryu
- **TPM**: Hardware security on ryu

## Development Environment

### Shared Tools
- **Editor**: Nixvim (custom Neovim configuration)
- **Shell**: Fish + Nushell support
- **Terminal**: Various per-device preferences
- **Version control**: Git with shared configuration

### Language Support
- **Rust**: Custom overlay with latest toolchain
- **Python**: Python 3 with development tools
- **Nix**: Latest Nix with flakes enabled
- **Web**: Node.js and web development tools

## Monitoring and Observability

- **Grafana**: Centralized monitoring on mirai
- **System metrics**: Collected across all NixOS devices
- **Shell history**: Synchronized via Atuin
- **File synchronization**: Syncthing for selective sync

## Backup and Data Management

- **Nextcloud**: Primary cloud storage on mirai
- **Syncthing**: Decentralized file sync
- **Git repositories**: Self-hosted on Gitea (mirai)
- **Photos**: Immich for photo management
- **Documents**: Paperless for document archival

This architecture provides a robust, scalable, and maintainable infrastructure for development, gaming, media consumption, and server hosting across multiple platforms and architectures.