{  pkgs, lib, ... }:
let 
  uuid = builtins.exec "bash" "-c" "blkid -s UUID -o value \$(findmnt -n -o SOURCE /)";
in 
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./bootloader.nix
    #./users.nix { inherit pkgs; }
    ./wireGuard.nix
    ./conjecture-utils.nix
  ];
    
   
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Copenhagen";  
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk-latin1";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  
  # Fetch the UUID of the root filesystem
  
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "ext4";
  };
  system.stateVersion = "24.11";
}