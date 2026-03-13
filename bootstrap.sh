#!/bin/bash
set -e

echo "Starting workstation bootstrap..."

# 1. Check and install Homebrew if missing
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configure path for Apple Silicon / Intel
    if [ -x "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

# 2. Install brew packages
echo "Installing Homebrew packages..."
brew bundle

# 3. Create required directories
mkdir -p "$HOME/bin"

# 4. Install dotfiles using symlinks
echo "Installing dotfiles via symlinks..."
ln -sf "$PWD/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/dotfiles/.aliases" "$HOME/.aliases"
ln -sf "$PWD/dotfiles/.gitconfig" "$HOME/.gitconfig"

# 5. Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# 6. Compile calendar mirror and place it in ~/bin
echo "Compiling calendar mirror..."
cd scripts/calendar-mirror
swiftc busy_mirror.swift -o "$HOME/bin/busy_mirror"

# 7. Install launch agent
echo "Installing launch agent..."
cd ../../
mkdir -p "$HOME/Library/LaunchAgents"
cp launchd/busy.mirror.plist "$HOME/Library/LaunchAgents/"

# Reload launch agent safely
launchctl unload "$HOME/Library/LaunchAgents/busy.mirror.plist" 2>/dev/null || true
launchctl load "$HOME/Library/LaunchAgents/busy.mirror.plist"

echo "Bootstrap completed!"
