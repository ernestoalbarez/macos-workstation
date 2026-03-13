#!/bin/bash

# ==============================================================================
# Application Installer
# ==============================================================================
# This script is responsible for installing applications.
# In this workstation template, primary app installation is handled by `brew bundle`
# inside `bootstrap.sh`. This script serves as a standalone wrapper or extension point for
# other package managers (e.g., `mas` for Mac App Store, `npm` globals).
# ==============================================================================

set -e

echo "Starting application installation..."

# Ensure Homebrew is available (if this is run standalone)
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is required but not installed."
    echo "Please run bootstrap.sh first or install Homebrew manually."
    exit 1
fi

# 1. Install applications via Homebrew Bundle
if [ -f "../../Brewfile" ]; then
    echo "Running brew bundle based on ../../Brewfile..."
    # Execute brew bundle in the root repository directory
    (cd ../../ && brew bundle)
else
    echo "Brewfile not found in the repository root. Skipping brew bundle."
fi

# 2. (Optional) Mac App Store Apps via `mas`
# Uncomment and add App IDs if using `mas`
# if command -v mas &> /dev/null; then
#     echo "Installing Mac App Store applications..."
#     # mas install 497799835 # Xcode
# else
#     echo "mas-cli not found. Skipping Mac App Store apps."
# fi

# 3. (Optional) Global Node packages
# if command -v npm &> /dev/null; then
#     echo "Installing global npm packages..."
#     # npm install -g pnpm yarn
# fi

echo "Application installation completed."
