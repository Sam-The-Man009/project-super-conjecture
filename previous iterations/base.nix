{ config, pkgs, ... }:

{
  # Enable the GRUB bootloader with EFI support
  boot.loader.grub.config = ''
  if $SSH_CONNECTION; then
    quiet_mode=0
  else
    quiet_mode=1
  fi
'';

  boot.loader.grub.config = "GRUB_TIMEOUT=0";
  boot.loader.grub.quiet_mode = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.devices = [ "nodev" ]; #change the nodev
  boot.loader.grub.useOSProber = true;

  # Basic system settings
  system.stateVersion = "23.05"; 
  
  networking.hostName = "Denmark-west";


 

  # Define an option for the SSH port. yes this is how you define a local variable in nix. this language is a beautiful language.
  options = {
    ssh.port = lib.mkOption {
      type = lib.types.int;
      default = 314159265359;
      description = "The SSH port number";
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no"; 
    passwordAuthentication = true; 
    port = config.ssh.port; 
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ config.ssh.port ]; 
  };

 


  users.users.sys1-user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable sudo
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

    # megacomputer tooling
    kubernetes
    docker
    docker-compose
    ceph
    ceph-client
    prometheus
    grafana
    elk-stack


    # nvidia bs
    cuda
    cudatoolkit
    nvidia-xconfig
    


  ];

  services.xserver.enable = true;
  services.xserver.windowManager.awesome.enable = true;


}
