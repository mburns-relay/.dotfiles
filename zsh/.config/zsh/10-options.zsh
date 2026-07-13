# --- History ---
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS INC_APPEND_HISTORY
setopt AUTO_CD EXTENDED_GLOB INTERACTIVE_COMMENTS

# --- Vi mode (req 10) ---
bindkey -v
export KEYTIMEOUT=1
# Keep useful emacs-style keys in insert mode
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
# Cursor shape: block in normal, beam in insert
_cursor_shape() { case $KEYMAP in vicmd) printf '\e[2 q';; *) printf '\e[6 q';; esac }
zle -N zle-keymap-select _cursor_shape
zle -N zle-line-init _cursor_shape

# --- Completion ---
autoload -Uz compinit && compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Readline apps (bash, etc.) get vi mode too — see git/.inputrc-style config.
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/inputrc"
