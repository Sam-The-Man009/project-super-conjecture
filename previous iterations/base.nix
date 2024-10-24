{ config, pkgs, ... }:

{
  

  boot = {
    loader = {
      systemd-boot = {
        enable = false;
        # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
        editor = false;
      };
      timeout = 10;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "/dev/sda";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 8;
        theme =
          pkgs.fetchFromGitHub
          {
            owner = "Lxtharia";
            repo = "minegrub-theme";
            rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
            sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
          };
      };
    };
  };

  # Basic system settings
  system.stateVersion = "23.11"; 
  
  networking.hostName = "VM";

  # Define an option for the SSH port. yes this is how you define a local variable in nix. this language is a beautiful language.
  options = {
    ssh.port = lib.mkOption {
      type = lib.types.int;
      default = 314159265359;
      description = "The SSH port number";
    };
  };

  users.users.dio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable sudo
    shell = pkgs.zsh;
    home = "/home/dio";
  };

 

 

  time.timeZone = lib.mkDefault "Europe/Copenhagen";  
  i18n.defaultLocale = "en_DK.UTF-8";

  networking.networkmanager.enable = true;
  
  console.keyMap = "dk-latin1";


  nixpkgs.config.allowUnfree = true;

  # heres the packages (:
  environment.systemPackages = with pkgs; [
    # basic tools
    vim
    nano
    git
    openssh
    gparted
    xgd-user-dirs
    librewolf
    dmenu
    alacritty
  ];

  services.xserver.enable = true;
  services.xserver.windowManager.awesome.enable = true;


}
