#!/bin/bash

# ==============================================================================
# Terminal Environment Setup
# ==============================================================================
# This script handles the installation and configuration of terminal frameworks
# like Oh My Zsh.
# ==============================================================================

set -e

echo "Starting Terminal setup..."

# 1. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh not found. Installing Oh My Zsh..."
    
    # Run the Oh My Zsh unattended installer
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    echo "Oh My Zsh installed successfully."
else
    echo "Oh My Zsh is already installed. Skipping."
fi

# 2. (Optional) Custom Terminal Themes or Fonts
# Example: If you wanted to install a custom theme like Powerlevel10k, 
# you would clone it here:
# if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
#     git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# fi

# Note: The actual configuration (`.zshrc`, `.aliases`) is handled by symlinking
# in the main `bootstrap.sh` script to ensure git version control over the configs.

echo "Terminal setup completed."
