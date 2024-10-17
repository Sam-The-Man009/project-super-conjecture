{  pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./bootloader.nix
    #./users.nix { inherit pkgs; }
    ./wireGuard.nix
    ./conjecture-utils.nix
    ../../hardware-configuration.nix
  ];
    
   
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Copenhagen";  
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk-latin1";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  system.stateVersion = "24.11";
}