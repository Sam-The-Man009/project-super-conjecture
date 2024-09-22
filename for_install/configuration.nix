{ config, pkgs, ... }:

{
  nix.settings.experimental-features = ["flakes" "nix-command"];

  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    git
    tree
  ];

  # Define your hostname and networking
  networking.hostName = "first-system";
  networking.networkmanager.enable = true;



  users.users.yourusername = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };
  programs.home-manager.enable = true;

  services.xserver.enable = true;
  services.xserver.windowManager.awesome.enable = true;
}
