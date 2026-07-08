# Dotfiles

Personal configuration files for a minimal, fast Ubuntu 26.04 Openbox
workstation. Designed to be portable — run `install.sh` on any machine
with any username to get a fully configured development environment.

## Quick Start

```bash
git clone https://github.com/digitaldero/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
sudo reboot
```

The script is idempotent and safe to re-run. It detects whether the
machine is a laptop (prompts for y/N) and installs `cbatticon` only
when appropriate.

## What You Get

### Window Manager & UI

- **Openbox** — lightweight stacking WM, configured via `rc.xml`
- **lxpanel** — taskbar with launchers (Chrome, Kitty, Thunar) and
  system tray; Logout button runs `openbox --exit`
- **lxpolkit** — policy kit authentication agent
- **dunst** — notification daemon
- **feh** — wallpaper setter
- **Thunar** — file manager (replaced pcmanfm); SMB browsing enabled
  via gsettings
- **lxappearance** — GTK theme switcher

### Terminal & Shell

- **Kitty** 0.45.0 — GPU-accelerated terminal; Afterglow theme;
  DejaVu Sans Mono 11.2 with Nerd Font Symbols via `symbol_map`
- **Starship** — prompt with git status, timing, directory info
- **zoxide** — smart `cd` with frecency
- **fzf** — fuzzy finder with key bindings
- **eza**, **bat**, **fd**, **ripgrep**, **mc** — modern CLI tools

### Audio

- **PipeWire** + **wireplumber** — replaces PulseAudio
- **pasystray** — tray volume control
- **pavucontrol** — PulseAudio mixer

### Theming

- **GTK**: Adwaita-dark (theme), Papirus-Dark (icons), DMZ-Black
  (cursors), Inter 11 (GUI font)
- **Openbox window decorations**: Numix
- **Dark mode enforced**: gsettings override + GTK3/GTK4 `settings.ini`
- **Fontconfig**: Nerd Font symbols fallback for apps that need it

### Development Tools

| Category | Packages |
|---|---|
| CLI essentials | eza, bat, fd-find, ripgrep, fzf, zoxide, git-delta, mc, tig |
| Shell prompt | Starship |
| Editor | Vim (`vim-gtk3`) with config in `vim/` and `vimrc` |
| Terminal | Kitty |
| Node.js | NVM + Node.js + npm |
| AI/CLI | opencode (`@opencode-ai/plugin`) |

### System Services

| Service | Purpose |
|---|---|
| `wsdd.service` | SMB network discovery (lets Thunar see Windows shares) |
| `pipewire` + `pipewire-pulse` + `wireplumber` | Audio subsystem |
| gnome-keyring | Empty-password keyring for libsecret clients |
| `99-swappiness.conf` | `vm.swappiness=10` |
| `noatime` | Added to root filesystem mount in fstab |

### Window Icon

Kitty uses a custom icon in the titlebar via `config/kitty/kitty.app.png`
(symlinked to `~/.config/kitty/`). The desktop entry at
`.local/share/applications/kitty.desktop` overrides the icon to
`utilities-terminal` (Papirus).

## Package List

All packages installed by `install.sh`:

```
eza kitty bat fd-find ripgrep fzf zoxide git-delta starship mc
openbox lxpanel lxpolkit dunst feh thunar scrot wsdd
network-manager-gnome pasystray pavucontrol copyq gh lxappearance
fonts-dejavu fonts-dejavu-core vim-gtk3 xinit xorg dmz-cursor-theme
numix-gtk-theme papirus-icon-theme pipewire pipewire-pulse wireplumber
nodejs npm tig plocate libsecret-tools smbclient samba-common
```

Plus `cbatticon` on laptops only.

Non-apt tools installed by the script:

- **NVM** — from `nvm-sh/nvm` v0.40.4
- **opencode** — `npm install -g @opencode-ai/plugin`

## Design Decisions

| Decision | Rationale |
|---|---|
| **No display manager** | LightDM/gdm3 are unnecessary with `startx` from console |
| **Adwaita-dark + Papirus-Dark** | Consistent dark theme; no CSD conflicts |
| **Empty-password keyring** | Avoids unlock prompts at boot; libsecret still works |
| **No compositor** | picom/compton omitted for zero overhead; Intel graphics handle it |
| **No screen locker** | No xscreensaver, i3lock, etc. — workstation use case |
| **`cbatticon` on laptop only** | Prompt avoids unnecessary install on desktop |
| **SMB via WSDD** | `wsdd` provides mDNS-like discovery for Samba shares on local network |
| **Kitty `symbol_map` vs font patching** | Single symbols font avoids carrying patched DejaVu in repo |

## Directory Layout

```
dotfiles/
├── install.sh           # Bootstrap script (run this)
├── AGENTS.md            # Step-by-step manual + session history
├── bashrc               # ~/.bashrc
├── gitconfig            # ~/.gitconfig
├── vimrc                # ~/.vimrc
├── Xresources           # ~/.Xresources
├── gtkrc-2.0            # ~/.gtkrc-2.0
├── bin/                 # ~/bin (custom scripts)
├── fonts/               # Nerd Font Symbols, Inter
├── themes/              # Openbox themes (Numix, custom/)
├── vim/                 # Vim plugins and config
├── config/
│   ├── openbox/         # autostart, rc.xml
│   ├── kitty/           # kitty.conf, current-theme.conf, kitty.app.png
│   ├── gtk-3.0/         # settings.ini
│   ├── gtk-4.0/         # settings.ini
│   ├── lxpanel/         # panel layout
│   ├── starship/        # starship.toml
│   ├── fontconfig/      # 51-nerd-font-symbols.conf
│   └── systemd/         # wsdd.service
└── .local/share/applications/
    └── kitty.desktop    # Desktop entry with Papirus icon
```

All config files are symlinked by `install.sh` — the repo is the
source of truth.
