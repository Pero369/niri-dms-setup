# Arch Linux Niri + DMS Setup Script

A one-click installation script for setting up **Niri** (a scrollable-tiling Wayland window manager) with **DMS** (Desktop Management System) on Arch Linux.

English | [中文](#中文说明)

---

## Features

- **One-click setup**: Automates the entire Niri installation process
- **ArchLinuxCN mirror**: Configures China-specific repositories for faster downloads
- **DMS integration**: Auto-configures dotfiles and common software
- **Full Chinese support**: Includes Fcitx5 + Rime input method (optional)
- **Terminal customization**: Zsh + Starship + Kitty configuration
- **System snapshots**: Snapper + Btrfs rollback support
- **GRUB optimization**: Dual-boot detection, boot entry memory

## Quick Start

### Prerequisites

- Arch Linux / Manjaro / ArcoLinux (or any Arch-based distro)
- Network connection (Wi-Fi or Ethernet)
- Root privileges (via `sudo`)

### Installation

Connect to Wi-Fi if needed:
```bash
iwctl
[iwd]# station wlan0 connect Your_WiFi_Name
[iwd]# exit
```

Download and run the script:
```bash
curl -O https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh
chmod +x install_niri.sh
bash install_niri.sh
```

Follow the menu:
- Press `a` for **Full Installation** (recommended)
- Press `m` for **Minimal Installation** (Niri + DMS only)
- Press `1-7` for specific components

After installation:
```bash
sudo reboot
```

Select "Niri" at the GDM login screen.

---

## What Gets Installed

### Core Components (Always)
| Package | Description |
|---------|-------------|
| `niri` | Window manager |
| `gdm` | Display/login manager |
| `kitty` | GPU-accelerated terminal |
| `dms` | Desktop Management System (auto-config) |
| `yay` | AUR helper |

### Optional Components
| Category | Packages |
|----------|----------|
| **Chinese Input** | fcitx5-im, fcitx5-rime, rime-ice-pinyin-git |
| **Shell** | zsh, zsh-syntax-highlighting, zsh-autosuggestions, starship |
| **Apps** | yazi, btop, imv, udiskie, steam, lutris |
| **System** | snapper, btrfs-assistant, grub-btrfs |

---

## Usage After Installation

### Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| `Win + T` | Open terminal (Kitty) |
| `Win + Arrow Keys` | Navigate windows |
| `Win + Shift + E` | Exit Niri |
| `Ctrl + Space` | Toggle input method |

### Useful Commands
```bash
dms              # Re-run DMS configuration
btrfs-assistant  # GUI snapshot manager
snapper list     # View snapshots
yay -Sc          # Clean AUR cache
```

---

## Troubleshooting

### Cannot download script (SSL error)
```bash
curl -kO https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh
```

### No Wi-Fi in TTY
```bash
# Use iwctl
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "Your_SSID"
```

### DMS not found after installation
```bash
# Re-run manually
yay -S dms
dms
```

### Niri not showing in GDM
```bash
ls /usr/share/wayland-sessions/
# Should show niri.desktop
```

---

## Script Structure

```
install_niri.sh
├── Pre-checks (root, distro, network)
├── Core Installation
│   ├── ArchLinuxCN repo setup
│   ├── Niri + GDM installation
│   └── DMS configuration
└── Optional Components
    ├── Chinese locale & input
    ├── Zsh + Starship
    ├── Common applications
    ├── Snapper snapshots
    └── GRUB optimization
```

---

## License

MIT License - Feel free to use, modify, and distribute.

---

## Credits

- [Niri](https://github.com/YaLTeR/niri) - Scrollable-tiling Wayland compositor
- [DMS](https://github.com/ozwaldorf/dms) - Desktop Management System
- [Arch Linux](https://archlinux.org/) - The best Linux distro ❤️

---

# 中文说明

Arch Linux Niri + DMS 一键安装脚本

## 功能特点

- **一键安装**：自动配置完整的 Niri 桌面环境
- **ArchLinuxCN 镜像**：使用国内源加速下载
- **DMS 自动配置**：省去手动配置 config.kdl 的麻烦
- **中文支持**：可选安装 Fcitx5 + 雾凇拼音输入法
- **终端美化**：Zsh + Starship + Kitty 配置
- **系统快照**：Snapper + Btrfs 回滚支持
- **GRUB 优化**：双系统探测、启动项记忆

## 快速开始

### 前提条件

- Arch Linux / Manjaro / ArcoLinux（或其他 Arch 系发行版）
- 网络连接（Wi-Fi 或网线）
- sudo 权限

### 安装步骤

连接 Wi-Fi（如需要）：
```bash
iwctl
[iwd]# station wlan0 connect 你的WiFi名称
[iwd]# exit
```

下载并运行脚本：
```bash
curl -O https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh
chmod +x install_niri.sh
bash install_niri.sh
```

按菜单提示选择：
- 按 `a` = **完整安装**（推荐）
- 按 `m` = **最小安装**（仅 Niri + DMS）
- 按 `1-7` = 单独安装某个组件

安装完成后重启：
```bash
sudo reboot
```

在 GDM 登录界面选择 "Niri" 会话。

---

## 安装内容

### 核心组件（必装）
| 软件 | 说明 |
|------|------|
| `niri` | 窗口管理器 |
| `gdm` | 登录管理器 |
| `kitty` | GPU 加速终端 |
| `dms` | 桌面管理系统（自动配置） |
| `yay` | AUR 助手 |

### 可选组件
| 类别 | 软件包 |
|------|--------|
| **中文输入法** | fcitx5-im, fcitx5-rime, rime-ice-pinyin-git |
| **Shell 美化** | zsh, zsh-syntax-highlighting, zsh-autosuggestions, starship |
| **常用软件** | yazi, btop, imv, udiskie, steam, lutris |
| **系统快照** | snapper, btrfs-assistant, grub-btrfs |

---

## 安装后使用

### 常用快捷键
| 快捷键 | 功能 |
|--------|------|
| `Win + T` | 打开终端 (Kitty) |
| `Win + 方向键` | 切换窗口/工作区 |
| `Win + Shift + E` | 退出 Niri |
| `Ctrl + Space` | 切换输入法 |

### 实用命令
```bash
dms              # 重新运行 DMS 配置
btrfs-assistant  # 图形化快照管理
snapper list     # 查看系统快照
yay -Sc          # 清理 AUR 缓存
```

---

## 常见问题

### 下载脚本失败（SSL 错误）
```bash
curl -kO https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh
```

### TTY 中无法连接 Wi-Fi
```bash
# 使用 iwctl
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "WiFi名称"
```

### 安装后找不到 DMS
```bash
# 手动安装
yay -S dms
dms
```

### GDM 中没有 Niri 选项
```bash
ls /usr/share/wayland-sessions/
# 应该显示 niri.desktop
```

---

## 致谢

- [Niri](https://github.com/YaLTeR/niri) - 无限滚动平铺式窗口管理器
- [DMS](https://github.com/ozwaldorf/dms) - 桌面管理系统
- [Arch Linux](https://archlinux.org/) - 最好的 Linux 发行版 ❤️
