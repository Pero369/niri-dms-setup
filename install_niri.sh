#!/bin/bash

# ============================================================================
# Arch Linux Niri + DMS One-Click Installation Script (Complete Edition)
# Features: Auto-configure ArchLinuxCN mirror, install Niri WM, GDM, DMS,
#           system snapshots, Chinese input method, Zsh customization, common apps
# For: Arch Linux / Manjaro and other Arch-based distros
# Usage: bash install_niri.sh
# Note: Run in TTY (non-graphical terminal) - all output is in English
# ============================================================================

set -e  # Exit immediately if a command exits with a non-zero status

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_section() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
}

# Check if running as root (not recommended)
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "Please do NOT run this script as root!"
        print_info "Run as a normal user. The script will use sudo when needed."
        exit 1
    fi
}

# Check if Arch-based distro
check_arch() {
    if ! command -v pacman &> /dev/null; then
        print_error "pacman not found. This script is for Arch Linux only."
        exit 1
    fi
    print_success "Arch-based distribution detected"
}

# Check network connection
check_network() {
    print_info "Checking network connection..."
    if ! ping -c 1 -W 3 archlinux.org &> /dev/null; then
        print_warn "Cannot connect to Arch Linux servers"
        print_info "If you need to connect Wi-Fi, run:"
        echo "    iwctl"
        echo "    [iwd]# station wlan0 connect <WiFi_SSID>"
        read -p "Network connected? (y/N): " confirm
        if [[ $confirm != [yY] ]]; then
            print_error "Please connect to network first"
            exit 1
        fi
    else
        print_success "Network connection OK"
    fi
}

# Update system keyring
update_system() {
    print_info "Updating system keyring..."
    sudo pacman -Sy --noconfirm archlinux-keyring
    print_success "Keyring updated"
}

# Install base tools
install_base_tools() {
    print_info "Installing base tools (vim, git)..."
    sudo pacman -S --noconfirm --needed vim git
    print_success "Base tools installed"
}

