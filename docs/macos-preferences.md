# macOS Preferences Configuration

This project includes configurations to optimize the macOS desktop experience for development. These settings can be applied automatically via our installation scripts.

## Key Configurations

### Finder
- **Show Hidden Files:** Essential for interacting with dotfiles (e.g., `.zshrc`, `.gitignore`) directly from the Finder interface.
- **Show All Filename Extensions:** Prevents macOS from hiding standard file extensions (like `.md` or `.sh`), which is critical for development context.
- **Path Bar:** Displays the current folder path at the bottom of the Finder window.

### Dock & Window Management
- **Autohide Dock:** Automatically hides the Dock to save vertical screen space.
- **Fast Animation:** Speeds up the autohide animation so the Dock appears unnoticeably fast when you need it.

### Keyboard & Trackpad
- **Fast Key Repeat:** Increases the key repeat rate, making navigation with arrow keys inside code editors significantly faster.
- **Short Initial Delay:** Reduces the time you have to hold a key before it starts repeating.
- **Tap to Click:** Enables tapping the Trackpad to register a click.

## Example CLI Usage

Instead of clicking through System Settings, these can be set via the terminal using the `defaults write` command. 

*Example:* To enable showing hidden files in Finder, the corresponding command is:
```bash
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
```

To see the complete list of automated configurations provided by this workstation template, check `scripts/install/macos.sh`.
