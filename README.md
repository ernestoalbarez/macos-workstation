# macOS Workstation Setup

This repository contains the configuration and scripts required to bootstrap my development workstation on macOS.

The objective is to make the setup:
- reproducible
- version controlled
- fast to reinstall on a new machine

---

## Overview

The setup installs and configures:
- Homebrew packages
- developer tools
- terminal environment
- dotfiles
- automation scripts
- calendar mirror for Calendly

---

## Technologies

 - macOS
 - Homebrew
 - Oh My Zsh
 - Swift (EventKit automation)
 - launchd
 - Git

 ---

## Environment Setup

### Install dependencies
```bash
brew bundle
```

Clone the repository:
```bash
git clone git@github.com:ernestoalbarez/macos-workstation.git
cd macos-workstation
```

Run bootstrap:
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

---

## Repository Structure

```bash
bootstrap.sh      → installs the entire environment using symlinks
Brewfile          → list of brew packages
dotfiles          → shell configuration
scripts           → automation and installation scripts
launchd           → launch agent configurations
docs              → documentation
ROADMAP.md        → manual setup guide
```

---

## Key Automation

### Busy Mirror Calendar

A Swift script that mirrors busy events from multiple calendars into a dedicated calendar used by Calendly.

Features:
- merges overlapping events
- adds buffer time
- excludes holidays
- avoids duplicates
- runs automatically every 5 minutes

See: [docs/calendly-mirror.md](/docs/calendly-mirror.md)

---

### Terminal Profile
A customized Zsh and Oh My Zsh environment managed via symlinked dotfiles.
See: [docs/terminal-setup.md](/docs/terminal-setup.md)

---

### macOS Configurations
Automated and standardized macOS preferences (Dock, Finder, Trackpad) optimized for development.
See: [docs/macos-preferences.md](/docs/macos-preferences.md)

---

### Future Improvements
- dev container templates
- laptop onboarding checklist