# Configure ArchLinuxCN mirror
setup_archlinuxcn() {
    print_info "Configuring ArchLinuxCN repository..."
    
    # Check if already configured
    if grep -q "^\[archlinuxcn\]" /etc/pacman.conf; then
        print_warn "ArchLinuxCN repo already configured, skipping"
        return
    fi
    
    # Add CN repo
    sudo tee -a /etc/pacman.conf > /dev/null << 'EOF'

[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
Server = https://mirrors.hit.edu.cn/archlinuxcn/$arch
Server = https://repo.huaweicloud.com/archlinuxcn/$arch
EOF
    
    print_success "ArchLinuxCN repo configured"
}

# Import keys and install keyring
import_keys() {
    print_info "Importing ArchLinuxCN keys..."
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman-key --lsign-key "farseerfc@archlinux.org" 2>/dev/null || true
    
    print_info "Installing ArchLinuxCN keyring..."
    sudo pacman -Sy --noconfirm archlinuxcn-keyring
    print_success "Keys imported"
}

# Install yay AUR helper
install_yay() {
    print_info "Installing yay AUR helper..."
    
    if command -v yay &> /dev/null; then
        print_warn "yay already installed, skipping"
        return
    fi
    
    sudo pacman -S --noconfirm --needed yay
    print_success "yay installed"
}

# Install Niri core components
install_niri() {
    print_section "Installing Niri Window Manager"
    
    sudo pacman -S --noconfirm --needed \
        niri \
        xwayland-satellite \
        xdg-desktop-portal-gnome \
        kitty \
        polkit-gnome
    
    print_success "Niri core components installed"
}

# Install GDM display manager
install_gdm() {
    print_info "Installing GDM display manager..."
    
    sudo pacman -S --noconfirm --needed gdm
    
    print_info "Enabling GDM service..."
    sudo systemctl enable gdm
    
    print_success "GDM installed and enabled"
}

# Install DMS (Desktop Management System)
install_dms() {
    print_info "Installing DMS (Desktop Management System)..."
    print_info "This may take some time, please wait..."
    
    if ! command -v dms &> /dev/null; then
        yay -S --noconfirm dms || {
            print_warn "DMS installation may have issues, trying manual install..."
            yay -S dms
        }
    else
        print_warn "DMS already installed, skipping"
    fi
    
    print_success "DMS installed"
}

# Run DMS configuration wizard
run_dms() {
    print_info "============================================"
    print_info "DMS configuration wizard will now run"
    print_info "When prompted, select:"
    print_info "  - Window Manager: niri"
    print_info "  - Terminal: kitty"
    print_info "============================================"
    echo ""
    read -p "Press Enter to continue, or type 'skip' to skip DMS: " choice
    
    if [[ "$choice" != "skip" ]]; then
        dms
        print_success "DMS configuration complete"
    else
        print_warn "Skipped DMS. Run 'dms' manually later"
    fi
}

# Install recommended addons
install_recommended() {
    print_info "Installing recommended addons (cava, wlsunset)..."
    
    sudo pacman -S --noconfirm --needed cava wlsunset 2>/dev/null || {
        print_warn "Some addons failed to install, you can install manually later"
    }
    
    print_success "Addons installed"
}

# ============================================================================
# Additional features from Article 1
# ============================================================================

# Configure Chinese locale
setup_locale() {
    print_section "Configuring Chinese Locale Support"
    
    print_info "Enabling Chinese locale..."
    
    # Check if already enabled
    if grep -q "^zh_CN.UTF-8 UTF-8" /etc/locale.gen; then
        print_warn "Chinese locale already enabled"
    else
        # Uncomment zh_CN.UTF-8
        sudo sed -i 's/^#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
        sudo locale-gen
        print_success "Chinese locale configured"
    fi
}

# Install Chinese input method
install_chinese_input() {
    print_section "Installing Chinese Input Method (Fcitx5 + Rime)"
    
    print_info "Installing Fcitx5 and Rime dictionary..."
    sudo pacman -S --noconfirm --needed fcitx5-im fcitx5-rime fcitx5-mozc rime-ice-pinyin-git
    
    print_info "Configuring input method environment variables..."
    
    # Check if already configured
    if ! grep -q "XMODIFIERS=@im=fcitx" /etc/environment 2>/dev/null; then
        echo 'XMODIFIERS=@im=fcitx' | sudo tee -a /etc/environment > /dev/null
    fi
    
    # Create Rime config
    mkdir -p ~/.local/share/fcitx5/rime
    
    if [[ ! -f ~/.local/share/fcitx5/rime/default.custom.yaml ]]; then
        cat > ~/.local/share/fcitx5/rime/default.custom.yaml << 'EOF'
patch:
  __include: rime_ice_suggestion:/
EOF
        print_success "Rime config created"
    fi
    
    print_info "Input method notes:"
    print_info "  1. Add to Niri config: spawn-at-startup \"fcitx5\" \"-d\""
    print_info "  2. Use Ctrl+Space to switch input method after reboot"
    
    print_success "Chinese input method installed"
}

# Install and configure Zsh + Starship
install_zsh() {
    print_section "Installing Zsh + Starship Terminal Customization"
    
    print_info "Installing Zsh and plugins..."
    sudo pacman -S --noconfirm --needed \
        zsh \
        zsh-syntax-highlighting \
        zsh-autosuggestions \
        zsh-completions
    
    print_info "Installing Nerd Font..."
    sudo pacman -S --noconfirm --needed ttf-jetbrains-mono-nerd
    
    print_info "Installing Starship prompt..."
    sudo pacman -S --noconfirm --needed starship
    
    # Configure Zsh
    if [[ ! -f ~/.zshrc ]]; then
        print_info "Creating default Zsh config..."
        touch ~/.zshrc
    fi
    
    # Add Starship init (if not exists)
    if ! grep -q "eval \"\$(starship init zsh)\"" ~/.zshrc; then
        echo '' >> ~/.zshrc
        echo '# Starship prompt' >> ~/.zshrc
        echo 'eval "$(starship init zsh)"' >> ~/.zshrc
    fi
    
    # Add Zsh plugins (if not exists)
    if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
        echo '' >> ~/.zshrc
        echo '# Zsh plugins' >> ~/.zshrc
        echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc
        echo 'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
    fi
    
    # Ask to switch default shell
    echo ""
    read -p "Switch default shell to Zsh? (y/N): " switch_zsh
    if [[ $switch_zsh == [yY] ]]; then
        chsh -s /usr/bin/zsh
        print_success "Default shell switched to Zsh (effective after next login)"
    fi
    
    print_success "Zsh + Starship configured"
}

# Configure Kitty terminal
setup_kitty() {
    print_section "Configuring Kitty Terminal"
    
    mkdir -p ~/.config/kitty/themes
    
    # Create Kitty config
    cat > ~/.config/kitty/kitty.conf << 'EOF'
# Kitty terminal configuration

# Window padding
window_padding_width 5

# Hide window decorations (minimalist)
hide_window_decorations yes

# Background opacity (0.8 = 80% opaque)
background_opacity 0.8

# Font settings
font_family JetBrainsMono Nerd Font
font_size 13

# Scrollback
scrollback_lines 10000

# Mouse support
mouse_hide_wait 3.0
EOF
    
    print_success "Kitty configured"
    print_info "Config location: ~/.config/kitty/kitty.conf"
}

# Install common applications
install_common_apps() {
    print_section "Installing Common Applications"
    
    print_info "Installing utilities..."
    
    # Base tools
    sudo pacman -S --noconfirm --needed \
        yazi \
        btop \
        imv \
        udiskie \
        udisks2 \
        gvfs \
        flatseal \
        2>/dev/null || print_warn "Some packages failed to install"
    
    print_success "Utilities installed"
    
    # Ask to install gaming platforms
    echo ""
    read -p "Install Steam and Lutris gaming platforms? (y/N): " install_games
    if [[ $install_games == [yY] ]]; then
        print_info "Installing Steam and Lutris..."
        sudo pacman -S --noconfirm --needed steam lutris 2>/dev/null || {
            print_warn "Steam/Lutris installation failed, may need manual install"
        }
        
        # Steam Btrfs optimization
        print_info "Configuring Steam Btrfs optimization (disable CoW)..."
        mkdir -p ~/.local/share/Steam/steamapps
        chattr +C ~/.local/share/Steam/steamapps 2>/dev/null || {
            print_warn "Cannot set Steam dir attributes, may need root or different filesystem"
        }
        print_success "Steam configured"
    fi
}

# Configure Snapper system snapshots
setup_snapper() {
    print_section "Configuring Snapper System Snapshots"
    
    print_info "Installing Snapper and related tools..."
    sudo pacman -S --noconfirm --needed \
        snapper \
        snap-pac \
        btrfs-assistant \
        grub-btrfs \
        inotify-tools
    
    print_info "Enabling grub-btrfsd service..."
    sudo systemctl enable --now grub-btrfsd
    
    print_info "Configuring OverlayFS..."
    
    # Check if already configured
    if ! grep -q "grub-btrfs-overlayfs" /etc/mkinitcpio.conf; then
        # Add grub-btrfs-overlayfs to HOOKS
        sudo sed -i 's/\(HOOKS=(.*\))$/\1 grub-btrfs-overlayfs)/' /etc/mkinitcpio.conf
        print_success "OverlayFS added to mkinitcpio.conf"
        
        print_info "Regenerating kernel images..."
        sudo mkinitcpio -P
    else
        print_warn "OverlayFS already configured, skipping"
    fi
    
    print_info "Updating GRUB config..."
    sudo grub-mkconfig -o /efi/grub/grub.cfg 2>/dev/null || {
        print_warn "GRUB update failed, you may need to run manually: sudo grub-mkconfig -o /boot/grub/grub.cfg"
    }
    
    print_success "Snapper base configuration complete"
    print_info "Tip: Use 'btrfs-assistant' (GUI) or 'snapper' (CLI) to create snapshot policies"
    print_info "      Snapshot menu will automatically appear in GRUB boot menu"
}

# GRUB optimization
optimize_grub() {
    print_section "Optimizing GRUB Bootloader"
    
    local grub_file="/etc/default/grub"
    
    print_info "Backing up original GRUB config..."
    sudo cp $grub_file ${grub_file}.bak.$(date +%Y%m%d)
    
    print_info "Applying GRUB optimizations..."
    
    # Enable OS_PROBER (dual-boot detection)
    sudo sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' $grub_file
    
    # Enable boot entry memory
    sudo sed -i 's/^GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' $grub_file
    sudo sed -i 's/^#GRUB_SAVEDEFAULT=true/GRUB_SAVEDEFAULT=true/' $grub_file
    
    # Remove quiet to show boot logs
    sudo sed -i 's/quiet//' $grub_file
    
    # Add loglevel=5 (if not exists)
    if ! grep -q "loglevel=5" $grub_file; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 loglevel=5"/' $grub_file
    fi
    
    # Ask to disable Watchdog
    read -p "Disable Watchdog to speed up boot/shutdown? (y/N): " disable_watchdog
    if [[ $disable_watchdog == [yY] ]]; then
        # Detect CPU type
        local cpu_vendor=$(grep -m1 "vendor_id" /proc/cpuinfo | awk '{print $3}')
        if [[ "$cpu_vendor" == "AuthenticAMD" ]]; then
            local watchdog_param="nowatchdog modprobe.blacklist=sp5100_tco"
        else
            local watchdog_param="nowatchdog modprobe.blacklist=iTCO_wdt"
        fi
        
        if ! grep -q "nowatchdog" $grub_file; then
            sudo sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=\"\([^\"]*\)\"|GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $watchdog_param\"|" $grub_file
            print_success "Watchdog disabled ($cpu_vendor)"
        fi
    fi
    
    print_info "Updating GRUB config..."
    if [[ -d "/efi/grub" ]]; then
        sudo grub-mkconfig -o /efi/grub/grub.cfg
        # Create compatibility link
        sudo mkdir -p /boot/grub
        sudo ln -sf /efi/grub/grub.cfg /boot/grub/grub.cfg 2>/dev/null || true
    else
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
    
    print_success "GRUB optimized"
    print_info "Optimizations applied:"
    print_info "  - Enabled OS_PROBER (dual-boot detection)"
    print_info "  - Enabled boot entry memory"
    print_info "  - Show boot logs (removed quiet)"
}

# Show installation menu
show_menu() {
    echo ""
    echo "============================================"
    echo -e "${CYAN}  Arch Linux Niri Installation Menu${NC}"
    echo "============================================"
    echo ""
    echo "Basic Installation (Required):"
    echo "  1) Niri Window Manager + GDM + DMS"
    echo ""
    echo "Extended Features (Optional):"
    echo "  2) Chinese locale and input method (Fcitx5 + Rime)"
    echo "  3) Zsh + Starship terminal customization"
    echo "  4) Kitty terminal configuration"
    echo "  5) Common apps (yazi, btop, imv, Steam, etc.)"
    echo "  6) Snapper system snapshots"
    echo "  7) GRUB bootloader optimization"
    echo ""
    echo "Quick Options:"
    echo "  a) Install All (Recommended)"
    echo "  m) Minimal Install (Basic only)"
    echo "  q) Quit"
    echo ""
}

# Verify installation
verify_installation() {
    print_section "Verifying Installation"
    
    local errors=0
    
    for cmd in niri kitty gdm yay; do
        if command -v $cmd &> /dev/null; then
            print_success "$cmd installed"
        else
            print_error "$cmd not found"
            ((errors++))
        fi
    done
    
    if [[ -f "/usr/share/wayland-sessions/niri.desktop" ]]; then
        print_success "niri.desktop session file exists"
    else
        print_warn "niri.desktop not found"
    fi
    
    if [[ $errors -eq 0 ]]; then
        print_success "Core components verification passed!"
    fi
}

# Show post-installation instructions
show_post_install() {
    echo ""
    echo "============================================"
    echo -e "${GREEN}       Installation Complete!${NC}"
    echo "============================================"
    echo ""
    echo "[Start System]"
    echo "  sudo reboot"
    echo "  Select 'Niri' session at GDM login screen"
    echo ""
    echo "[Common Shortcuts]"
    echo "  Win + T           : Open terminal (Kitty)"
    echo "  Win + Arrow Keys  : Switch windows/workspaces"
    echo "  Win + Shift + E   : Exit Niri"
    echo "  Ctrl + Space      : Toggle input method (if installed)"
    echo ""
    echo "[Important Config Files]"
    echo "  Niri:  ~/.config/niri/config.kdl"
    echo "  Kitty: ~/.config/kitty/kitty.conf"
    echo "  Zsh:   ~/.zshrc"
    echo ""
    echo "[Useful Commands]"
    echo "  dms              : Re-run DMS configuration"
    echo "  btrfs-assistant  : GUI snapshot management"
    echo "  snapper list     : View system snapshots"
    echo "  flatpak uninstall --unused  : Clean Flatpak"
    echo "  yay -Sc          : Clean AUR cache"
    echo ""
    echo "[Troubleshooting]"
    echo "  1. If Niri won't start, check: ls /usr/share/wayland-sessions/"
    echo "  2. If DMS config lost, run: dms"
    echo "  3. If input method not working, check: cat /etc/environment"
    echo ""
    echo "============================================"
}

# Main function
main() {
    print_section "Arch Linux Niri Installation Script"
    
    # Pre-checks
    check_root
    check_arch
    check_network
    
    # Show menu loop
    while true; do
        show_menu
        read -p "Select option: " choice
        
        case $choice in
            1)
                update_system
                install_base_tools
                setup_archlinuxcn
                import_keys
                install_yay
                install_niri
                install_gdm
                install_dms
                run_dms
                install_recommended
                verify_installation
                show_post_install
                ;;
            2)
                setup_locale
                install_chinese_input
                ;;
            3)
                install_zsh
                ;;
            4)
                setup_kitty
                ;;
            5)
                install_common_apps
                ;;
            6)
                setup_snapper
                ;;
            7)
                optimize_grub
                ;;
            a|A)
                print_section "Starting Full Installation (All Components)"
                
                # Basic
                update_system
                install_base_tools
                setup_archlinuxcn
                import_keys
                install_yay
                install_niri
                install_gdm
                install_dms
                run_dms
                install_recommended
                
                # Extended
                setup_locale
                install_chinese_input
                install_zsh
                setup_kitty
                install_common_apps
                setup_snapper
                optimize_grub
                
                verify_installation
                show_post_install
                break
                ;;
            m|M)
                print_section "Starting Minimal Installation"
                update_system
                install_base_tools
                setup_archlinuxcn
                import_keys
                install_yay
                install_niri
                install_gdm
                install_dms
                run_dms
                verify_installation
                show_post_install
                break
                ;;
            q|Q)
                print_info "Exited"
                exit 0
                ;;
            *)
                print_error "Invalid option"
                ;;
        esac
    done
}

# Run main function
main "$@"
