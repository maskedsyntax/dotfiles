# Dotfiles

My dotfiles for various programs that I use.

### Enable Natural Scrolling and Tap to Click

Use `xinput list` to find the id of the touchpad device
```bash
xinput set-prop <id> "libinput Natural Scrolling Enabled" 1
```

```bash
xinput set-prop <id> "libinput Tapping Enabled" 1
```

### Cinnamon Configuration
To use MaskedSyntax theme for cinnamon desktop (dark black panel with 70% transparency), move the folder `/cinnamon-theme/MaskedSyntax` to `/usr/share/themes/` and select the theme from the settings app.

### Vim Config

To Copy/Paste text from vim to other applications: </br>
* Install the following to use clipboard with vim
  * For Debian based distros: Install `vim-gtk3`
  * For Fedora : Install `vim-gtk3`
  * For Arch Linux : Install `gvim` (this will enable `+clipboard` for normal vim as well)
* Once the above is installed, add `set clipboard=unnamedplus` to your vimrc

*Optional*

I have configured my vim to use only two spaces for indentation instead of four for python.
This can be done by adding these lines to your vimrc: </br>
`let g:python_recommended_style = 0` </br>
`let g:loaded_matchparen=1` </br>
`filetype plugin indent on` </br>


To enable os-prober for Arch Linux: </br>
* Install `os-prober` (if not installed)
* Try: `sudo grub-mkconfig -o /boot/grub/grub.cfg`
* Open `/etc/default/grub` with vim: `sudo vim /etc/default/grub`
* Check: `GRUB_DISABLE_OS_PROBER` and set it to `false`
* Try again: `sudo grub-mkconfig -o /boot/grub/grub.cfg`


To fix the Postman Certificate issue:
* Manually create the certificates in `~/.var/app/com.getpostman.Postman/config/Postman/proxy`:
```bash
    openssl req -subj '/C=US/CN=Postman Proxy' -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -keyout postman-proxy-ca.key -out postman-proxy-ca.crt
```
