{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./bootloader.nix
    ./users.nix
    ./wireGuard.nix
  ]
    
  
}