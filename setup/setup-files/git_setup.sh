#!/bin/bash

# ============================================
# Git Global Configuration
# ============================================

set -e

# Default values
GIT_USER_NAME="maskedsyntax"
GIT_USER_EMAIL="aftaab@aftaab.xyz"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

# 1. User Identity
print_status "Setting up git user identity..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# 2. Credential Helper (Store credentials locally)
print_status "Setting up credential helper (store)..."
git config --global credential.helper store

# 3. Default Editor (Vim is your preferred editor)
print_status "Setting up default editor (vim)..."
git config --global core.editor "vim"

# 4. Pull strategy (Rebase is cleaner)
print_status "Setting up default pull strategy (rebase)..."
git config --global pull.rebase true

# 5. Init branch name (Modern standard is 'main')
print_status "Setting up default branch name (master)..."
git config --global init.defaultBranch master

print_status "Git Setup Complete!"
