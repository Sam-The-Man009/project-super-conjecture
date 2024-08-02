#!/bin/bash

# Variables
DISK="/dev/sda"
EFI_PART_LABEL="EFI"
LINUX_PART_LABEL="Windows Extended Utilities"
LINUX_PART_SIZE="30GiB"
SHRINK_SIZE="34GiB"
# SWAP_PART_LABEL="MicroSoft Virtual Memory"
SWAP_PART_SIZE="4GiB"

NIXOS_CONFIG="configuration.nix"
USB_LABEL="NixOS" # we change this later
MOUNT_POINTS=("/media" "/mnt" "/run/media")

echo -e "Setting up variables.\n $DISK, $EFI_PART_LABEL, $LINUX_PART_LABEL, \n $LINUX_PART_SIZE, $SHRINK_SIZE, $SWAP_PART_LABEL, $SWAP_PART_SIZE"

MAIN_PART=$(lsblk -no NAME,FSTYPE | grep ntfs | awk '{print "/dev/" $1}' | head -n 1)


echo "Done."

echo "Unmount the first ntfs partition (hopfully windows)"
umount $MAIN_PART || echo "$MAIN_PART is not mounted, proceeding."
echo "Done."

echo "Shrinking $MAIN_PART to free up $SHRINK_SIZE..."
parted $MAIN_PART resizepart 1 -$SHRINK_SIZE
echo "Done."


partprobe $DISK

echo "Creating the EFI partition"
EXISTING_EFI=$(parted $DISK --script print | grep -i "esp")
if [ -z "$EXISTING_EFI" ]; then #checks if the variable is empty
  EFI_PART_END="512MiB" 
  parted $DISK -- mkpart primary fat32 1MiB $EFI_PART_END 
  parted $DISK -- set 1 boot on
  mkfs.fat -F 32 -n $EFI_PART_LABEL ${DISK}1
else
  echo "EFI partition already exists, skipping creation."
fi
echo "Done."




echo "Creating swap partition..."
if ! swapon --show | grep -q '/dev/sd'; then
  
  
  
  END_POS=$(parted $DISK --script print free | grep "Free Space" | awk '{print $1}'| tail -n 1)
  
  
  parted $DISK --script mkpart primary linux-swap "$END_POS" "$SWAP_PART_SIZE"
  echo "$(parted $DISK --script print free)"
  echo "Done."
  


  echo "Formatting the swap partition..."
  
  echo "identifying swap partition number"
  SWAP_PART_NUM=$(parted $DISK --script print | grep linux-swap | awk '{print $1}' | tail -n 1)
  mkswap ${DISK}${SWAP_PART_NUM}
  echo "Done."

  echo "Enabling swap..."
  swapon ${DISK}${SWAP_PART_NUM}
  echo "Done."

  echo "Adding swap partition to fstab..."
  echo "${DISK}${SWAP_PART_NUM} none swap sw 0 0" >> /mnt/etc/fstab || echo "Failed to add swap partition to fstab."
  echo "Done."

else
  echo "Existing swap partition found. Skipping creation."
fi


echo "Determining the start point for the new Linux partition"
START_POS=$(parted $DISK --script print free | grep "Free Space" | tail -n 1 | awk '{print $1}')
echo "Done."

echo "Creating the Linux partition"
parted $DISK -- mkpart primary ext4 $START_POS $LINUX_PART_SIZE
echo "Done."


echo "Formating the new Linux partition"
LINUX_PART_NUM=$(parted $DISK --script print | grep ext4 | awk '{print $1}')
mkfs.ext4 -L $LINUX_PART_LABEL ${DISK}${LINUX_PART_NUM}
echo "Done."

echo "Mounting the partitions"
mount ${DISK}${LINUX_PART_NUM} /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot
echo "Done."


e2label ${DISK}${LINUX_PART_NUM} $LINUX_PART_LABEL


echo "Generating NixOS configuration"
nixos-generate-config --root /mnt
echo "Done."


FILE_PATH=""

# this part is chatGPT voodoo magic.
FILE_PATH=""

# Iterate over each possible mount point
for MOUNT_POINT in "${MOUNT_POINTS[@]}"; do
    if [ -d "$MOUNT_POINT" ]; then
        # Search for directories under the mount point
        for dir in "$MOUNT_POINT"/*; do
            if [ -d "$dir" ] && [ "$(basename "$dir")" == "$USB_LABEL" ]; then
                USB_DIR="$dir"
                # Locate the file within the USB directory
                FILE_PATH=$(find "$USB_DIR" -name "$NIXOS_CONFIG" -print -quit 2>/dev/null)
                if [ -n "$FILE_PATH" ]; then
                    echo "Found $NIXOS_CONFIG at: $FILE_PATH"
                    break 2
                fi
            fi
        done
    fi
done
# end of chatGPT voodoo magic

if [ -z "$FILE_PATH" ]; then # Check if the variable is empty
    echo "Error: $NIXOS_CONFIG not found. Please check your USB drive and mount points."
    echo "Critical Error. Exiting."
    exit 1
else
    echo "Copying $NIXOS_CONFIG to /mnt/etc/nixos"
    cp "$FILE_PATH" /mnt/etc/nixos/configuration.nix
    echo "Done."

    echo "Running nixos-install"
    nixos-install
    echo "Done."
fi




printf "Partitioning, formatting complete, and labeling complete. You can now proceed with your Linux installation. \n Rebooting now..."


shutdown -r +0