# Terminal Setup

This workstation uses a customized terminal environment optimized for productivity and speed.

## Core Technologies

### Zsh (Z Shell)
macOS uses Zsh as the default login shell. Our configuration extends it with custom settings, path adjustments, and environment variables defined in `dotfiles/.zshrc`.

### Oh My Zsh
[Oh My Zsh](https://ohmyzsh.sh/) is a community-driven framework for managing your Zsh configuration. It comes bundled with thousands of helpful functions, helpers, plugins, and themes.

- **Theme:** We use the default `robbyrussell` theme for a clean, git-aware prompt.
- **Plugins:** Standard plugins like `git` provide auto-completion and aliases for common workflows.

## Configuration Files (Dotfiles)

The terminal behavior is controlled by our unified dotfiles, which are symlinked into the home directory during bootstrapping:

1. **`~/.zshrc`**: The main configuration file loaded when a new terminal session starts. It sources Oh My Zsh, defines paths, and loads custom scripts.
2. **`~/.aliases`**: A dedicated file for custom CLI shortcuts. This is sourced by the `.zshrc` to keep the configuration modular.
3. **`~/.gitconfig`**: The global Git configuration, mapping user details and standard dev behaviors (like `push.autoSetupRemote`).

## Custom Aliases

If you want to add personalized shortcuts (e.g., a command to quickly launch your favorite project), add them to `dotfiles/.aliases`.

*Example aliases you might find or add:*
```bash
alias ll="ls -la"
alias gs="git status"
```

To apply new aliases after editing the file, simply reload the shell:
```bash
source ~/.zshrc
```
