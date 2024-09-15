{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./bootloader.nix
    ./users.nix
    ./wireGuard.nix
  ];
    
   
  time.timeZone = "Europe/Berlin";  # Add other required settings
  networking.networkmanager.enable = true;
  time.timeZone = lib.mkDefault "Europe/Copenhagen";  
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk-latin1";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}