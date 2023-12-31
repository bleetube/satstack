#!/bin/bash
set -e
set -x

# Requires root ssh access to target machine: ssh root@${TARGET} 
TARGET=weavile
TARGET_DOMAIN=satstack.net

FORMAT_DISK ()
{
    dd if=/dev/zero count=1 bs=2M of=/dev/sda
    parted /dev/sda -- mklabel gpt
    parted /dev/sda -- mkpart primary 512MB 100%
    parted /dev/sda -- mkpart ESP fat32 1MB 512MB
    parted /dev/sda -- set 2 esp on
    mkfs.ext4 -L nixos /dev/sda1
    mkfs.fat -F 32 -n boot /dev/sda2
    mount /dev/disk/by-label/nixos /mnt
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
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

ssh root@${TARGET} mkdir -p /var/acme/certificates

ssh root@${TARGET} nixos-install

# acme user exists after nixos-install
ssh root@${TARGET} openssl dhparam -out /etc/ssl/dhparams.pem 3072
ssh squirtle "rsync -ta .secrets/acme/certificates/weavile.satstack.net.* --rsync-path='sudo -u acme rsync' root@weavile:/var/acme/certificates/"
ssh root@${TARGET} "chmod 640 /var/acme/certificates/${TARGET}.${TARGET_DOMAIN}.*"
