# Essential settings for Pop!_OS
sudo apt install grub-efi grub2-common grub-customizer os-prober
sudo grub-install
sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
