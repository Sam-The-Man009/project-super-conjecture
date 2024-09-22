{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./bootloader.nix
    ./users.nix
    ./wireGuard.nix
  ];
    
   
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Copenhagen";  
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk-latin1";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "ext4";  # Change to your filesystem type
  };
}