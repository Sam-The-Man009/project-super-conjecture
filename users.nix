{ config, pkgs, ... }:

let
  # List of all system names
  systemNames = [
    "sys1" "sys2" "sys3" "sys4" "sys5"
    "sys6" "sys7" "sys8" "sys9" "sys10"
    "sys11" "sys12" "sys13" "sys14" "sys15"
    "sys16" "sys17" "sys18" "sys19" "sys20"
    "sys21" "sys22" "sys23" "sys24" "sys25"
  ];

  # Define the available types
  types = [ "master" "node" "user" ];

  # Generate only users for the "user" type
  userConfigurations = builtins.concatMap (systemName:
    builtins.map (systemType:
      if systemType == "user" then
        {
          name = "${systemName}-${systemType}";
          isNormalUser = true;
          description = "User for ${systemName}-${systemType}";
          extraGroups = [ "wheel" "networkmanager" ];  # Add relevant groups here
          home = "/home/${systemName}-${systemType}";
          shell = pkgs.bash;  # Set default shell
        }
      else null
    ) types
  ) systemNames;

  # Filter out null entries from userConfigurations
  validUserConfigurations = builtins.filter (x: x != null) userConfigurations;

in {
  # Add all the generated users to the configuration
  users.users = builtins.listToAttrs (builtins.map (user: {
    name = user.name;
    value = user;
  }) validUserConfigurations);
}