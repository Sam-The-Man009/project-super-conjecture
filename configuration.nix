{ config, pkgs, ... }:

let
  system = builtins.currentSystem;

  # Retrieve the current username from the environment
  username = builtins.getEnv "USER";  # assumes the environment variable USER is set
  
  # List of valid system names
  systemNames = [
    "sys1" "sys2" "sys3" "sys4" "sys5" "sys6" "sys7" "sys8" "sys9" "sys10"
    "sys11" "sys12" "sys13" "sys14" "sys15" "sys16" "sys17" "sys18" "sys19"
    "sys20" "sys21" "sys22" "sys23" "sys24" "sys25"
  ];

  # Definition of types
  types = {
    master = { config, pkgs, ... }: {
      imports = import ./types/master/imports.nix { inherit config pkgs; };
      homeManager = import ./types/master/home.nix;
    };

    node = { config, pkgs, ... }: {
      imports = import ./types/node/imports.nix { inherit config pkgs; };
      homeManager = import ./types/node/home.nix;
    };

    user = { config, pkgs, ... }: {
      imports = import ./types/user/imports.nix { inherit config pkgs; };
      homeManager = import ./types/user/home.nix;
    };
  };

  # Split the username into systemName and systemType
  parts = builtins.split "-" username;

  # Check if the username is correctly split into two parts
  _ = assert builtins.length parts == 2
    "Username must be in the format 'systemName-systemType'.";

  systemName = builtins.elemAt parts 0;  # First part is systemName
  systemType = builtins.elemAt parts 1;  # Second part is systemType

  # Assertions to validate that systemName and systemType are valid
  _ = assert builtins.elem systemName systemNames;
    "Invalid systemName: ${systemName}. It must be one of ${systemNames}.";
  
  _ = assert builtins.hasAttr systemType types;
    "Invalid systemType: ${systemType}. It must be one of ${builtins.attrNames types}.";

  # Generate the configuration based on systemName and systemType
  generateConfig = {
    imports = [
      ./common.nix
      ./types/${systemType}/imports.nix
      ./types/${systemType}/home.nix
    ];

    hostname = "${systemName}-${systemType}";
    networking.hostName = "${systemName}-${systemType}";
  };

in {
  imports = [ generateConfig ];
}
