#!/bin/bash
set -e
set -x
# Requires root ssh access to target machine
TARGET=chesnaught

EFI_DISK ()
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
BIOS_DISK ()
{
    dd if=/dev/zero count=1 bs=2M of=/dev/sda
    parted /dev/sda mklabel gpt
    parted /dev/sda mkpart primary 1MB 100%
    parted /dev/sda set 1 boot on
    mkfs.ext4 -L nixos /dev/sda1
    mount /dev/disk/by-label/nixos /mnt
    nixos-generate-config --root /mnt
    mkdir -p /mnt/etc/nixos/ssh
}

echo "Install NixOS on ${TARGET}? Press enter to continue or ctrl+c to quit."
read

ssh root@${TARGET} "$(typeset -f EFI_DISK); EFI_DISK"
rsync -tv configuration.nix root@${TARGET}:/mnt/etc/nixos/
rsync -v ~/.ssh/authorized_keys root@${TARGET}:/etc/nixos/ssh/
ssh root@${TARGET} nixos-install