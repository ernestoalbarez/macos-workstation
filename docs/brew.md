# Homebrew Setup

This project uses **Homebrew** to install development tools and applications.

All packages are defined in the Brewfile.

## Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Verify installation:

```bash
brew doctor
```

## Install all packages

Run:
```bash
brew bundle
```

This installs:

### CLI tools
- git
- node
- jq
- tree
- wget

### Applications
- Google Chrome
- Visual Studio Code
- Docker Desktop
- Slack
- Postman

## Update packages

```bash
brew update
brew upgrade
```