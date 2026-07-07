# Ubuntu 26.04 Openbox Workstation Setup

Repeatable setup guide for a minimal, fast Openbox dev environment.
Works for any username — no hardcoded paths.

## Quick install (recommended)

```bash
git clone https://github.com/digitaldero/dotfiles.git
cd dotfiles
./install.sh
sudo reboot
```

That's it. The script handles everything: packages, dotfiles, PipeWire,
NVM, opencode, performance tuning.

## Manual breakdown

If you want to run steps individually instead of using `install.sh`:

### Prerequisites

- Ubuntu 26.04 LTS Server installed (minimal)
- `sudo` access
- Dotfiles repo cloned at `$HOME/dotfiles/`

### 0. Passwordless sudo

```bash
sudo tee /etc/sudoers.d/$USER <<< "$USER ALL=(ALL) NOPASSWD:ALL"
sudo chmod 440 /etc/sudoers.d/$USER
```

### 1. System packages

```bash
sudo apt update
sudo apt install -y eza kitty bat fd-find ripgrep fzf zoxide git-delta \
  starship mc openbox lxpanel lxpolkit dunst blueman feh pcmanfm scrot \
  network-manager-gnome pasystray pavucontrol copyq cbatticon gh \
  lxappearance fonts-dejavu fonts-dejavu-core fonts-open-sans vim-gtk3 xinit xorg \
  dmz-cursor-theme numix-gtk-theme papirus-icon-theme gh \
  pipewire pipewire-pulse wireplumber nodejs npm
sudo apt purge -y snapd
sudo apt autoremove -y
```

### 2. PipeWire

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### 3. NVM

```bash
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

### 4. opencode

```bash
npm install -g @opencode-ai/plugin
```

### 5. Dotfiles symlinking

```bash
ln -sf $HOME/dotfiles/fonts $HOME/.fonts
ln -sf $HOME/dotfiles/themes $HOME/.themes
ln -sf $HOME/dotfiles/bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/gitconfig $HOME/.gitconfig
ln -sf $HOME/dotfiles/vimrc $HOME/.vimrc
ln -sf $HOME/dotfiles/vim $HOME/.vim
ln -sf $HOME/dotfiles/bin $HOME/bin
ln -sf $HOME/dotfiles/Xresources $HOME/.Xresources
cp -n $HOME/dotfiles/gtkrc-2.0 $HOME/.gtkrc-2.0

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
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

mkdir -p $HOME/.config/lxpanel/default/panels
ln -sf $HOME/dotfiles/config/lxpanel/panel $HOME/.config/lxpanel/default/panels/panel

mkdir -p $HOME/.config/fontconfig/conf.d
ln -sf $HOME/dotfiles/config/fontconfig/conf.d/51-nerd-font-symbols.conf \
  $HOME/.config/fontconfig/conf.d/
fc-cache -f -v
```

### 6. GTK/theme configuration

These settings are applied by `install.sh` via `config/gtk-3.0/settings.ini`
and `config/openbox/rc.xml`. If running manually:

```bash
# GTK theme, icons, font, cursor
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark

# Openbox theme: Numix (window decorations) + Adwaita-dark (GTK widgets)
# Configured in rc.xml <theme><name>Numix</name> and gtk-3.0/settings.ini
```

### 7. Performance tuning

```bash
echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-swappiness.conf
# Add ,noatime to defaults in /etc/fstab for / and /boot
```

### 8. Reboot

```bash
sudo reboot
# Then: xrdb -merge ~/.Xresources
```
