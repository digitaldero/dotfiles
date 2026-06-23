# Dotfiles

Personal configuration files for a clean, portable development environment.

## Fonts

### Terminal: DejaVu Sans Mono Nerd Font

Kitty uses **DejaVuSansM Nerd Font Mono** — DejaVu Sans Mono patched with Nerd Font icons (git glyphs, eza file icons, Starship symbols).

Kitty tuning for crisp rendering:

```
font_size 11.2
disable_ligatures always
text_composition_strategy legacy
```

Only four weights are needed in `fonts/`:

- `DejaVuSansMNerdFontMono-Regular.ttf`
- `DejaVuSansMNerdFontMono-Bold.ttf`
- `DejaVuSansMNerdFontMono-Oblique.ttf`
- `DejaVuSansMNerdFontMono-BoldOblique.ttf`

Download from: https://github.com/ryanoasis/nerd-fonts/releases (DejaVuSansMono package)

Then run `fc-cache -f -v`.

### GUI: Inter

Inter is used for Openbox and other GUI elements. Kept in `fonts/`.

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
