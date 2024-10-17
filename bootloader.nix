{ config, pkgs, ... }:
{
# Enable the GRUB bootloader with EFI support
#  boot.loader.grub.config = ''
#  if $SSH_CONNECTION; then
#    quiet_mode=0
#  else
#    quiet_mode=1
#  fi
#'';

#  boot.loader.grub.config = "GRUB_TIMEOUT=0";
#  boot.loader.grub.quiet_mode = true;
#  boot.loader.grub.enable = true;
#  boot.loader.grub.version = 2;
#  boot.loader.grub.efiSupport = true;
#  boot.loader.grub.efiInstallAsRemovable = true;
#  boot.loader.efi.canTouchEfiVariables = true;
#  boot.loader.grub.devices = [ "nodev" ];
#  boot.loader.grub.useOSProber = true;





  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.devices = [ "/dev/sda" ];
  boot.loader.grub.useOSProber = true;


}
