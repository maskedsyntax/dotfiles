#!/usr/bin/env bash

# ============================================
# OpenSUSE Tumbleweed Backend/API Setup Script
# ============================================
#
# Scope:
# - Backend/API collection work for RapidAPI publishing
# - Small frontend toolchain
# - Daily essentials: browsers, terminals, media, Bluetooth, NVIDIA, Spotify
# - Kept extras: OBS Studio, Discord, Okular, Zed, Picom, Rofi app launcher, AI CLI tools
# - Intentionally excludes mobile stacks, heavy JetBrains installs, graphics suites,
#   game clients, and broad desktop creator tooling.

set -uo pipefail

LOGFILE="${HOME}/opensuse_tumbleweed_backend_setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'
FAILED_STEPS=()

print_status() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}WARN:${NC} $1"
}

run_step() {
    local step_name="$1"
    shift

    print_status "$step_name"

    if (set -euo pipefail; "$@"); then
        print_status "Completed: $step_name"
    else
        local status=$?
        FAILED_STEPS+=("$step_name exited with status $status")
        print_warning "Failed: $step_name. Continuing with the rest of the setup."
    fi
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

require_tumbleweed() {
    if [[ -r /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        if [[ "${ID:-}" != "opensuse-tumbleweed" ]]; then
            print_warning "This script targets OpenSUSE Tumbleweed. Detected ID='${ID:-unknown}'. Continuing anyway."
        fi
    fi
}

zypper_install() {
    sudo zypper --non-interactive install --auto-agree-with-licenses "$@"
}

add_repo_once() {
    local alias="$1"
    local url="$2"

    if sudo zypper repos --alias | awk '{print $1}' | grep -Fxq "$alias"; then
        print_status "Repository '$alias' already exists."
    else
        sudo zypper --non-interactive addrepo -f "$url" "$alias"
    fi
}

setup_git() {
    print_status "Configuring Git..."
    git config --global user.name "maskedsyntax"
    git config --global user.email "aftaab@aftaab.xyz"
    git config --global credential.helper store
    git config --global core.editor "hx"
    git config --global pull.rebase true
    git config --global init.defaultBranch master
}

install_packman() {
    add_repo_once "packman" "https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/"
    sudo zypper --non-interactive --gpg-auto-import-keys refresh
    sudo zypper --non-interactive dist-upgrade --from packman --allow-vendor-change --auto-agree-with-licenses
}

install_nvidia() {
    add_repo_once "nvidia" "https://download.nvidia.com/opensuse/tumbleweed"
    sudo zypper --non-interactive --gpg-auto-import-keys refresh

    # G06 covers current NVIDIA proprietary drivers on Tumbleweed for most supported GPUs.
    zypper_install \
        nvidia-video-G06 \
        nvidia-gl-G06 \
        nvidia-compute-G06 \
        nvidia-utils-G06
}

install_system_packages() {
    sudo zypper --non-interactive dup --auto-agree-with-licenses

    print_status "Installing base development pattern for native backend dependencies..."
    sudo zypper --non-interactive install -t pattern devel_basis --auto-agree-with-licenses

    print_status "Installing base backend/API and desktop essentials..."
    zypper_install \
        git curl wget unzip tar gzip xz jq yq ripgrep fd tree tmux zsh bash-completion \
        openssh rsync ca-certificates ca-certificates-mozilla gnupg2 \
        vim neovim helix \
        htop btop fastfetch cloc lsof net-tools bind-utils nmap \
        python3 python3-pip python3-virtualenv python3-devel python3-pipx \
        nodejs npm \
        go \
        java-21-openjdk-headless \
        docker docker-compose podman podman-compose \
        httpie \
        sqlite3 postgresql mariadb-client \
        alacritty kitty \
        firefox chromium brave-browser \
        vlc mpv ffmpeg obs-studio okular picom \
        rofi \
        flatpak xdg-utils \
        xfconf \
        thunar thunar-archive-plugin file-roller \
        pavucontrol flameshot \
        bluez bluez-tools blueman \
        cascadia-fonts jetbrains-mono-fonts fira-code-fonts google-noto-fonts
}

install_third_party_repos() {
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    add_repo_once "brave-browser" "https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo"

    sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
    add_repo_once "google-chrome" "https://dl.google.com/linux/chrome/rpm/stable/x86_64"

    sudo rpm --import https://download.sublimetext.com/sublimehq-pub.gpg
    add_repo_once "sublime-text" "https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo"

    sudo zypper --non-interactive --gpg-auto-import-keys refresh

    print_status "Installing GUI editors and browser packages..."
    zypper_install sublime-text brave-browser google-chrome-stable
}

install_flatpak_apps() {
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub \
        com.getpostman.Postman \
        rest.insomnia.Insomnia \
        com.usebruno.Bruno \
        com.discordapp.Discord \
        com.spotify.Client
}

install_runtime_tools() {
    if command_exists npm; then
        sudo npm install -g \
            pnpm \
            yarn \
            prettier \
            typescript \
            typescript-language-server \
            vscode-langservers-extracted \
            yaml-language-server \
            bash-language-server \
            pyright \
            @google/gemini-cli \
            @anthropic-ai/claude-code
    fi

    if ! command_exists uv; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

    if ! command_exists bun; then
        curl -fsSL https://bun.sh/install | bash
    fi

    print_status "Installing Zed editor..."
    curl -f https://zed.dev/install.sh | sh
}

install_shell_tools() {
    if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
        print_status "Installing Oh My Zsh unattended..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        print_status "Oh My Zsh already installed."
    fi
}

configure_services() {
    sudo systemctl enable --now bluetooth

    if systemctl list-unit-files docker.service >/dev/null 2>&1; then
        sudo systemctl enable --now docker
        sudo usermod -aG docker "$USER"
        print_warning "Docker group membership requires logout/login before non-sudo Docker works."
    fi
}

setup_rofi_launcher() {
    local script_dir
    local repo_root
    local rofi_source_dir
    local rofi_config_dir="${HOME}/.config/rofi"
    local launcher_path="${HOME}/.local/bin/rofi-app-launcher"
    local rofi_theme="${rofi_config_dir}/arc_dark_transparent_colors.rasi"
    local rofi_command="${launcher_path}"

    set_xfce_shortcut() {
        local shortcut="$1"
        local command="$2"
        local property="/commands/custom/${shortcut}"

        xfconf-query -c xfce4-keyboard-shortcuts -p "$property" -s "$command" 2>/dev/null ||
            xfconf-query -c xfce4-keyboard-shortcuts -p "$property" -n -t string -s "$command"
    }

    script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
    repo_root="$(cd -- "${script_dir}/../../.." && pwd)"
    rofi_source_dir="${repo_root}/config/rofi"

    mkdir -p "$rofi_config_dir" "${HOME}/.local/bin"

    if [[ -d "$rofi_source_dir" ]]; then
        cp -R "${rofi_source_dir}/." "$rofi_config_dir/"
    else
        print_warning "Could not find repo Rofi config at $rofi_source_dir. Creating launcher with default Rofi theme."
        rofi_theme=""
    fi

    cat >"$launcher_path" <<'EOF'
#!/usr/bin/env bash

THEME="${HOME}/.config/rofi/arc_dark_transparent_colors.rasi"

if [[ -f "$THEME" ]]; then
    exec rofi -show drun -show-icons -theme "$THEME"
fi

exec rofi -show drun -show-icons
EOF
    chmod +x "$launcher_path"

    # Replace XFCE's run/appfinder shortcuts with Rofi when XFCE settings are available.
    # Alt+F2 is the common XFCE "Run Program" shortcut; Alt+F3 is commonly appfinder.
    # Super+Space and Super+R provide fast launcher alternatives.
    if command_exists xfconf-query; then
        set_xfce_shortcut "<Alt>F2" "$rofi_command" || true
        set_xfce_shortcut "<Alt>F3" "$rofi_command" || true
        set_xfce_shortcut "<Super>space" "$rofi_command" || true
        set_xfce_shortcut "<Super>r" "$rofi_command" || true
    else
        print_warning "xfconf-query not found. Rofi launcher was installed, but XFCE shortcuts were not changed."
    fi

    print_status "Rofi launcher installed at $launcher_path"
    if [[ -n "$rofi_theme" ]]; then
        print_status "Rofi theme installed at $rofi_theme"
    fi
}

set_defaults() {
    xdg-settings set default-web-browser google-chrome.desktop || true
    xdg-mime default google-chrome.desktop x-scheme-handler/http x-scheme-handler/https text/html || true
    xdg-mime default thunar.desktop inode/directory || true
}

main() {
    run_step "Checking OpenSUSE Tumbleweed target" require_tumbleweed
    run_step "Configuring third-party browser/editor repositories" install_third_party_repos
    run_step "Enabling Packman repository and codecs" install_packman
    run_step "Installing backend/API and desktop packages" install_system_packages
    run_step "Installing NVIDIA drivers" install_nvidia
    run_step "Configuring Git" setup_git
    run_step "Installing Flatpak API/daily apps" install_flatpak_apps
    run_step "Installing Node, Python, API CLI, AI CLI, Bun, uv, and Zed tooling" install_runtime_tools
    run_step "Installing shell tooling" install_shell_tools
    run_step "Enabling services" configure_services
    run_step "Configuring Rofi app launcher for XFCE shortcuts" setup_rofi_launcher
    run_step "Setting default applications" set_defaults

    if ((${#FAILED_STEPS[@]} > 0)); then
        print_warning "Setup completed with ${#FAILED_STEPS[@]} failed step(s). Review $LOGFILE."
        printf '%s\n' "${FAILED_STEPS[@]}"
    else
        print_status "Setup completed without recorded step failures."
    fi

    print_status "OpenSUSE Tumbleweed backend/API setup finished. Log: $LOGFILE"
}

main "$@"
