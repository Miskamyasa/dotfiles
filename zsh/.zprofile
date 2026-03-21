# set the amazing ZDOTDIR variable
export ZDOTDIR=~/.config/zsh

# remove duplicate entries from $PATH
# zsh uses $path array along with $PATH 
typeset -U PATH path

## XDG
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="$HOME/.local/bin"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

## PATH
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

## GPG
export GPG_TTY=$(tty)

## vim
export EDITOR=vim
export VISUAL=vim

## Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export BREW_OPT_PATH="/opt/homebrew/opt"

## MISE
eval "$(mise activate zsh)"

## GoLang
export GOPATH="$XDG_DATA_HOME/golib"
export GOMODCACHE="$GOPATH/pkg/mod"
export PATH="$GOPATH/bin:$PATH"
export GOENV="$XDG_DATA_HOME/go/env"
export GOCACHE="$XDG_CACHE_HOME/go"

## Ruby
export PATH="$BREW_OPT_PATH/ruby/bin:$PATH"
export PKG_CONFIG_PATH="$BREW_OPT_PATH/ruby/lib/pkgconfig"

## Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

## Android
export ANDROID_HOME=$HOME/.android/sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/25.2.9519653

## Postgres
export PATH="$BREW_OPT_PATH/postgresql@17/bin:$PATH"

## Colima
export COLIMA_HOME="$XDG_CONFIG_HOME/colima"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_SAVE_EXACT=true
export NPM_CONFIG_ENGINE_STRICT=true

# Bat (terminal syntax highlighter)
export BAT_THEME="Solarized (light)"

# fzf
export FZF_COM="fd --type f --color=never --hidden"
export FZF_OPTS="
  --border --info=inline
  --walker-skip .git,node_modules,target,build
  --preview 'bat --color=always --line-range :30 {}'"
export FZF_DEFAULT_COMMAND="$FZF_COM"
export FZF_COMPLETION_TRIGGER=';;'
export FZF_COMPLETION_OPTS="$FZF_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_COM"
export FZF_CTRL_T_OPTS="$FZF_OPTS"
export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target,build
  --preview 'tree -C {} | head -30'"

## Other Env
export CROSS_ENV=dzaitsev
export NODE_ENV=development
export NEW_RELIC_ENABLED=false
export TIMING=1
export NODE_OPTIONS="--max-old-space-size=6092"

# Ai agents

## Codex
export CODEX_HOME="$XDG_DATA_HOME/codex"

# Pi AI
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi"

# Alacritty theme auto-switcher
(nohup zsh ${XDG_CONFIG_HOME}/alacritty/theme-autoswitch.sh  >/dev/null 2>&1 &) 

# Include all secters from .zsecrets
. "$HOME/.config/zsh/.zsecrets"
