# Dotfiles

Personal configuration files for a clean, portable development environment.

## Font

This setup uses **JetBrains Mono Nerd Font** (no ligatures).

### Installation on a new machine

1. Download the latest JetBrains Mono Nerd Font from:
   https://github.com/ryanoasis/nerd-fonts/releases/latest

2. Extract the `.ttf` files into `~/dotfiles/fonts/` (or directly into `~/.fonts`).

3. Run:
   ```bash
   fc-cache -f -v
   ```

The font files are checked into this repo under `fonts/` for easy copying.

### Why this font?

- Excellent readability for long coding sessions.
- Modern alternative to older fonts like DejaVu Sans Mono.
- Works very well with Kitty + Starship.
- Ligatures are disabled (`disable_ligatures always` in Kitty config) to preserve traditional rendering after 25+ years of muscle memory.

## Tools & Environment

- Terminal: Kitty
- Prompt: Starship
- CLI tools: eza, bat, fd, ripgrep, fzf (with key bindings)
- Editor: Vim (managed in `vim/`)

## Setup on New Machine (future)

(To be expanded — clone repo, symlink dotfiles, install required fonts + packages.)

## Recently Added Tools

- **delta** — Beautiful syntax-highlighted git diffs and logs. Configured in `gitconfig`.
- **zoxide** — Smart `cd` replacement with frecency. Initialized in `bashrc`.

Install on new machines:
```bash
sudo apt install git-delta
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

## Kitty Window Icon

To have Kitty use a custom icon in the window decoration (titlebar) under Openbox and similar WMs:

- Place an image named `kitty.app.png` in `~/.config/kitty/`
- This repo manages it at `config/kitty/kitty.app.png` (symlinked).

The icon will be picked up automatically by Kitty on startup.
