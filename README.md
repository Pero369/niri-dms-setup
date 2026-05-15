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

## Using in TTY (Command Line Interface)

If you're installing from a fresh Arch Linux TTY (black screen with white text), follow these steps:

### Step 1: Connect to Network

**For Wi-Fi:**
```bash
iwctl

# List devices
[iwd]# device list

# Scan for networks
[iwd]# station wlan0 scan

# Show available networks
[iwd]# station wlan0 get-networks

# Connect (replace Your_WiFi_Name)
[iwd]# station wlan0 connect Your_WiFi_Name
# Enter password when prompted (characters won't show)

# Exit iwctl
[iwd]# exit
```

**For Ethernet:** Just plug in the cable, it should work automatically.

**Test connection:**
```bash
ping -c 3 github.com
```

### Step 2: Download the Script

```bash
# Go to home directory
cd ~

# Download script
curl -O https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh
```

If `curl` is not found:
```bash
sudo pacman -Sy curl
```

If SSL error occurs:
```bash
curl -kO https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh
```

### Step 3: Run the Script

```bash
# Make executable
chmod +x install_niri.sh

# Run script
bash install_niri.sh
```

### Step 4: Select Installation Type

When the menu appears, press:
- **`a`** → Install **everything** (recommended for beginners)
- **`m`** → **Minimal** install (Niri + DMS only)
- **`1-7`** → Install specific components only

During DMS configuration, select:
- Window Manager: `niri`
- Terminal: `kitty`

### Step 5: Reboot

After installation completes:
```bash
sudo reboot
```

At the GDM login screen, select **"Niri"** from the session menu.

### Complete Copy-Paste Version

```bash
# 1. Connect Wi-Fi (skip if using Ethernet)
iwctl
station wlan0 connect Your_WiFi_Name
exit

# 2. Test network
ping -c 3 github.com

# 3. Download script
curl -O https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh

# 4. Run script
bash install_niri.sh

# 5. Press 'a' for full installation when prompted

# 6. Reboot when done
sudo reboot
```

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

## 在 TTY 中使用（命令行界面）

如果你是在 Arch Linux 的 TTY（黑底白字的命令行界面）中安装，请按以下步骤操作：

### 第 1 步：连接网络

**Wi-Fi 连接：**
```bash
iwctl

# 查看设备名
[iwd]# device list

# 扫描 Wi-Fi
[iwd]# station wlan0 scan

# 查看可用网络
[iwd]# station wlan0 get-networks

# 连接（替换 你的WiFi名称）
[iwd]# station wlan0 connect 你的WiFi名称
# 提示输入密码时输入密码（不显示字符）

# 退出 iwctl
[iwd]# exit
```

**网线连接：** 直接插入网线即可，通常自动连接。

**测试网络：**
```bash
ping -c 3 github.com
```
看到回复说明网络正常。

### 第 2 步：下载脚本

```bash
# 进入 home 目录
cd ~

# 下载脚本
curl -O https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh
```

如果提示 curl 未找到：
```bash
sudo pacman -Sy curl
```

如果提示 SSL 错误：
```bash
curl -kO https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh
```

### 第 3 步：运行脚本

```bash
# 赋予执行权限
chmod +x install_niri.sh

# 运行脚本
bash install_niri.sh
```

### 第 4 步：选择安装类型

显示菜单后输入：
- **`a`** → 安装**全部**（推荐新手使用）
- **`m`** → **最小**安装（仅 Niri + DMS）
- **`1-7`** → 单独安装某个功能

DMS 配置时选择：
- Window Manager: `niri`
- Terminal: `kitty`

### 第 5 步：重启

安装完成后：
```bash
sudo reboot
```

在 GDM 登录界面选择 **"Niri"** 会话。

### 完整流程（复制粘贴版）

```bash
# 1. 连 Wi-Fi（如已插网线可跳过）
iwctl
station wlan0 connect WiFi名称
exit

# 2. 测试网络
ping -c 3 github.com

# 3. 下载脚本
curl -O https://raw.githubusercontent.com/Pero369/niri-dms-setup/main/install_niri.sh

# 4. 运行脚本
bash install_niri.sh

# 5. 按提示选 'a' 安装全部

# 6. 重启
sudo reboot
```

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
