# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="my_agnoster"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.oh-my-custom-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  ssh-agent
  docker
  kubectl
  yarn
  zsh-completions
  docker-compose
  extract
  gcloud
  volta
  poetry
  pyenv
  ripgrep
)

# Disable magic functions
DISABLE_MAGIC_FUNCTIONS=true

# Cuda directories
export PATH="${PATH}:/opt/cuda/bin"
export CPATH="${CPATH}:/opt/cuda/include"

# Sets up pkg-config path
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}/usr/local/lib64/pkgconfig/"

# Sets up lib64 path
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib64/

# Useful aliases
alias tpr="tput reset"

# pyenv
eval "$(pyenv init --path)"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# local bin
export PATH="${PATH}:$HOME/.local/bin"

# go bin
export PATH="${PATH}:$HOME/go/bin"

# disable homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# source some env vars
if [[ -f $HOME/.env && -r $HOME/.env ]]; then
  source $HOME/.env
fi

# reload zsh completions
autoload -U compinit && compinit

neofetch
