# New Mac Setup Roadmap

This document describes the manual steps required when setting up a new laptop.

---

## Step 1 — macOS base setup

Login to:
- Apple ID
- GitHub
- Google

Install Xcode command line tools:
```bash
xcode-select --install
```

---

## Step 2 — Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Verify:
```bash
brew doctor
```

---

## Step 3 — Clone workstation repository
```bash
git clone git@github.com:ernestoalbarez/macos-workstation.git
cd macos-workstation
```

---

## Step 4 — Run bootstrap

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

---

## Step 5 — Configure Git

```bash
git config --global push.autoSetupRemote true
git config --global user.name "Ernesto Albarez"
git config --global user.email "ernestoalbrz@gmail.com"
```

> This configuration sets up the automatic creation of a new remote branch


### Generate SSH key:

```bash
ssh-keygen -t ed25519 -C "ernestoalbrz@gmail.com"
```

Add key to SSH agent
```bash
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Copy public key
```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Add key to GitHub.
> Settings → SSH and GPG Keys → New SSH Key

Test connection
```bash
ssh -T git@github.com
```
Terminal output:
> Hi ernestoalbarez! You've successfully authenticated...
---

## Step 6 — Verify environment

Check installed tools:

```bash
node -v
docker -v
git -v
```

--- 

## Step 7 — Validate automations

Check calendar mirror:

```bash
launchctl list | grep busy
```

Open Calendar and confirm Busy Mirror updates automatically.
