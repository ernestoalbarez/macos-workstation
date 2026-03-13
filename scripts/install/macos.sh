#!/bin/bash

# ==============================================================================
# macOS Preferences Configuration
# ==============================================================================
# This script configures standard macOS settings optimized for developers.
# Close System Settings before running this script to ensure changes take effect.
# ==============================================================================

set -e

echo "Configuring macOS preferences..."

# --- Finder Settings ---

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# --- Dock Settings ---

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Speed up the auto-hiding Dock animation
defaults write com.apple.dock autohide-time-modifier -float 0.15

# --- Keyboard & Trackpad ---

# Set a blazingly fast keyboard repeat rate
# Initial delay before repeating
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Speed of the repeat
defaults write NSGlobalDomain KeyRepeat -int 2

# Enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Applying changes (restarting UI components)..."
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true

echo "macOS preferences configured successfully."
