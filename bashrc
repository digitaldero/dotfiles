# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000

# Update LINES and COLUMNS after each command
shopt -s checkwinsize

# Make less friendly with binary files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colored prompt + Git info (fancy Powerline style)
PROMPT_DIRTRIM=4
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="git"

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# =====================
# eza - Modern ls replacement (replaces old ls aliases)
# =====================
alias ls='eza --color=always --group-directories-first'
alias ll='eza -lag --icons --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'
alias l='eza -l --smart-group --color=always --group-directories-first'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
alias llt='eza -lag --tree --level=2 --color=always --group-directories-first --icons'
alias lg='eza -lag --git --icons --color=always --group-directories-first'

# Alert for long commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Load custom aliases if they exist
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# =====================
# Personal additions
# =====================

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Composer global bin (php-cs-fixer lives here)
# This was lost during the bashrc cleanup
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Fix Ctrl+S in vim
bind -r '\C-s'
stty -ixon
export EDITOR="vi"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Grok
export PATH="$HOME/.grok/bin:$PATH"
[[ -r "$HOME/.grok/completions/bash/grok.bash" ]] && source "$HOME/.grok/completions/bash/grok.bash"

# Foundry 
export PATH="$HOME/.foundry/bin:$PATH"

# Truecolor support
export COLORTERM=truecolor

# =====================
# Modern CLI Tools - Starter Pack
# =====================

# bat - better cat with syntax highlighting
# Use 'batcat' directly if you want paging
alias cat='batcat --paging=never'
alias less='batcat'

# fd - better find (much faster and nicer syntax)
alias find='fdfind'

# ripgrep - better grep (extremely fast)
alias grep='rg'

# fzf - fuzzy finder (huge productivity booster)
# Basic usage: press Ctrl+R for history, Ctrl+T to search files
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Quick fuzzy find + edit
alias f='fzf'
alias fe='fzf --preview "batcat --color=always --style=numbers --line-range=:500 {}" | xargs -r ${EDITOR:-vi}'

# Search file contents with ripgrep + fzf
alias rgf='rg --files | fzf'


# =====================
# fzf - Keybindings & Completion (Ubuntu/Debian apt version)
# =====================
# This enables:
#   Ctrl+R → fuzzy history search (what you asked about)
#   Ctrl+T → fuzzy file search
#   Alt+C  → fuzzy cd into directory

if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
fi

if [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
  source /usr/share/doc/fzf/examples/completion.bash
fi

# Make fzf use bat for previews when possible (nice with your setup)
export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --level=2 {} 2>/dev/null || tree -C {}'"


# =====================
# Starship Prompt (modern replacement for old Powerline prompt)
# =====================
eval "$(starship init bash)"

# =====================
# zoxide - smarter cd
# =====================
eval "$(zoxide init bash --cmd cd)"
# Now "cd" is smart (learns from your history). Use "z foo" or just "cd foo".

# Common aliases
alias z='zoxide query -i'          # interactive directory jumper

# opencode
export PATH=/home/chris/.opencode/bin:$PATH
