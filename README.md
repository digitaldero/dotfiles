# Dotfiles

Personal configuration files for a clean, portable development environment.

## Fonts

### Terminal: DejaVu Sans Mono + Symbols Nerd Font Mono

Kitty renders **plain DejaVu Sans Mono** for text (crisp, no ligatures). Icons come from a single symbols-only font via `symbol_map` in `config/kitty/kitty.conf`:

- eza file icons (`ll`, `lg`, …)
- Starship git branch glyph (` `)
- powerline / nerd-font prompt symbols

Kitty tuning for crisp rendering:

```
font_size 11.2
disable_ligatures always
text_composition_strategy legacy
```

**One font file** is checked into `fonts/`:

- `SymbolsNerdFontMono-Regular.ttf` — from the [NerdFontsSymbolsOnly](https://github.com/ryanoasis/nerd-fonts/releases) package

DejaVu Sans Mono itself comes from the system (`fonts-dejavu` / `fonts-dejavu-core`). Optional Powerline-patched DejaVu files in `fonts/` are legacy; vim-airline symbols also work via Symbols Nerd Font.

Fontconfig fallback (for Alacritty and other apps) is in `config/fontconfig/conf.d/51-nerd-font-symbols.conf`. Symlink into `~/.config/fontconfig/conf.d/`, then:

```bash
fc-cache -f -v
```

Debug missing Kitty icons: `kitty --debug-font-fallback`

### GUI: Inter

Inter is used for Openbox and other GUI elements. Kept in `fonts/`.

## Prompt

**Starship** provides the shell prompt (`eval "$(starship init bash)"` in `bashrc`). Config: `config/starship/starship.toml`.

The git segment is two Starship modules:

| Module | Shows |
|---|---|
| `git_branch` | Branch name with ` ` nerd-font symbol (purple) |
| `git_status` | Repo state when dirty: `?` untracked, `!` modified, `+` staged, `↑`/`↓` ahead/behind, etc. |

When the repo is clean, only the branch line appears. Run `starship explain` in any directory to see what each segment is.

`[git_branch]` hides `main`/`master` when clean; `[git_state]` shows rebase/merge/etc.; dirty-state symbols come from `[git_status]`.

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
