#!/bin/bash
set -euo pipefail

# ============================================================
# install.sh — Ubuntu 26.04 Openbox Workstation Bootstrap
# Run after: git clone https://github.com/digitaldero/dotfiles.git
# Works for any username. Idempotent — safe to re-run.
# ============================================================

# --- Phase 0: Passwordless sudo ---
if ! sudo -n true 2>/dev/null; then
  echo "Setting up passwordless sudo..."
  sudo tee /etc/sudoers.d/$USER <<< "$USER ALL=(ALL) NOPASSWD:ALL"
  sudo chmod 440 /etc/sudoers.d/$USER
fi

# --- Phase 1: Laptop detection ---
IS_LAPTOP=""
echo ""
echo "Is this a laptop? (y/N): "
read -r IS_LAPTOP

# --- Phase 2: System packages ---
echo "Installing packages..."

# Common packages for both workstation and laptop
PACKAGES="eza kitty bat fd-find ripgrep fzf zoxide git-delta \
  starship mc openbox lxpanel lxpolkit dunst feh thunar scrot wsdd \
  network-manager-gnome pasystray pavucontrol copyq gh \
  lxappearance fonts-dejavu fonts-dejavu-core vim-gtk3 xinit xorg \
  dmz-cursor-theme numix-gtk-theme papirus-icon-theme \
  pipewire pipewire-pulse wireplumber nodejs npm \
  plocate libsecret-tools"

# Laptop-specific packages
case "$IS_LAPTOP" in
  y|Y) PACKAGES="$PACKAGES cbatticon" ;;
esac

sudo apt update
sudo apt install -y $PACKAGES

echo "Removing snapd..."
sudo apt purge -y snapd 2>/dev/null || true
# Remove power manager (cbatticon replaces it on laptop; unwanted on workstation)
sudo apt purge -y xfce4-power-manager 2>/dev/null || true
sudo apt autoremove -y

# --- Phase 3: PipeWire ---
echo "Enabling PipeWire..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true

# --- Phase 4: NVM ---
echo "Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
fi

# --- Phase 5: opencode ---
echo "Installing opencode..."
if ! command -v opencode &>/dev/null; then
  npm install -g @opencode-ai/plugin
fi

# --- Phase 6: Dotfiles symlinks ---
echo "Symlinking dotfiles..."
ln -sf $HOME/dotfiles/fonts $HOME/.fonts
ln -sf $HOME/dotfiles/themes $HOME/.themes
ln -sf $HOME/dotfiles/bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/gitconfig $HOME/.gitconfig
ln -sf $HOME/dotfiles/vimrc $HOME/.vimrc
ln -sf $HOME/dotfiles/vim $HOME/.vim
ln -sf $HOME/dotfiles/bin $HOME/bin
ln -sf $HOME/dotfiles/Xresources $HOME/.Xresources
cp -n $HOME/dotfiles/gtkrc-2.0 $HOME/.gtkrc-2.0 2>/dev/null || true

mkdir -p $HOME/.config/kitty
ln -sf $HOME/dotfiles/config/kitty/kitty.conf $HOME/.config/kitty/
ln -sf $HOME/dotfiles/config/kitty/kitty.app.png $HOME/.config/kitty/
ln -sf $HOME/dotfiles/config/kitty/current-theme.conf $HOME/.config/kitty/
ln -sf $HOME/dotfiles/config/starship/starship.toml $HOME/.config/starship.toml

mkdir -p $HOME/.config/openbox
ln -sf $HOME/dotfiles/autostart $HOME/.config/openbox/autostart
ln -sf $HOME/dotfiles/config/openbox/rc.xml $HOME/.config/openbox/rc.xml

mkdir -p $HOME/.config/gtk-3.0
ln -sf $HOME/dotfiles/config/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini

mkdir -p $HOME/.config/gtk-4.0
ln -sf $HOME/dotfiles/config/gtk-4.0/settings.ini $HOME/.config/gtk-4.0/settings.ini

# Override gsettings (takes priority over settings.ini files)
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true

mkdir -p $HOME/.config/lxpanel/default/panels
ln -sf $HOME/dotfiles/config/lxpanel/panel $HOME/.config/lxpanel/default/panels/panel

mkdir -p $HOME/.config/fontconfig/conf.d
ln -sf $HOME/dotfiles/config/fontconfig/conf.d/51-nerd-font-symbols.conf \
  $HOME/.config/fontconfig/conf.d/

fc-cache -f -v

# --- Phase 7: Keyring setup ---
echo "Configuring keyring..."
# Disable D-Bus activation (prevents gnome-keyring auto-start without password)
mkdir -p $HOME/.local/share/dbus-1/services/
cat > $HOME/.local/share/dbus-1/services/org.gnome.keyring.service << 'EOF'
[D-BUS Service]
Name=org.gnome.keyring
Exec=/bin/true
EOF
# Mask systemd user service (prevents socket-activated gnome-keyring)
systemctl --user mask gnome-keyring-daemon.socket 2>/dev/null || true
systemctl --user mask gnome-keyring-daemon.service 2>/dev/null || true
# Create keyring with empty password
echo "" | gnome-keyring-daemon --daemonize --login --components=secrets 2>/dev/null
gnome-keyring-daemon --start 2>/dev/null

# --- Phase 8: Network discovery ---
echo "Enabling WSDD for SMB network discovery..."
sudo cp $HOME/dotfiles/config/systemd/wsdd.service /etc/systemd/system/wsdd.service
sudo systemctl daemon-reload
sudo systemctl enable --now wsdd 2>/dev/null || true

# --- Phase 9: Performance tuning ---
echo "Tuning system..."
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf >/dev/null
if ! grep -q 'noatime' /etc/fstab; then
  sudo sed -i 's/\(defaults\)/\1,noatime/g' /etc/fstab
  echo "  Added noatime to fstab"
fi

# --- Done ---
echo ""
echo "=============================="
echo "  Setup complete!"
echo "  Reboot: sudo reboot"
echo "  Then:  openbox --reconfigure"
echo "         xrdb -merge ~/.Xresources"
echo "=============================="
