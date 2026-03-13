# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="half-life"

# Plugins
# git: Add git aliases and functions
# docker: Add docker auto-completion
# node: Add node.js environment configuration
# zsh-autosuggestions: Suggest commands based on history
# zsh-syntax-highlighting: Highlight command syntax
plugins=(
  git
  docker
  node
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Autosuggestions strategy
ZSH_AUTOSUGGEST_STRATEGY=(completion)

# History settings
HIST_IGNORE_SPACE=1
HIST_SIZE=5000
SAVEHIST=5000

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load custom aliases
if [ -f "$HOME/.aliases" ]; then
  source $HOME/.aliases
fi

# Preferred editor
export EDITOR="code"

# Useful PATH additions
# Includes ~/bin for custom automation scripts like busy_mirror
export PATH="$HOME/bin:$PATH"
