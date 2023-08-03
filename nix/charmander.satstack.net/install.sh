#!/bin/bash
set -e
set -x

# Requires root ssh access to target machine: ssh root@${TARGET} 
TARGET=charmander
TARGET_DOMAIN=satstack.net


FORMAT_DISK ()
{
    dd if=/dev/zero count=1 bs=21M of=/dev/nvme0n1
    parted /dev/nvme0n1 -- mklabel gpt
    parted /dev/nvme0n1 -- mkpart primary 512MB 100%
    mkfs.ext4 -L nixos /dev/nvme0n1p1
    sync # wait for device to be ready
    mount /dev/disk/by-label/nixos /mnt

    # Create a new ESP
    parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
    parted /dev/nvme0n1 -- set 2 esp on
    mkfs.fat -F 32 -n boot /dev/nvme0n1p2
    sync # wait for device to be ready
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot

    # Or use an existing ESP (must have same boot loader type, ie. grub or systemd-boot)
    #mkdir -p /mnt/boot
    #mount /dev/nvme0n1p1 /mnt/boot

    nixos-generate-config --root /mnt
    mkdir -p /mnt/etc/nixos/ssh
}

echo "Install NixOS on ${TARGET}? Press enter to continue or ctrl+c to quit."
read

ssh root@${TARGET} "$(typeset -f FORMAT_DISK); FORMAT_DISK"

rsync -tv configuration.nix root@${TARGET}:/mnt/etc/nixos/

# ssh
ssh root@${TARGET} mkdir -p /etc/nixos/ssh
if [ -f ~/.ssh/ansible_root_keys ]; then
    rsync -v ~/.ssh/ansible_root_keys root@${TARGET}:/etc/nixos/ssh/authorized_keys
else
    rsync -v ~/.ssh/authorized_keys root@${TARGET}:/etc/nixos/ssh/authorized_keys
fi

# certificates
rsync -avz -e ssh blee:.secrets/acme/certificates/${TARGET}.${TARGET_DOMAIN}.* user2@remote2:/path/where/to/put/


ssh root@${TARGET} nixos-install