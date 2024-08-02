#!/bin/bash

# Variables
DISK="/dev/sda"
EFI_PART_LABEL="EFI"
LINUX_PART_LABEL="nixos"
EFI_PART_START="1MiB"
EFI_PART_END="512MiB"
LINUX_PART_START="512MiB"
LINUX_PART_END="100%"


parted $DISK -- mklabel gpt # Create a new GPT partition table

# Create the partitions
parted $DISK -- mkpart primary fat32 $EFI_PART_START $EFI_PART_END
parted $DISK -- set 1 boot on
parted $DISK -- mkpart primary ext4 $LINUX_PART_START $LINUX_PART_END

# Format the partitions
mkfs.fat -F 32 -n $EFI_PART_LABEL ${DISK}1
mkfs.ext4 -L $LINUX_PART_LABEL ${DISK}2


mount ${DISK}2 /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot

# Optionally set additional partition labels (not required for basic setups)
e2label ${DISK}2 $LINUX_PART_LABEL

