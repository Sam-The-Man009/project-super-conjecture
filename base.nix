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
  system.stateVersion = "23.05"; # Set this to the NixOS version you are using
  networking.hostName = "Denmark-west"; # Set your hostname


 

  # Define an option for the SSH port
  options = {
    ssh.port = lib.mkOption {
      type = lib.types.int;
      default = 314159265359;
      description = "The SSH port number";
    };
  };

  # Use the defined variable in your configuration
  services.openssh = {
    enable = true;
    permitRootLogin = "no"; # Disallow root login for security
    passwordAuthentication = true; # Allow password-based login
    port = config.ssh.port; # Use the defined option value
  };

  # Enable firewall and allow SSH (if firewall is used)
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ config.ssh.port ]; # Open port for SSH
  };

 


  # Create a minimal user
  users.users.HL_Node = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable sudo
    hashedPassword = "4b52f55fd458d57b645cd85bcbf1ad5b3628fa07add9b0e93e3fec5ca621c14a"; # Replace with your hashed password
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3Nza... your_key_comment" # Replace with your public key
    ];
  };

 

 

  # Set timezone and locale
  time.timeZone = lib.mkDefault "Europe/Copenhagen";  # Change this to your local timezone if needed
  i18n.defaultLocale = "en_DK.UTF-8";

  # Enable NetworkManager for basic networking
  networking.networkmanager.enable = true;

  # Supports danish keyboard
  console.keyMap = "dk-latin1";


  # allows propreitary packages. such as nvidia support
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
