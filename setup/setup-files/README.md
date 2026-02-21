# Setup Notes & Attention Points

### General
- **Logs:** Progress is logged to `~/<distro>_setup.log`. Use `tail -f` to monitor.
- **Sudo:** Scripts require root privileges; be ready to enter your password.
- **Interactive:** Oh-My-Zsh may prompt to change your default shell to Zsh.

### Manual Installations (`/opt`)
- **JetBrains & Android Studio:** Extracted to `/opt/`. Desktop entries are created in `/usr/share/applications/`.
- **Flutter:** Cloned to `/opt/flutter`.
- **Post-Install:** You **must** restart your shell or run `source ~/.zshrc` to activate Flutter, Dart, and Go paths.

### Package Managers
- **Arch:** Ensure `base-devel` is functional before running; the script installs `yay` automatically if missing.
- **Fedora/OpenSUSE:** Multimedia codecs and Flatpak (Flathub) are enabled during the run. Some third-party apps (Spotify, Cursor, Postman) are installed via Flatpak.

### Git Setup
- Global config (User, Email, Rebase, Master branch) is applied automatically at the start of each script.
- Default editor is set to **Vim**.
