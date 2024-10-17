{ pkgs, ... }:

let  
    name = "${systemName}-${systemType}";
    isNormalUser = true;
    description = "User for ${systemName}-${systemType}";
    extraGroups = [ "wheel" "networkmanager" ]; 
    home = "/home/${systemName}-${systemType}";
    shell = pkgs.zsh;

in {
  # Add all the generated users to the configuration
  users.users = builtins.listToAttrs (builtins.map (user: {
    name = user.name;
    value = user;
  }) validUserConfigurations);
}