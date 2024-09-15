{ config, pkgs, ... }:
{

  options = {
    ssh.port = lib.mkOption {
      type = lib.types.int;
      default = 314159265359;
      description = "The SSH port number";
    };
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ config.ssh.port ]; 
  };

  services = {
      xserver = {
        enable = true;
        windowManager.awesome = {
          enable = true;
        };
      };

    openssh = {
      enable = true;
      permitRootLogin = "no"; 
      passwordAuthentication = true; 
      port = config.ssh.port; 
    };

  };

}