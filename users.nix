{ pkgs, ... }:

let  
  name = "${systemName}-${systemType}";
  isNormalUser = true;
  description = "User for ${systemName}-${systemType}";
  extraGroups = [ "wheel" "networkmanager" ]; 
  homeDir = "/home/${systemType}";
  shell = pkgs.zsh;

in {
  user = {
    name = name;
    isNormalUser = isNormalUser;
    extraGroups = extraGroups;
    home = homeDir;
    shell = shell;
  };
}
