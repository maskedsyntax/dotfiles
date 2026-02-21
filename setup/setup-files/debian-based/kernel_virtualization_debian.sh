# Enabling Kernel Virtualization in the system
echo -e "===============================================\n"
echo -e "Enabling Kernel Virtualization in the system\n"
echo -e "===============================================\n"
sudo apt install cpu-checker
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm
virsh list --all

echo -e "===============================================\n"
echo -e "                      DONE                       "
echo -e "===============================================\n"
