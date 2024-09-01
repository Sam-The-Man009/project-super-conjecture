{ config, pkgs, ... }:

let
  username = builtins.getEnv "USER";
  userConfigs = if username == "master" then /etc/nixos/master
                else if username == "node" then /etc/nixos/node
                else /etc/nixos/user;
in
{
  imports = [
    ./hardware-configuration.nix
    ./common.nix
    ./bootloader.nix
    # Import user-specific configurations
    "${userConfigs}/configuration.nix"
    "${userConfigs}/packages.nix"
    "${userConfigs}/services.nix"
  ];

  # Shared configuration (if any)
  system.stateVersion = "23.05"; 
  networking.hostName = "Denmark-west";
  networking.networkmanager.enable = true;
  time.timeZone = lib.mkDefault "Europe/Copenhagen";  
  i18n.defaultLocale = "en_DK.UTF-8";
  
  

  
  console.keyMap = "dk-latin1";
  
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  
}
