#!/bin/bash

echo "Starting workstation bootstrap..."

# install brew packages
echo "Installing Homebrew packages..."
brew bundle

# install dotfiles
echo "Installing dotfiles..."

cp dotfiles/.zshrc ~/
cp dotfiles/.aliases ~/
cp dotfiles/.gitconfig ~/

# install oh-my-zsh
echo "Installing Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# compile calendar mirror
echo "Compiling calendar mirror..."

cd scripts/calendar-mirror

swiftc busy_mirror.swift -o busy_mirror

# install launch agent
echo "Installing launch agent..."

cp busy.mirror.plist ~/Library/LaunchAgents/

launchctl load ~/Library/LaunchAgents/busy.mirror.plist

cd ../../

echo "Bootstrap completed!"
