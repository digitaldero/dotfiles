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

# --- Phase 1: System packages ---
echo "Installing packages..."
sudo apt update
sudo apt install -y eza kitty bat fd-find ripgrep fzf zoxide git-delta \
  starship mc openbox lxpanel lxpolkit dunst blueman feh pcmanfm scrot \
  network-manager-gnome pasystray pavucontrol copyq cbatticon gh \
  lxappearance fonts-dejavu fonts-dejavu-core fonts-open-sans vim-gtk3 xinit xorg \
  dmz-cursor-theme numix-gtk-theme papirus-icon-theme \
  pipewire pipewire-pulse wireplumber nodejs npm

echo "Removing snapd..."
sudo apt purge -y snapd 2>/dev/null || true
sudo apt autoremove -y

# --- Phase 2: PipeWire ---
echo "Enabling PipeWire..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true

# --- Phase 3: NVM ---
echo "Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
fi

# --- Phase 4: opencode ---
echo "Installing opencode..."
if ! command -v opencode &>/dev/null; then
  npm install -g @opencode-ai/plugin
fi

# --- Phase 5: Dotfiles symlinks ---
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

mkdir -p $HOME/.config/lxpanel/default/panels
ln -sf $HOME/dotfiles/config/lxpanel/panel $HOME/.config/lxpanel/default/panels/panel

mkdir -p $HOME/.config/fontconfig/conf.d
ln -sf $HOME/dotfiles/config/fontconfig/conf.d/51-nerd-font-symbols.conf \
  $HOME/.config/fontconfig/conf.d/

fc-cache -f -v

# --- Phase 6: Performance tuning ---
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
