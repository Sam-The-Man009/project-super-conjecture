{
  description = "Dynamic NixOS configuration flake for heterogeneous systems.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let

    # Function to generate configuration for a specific system and its type
    generateConfig = system: {
      pkgs = import nixpkgs { system = system.system; };
      name = "${system.name}-${system.type}";  # Construct a key like "sys1-user". following the naming convention "sys-type"
      value = pkgs.nixosSystem {
        system = system.system; 
        modules = [
          (import ./common.nix)

          # Import system type-specific configurations
          (import ./types/${system.type}/imports.nix { inherit pkgs; })
          (import ./types/${system.type}/home.nix)

          ({ config, pkgs, ... }: {
              imports = [];
              hostname = "${system.name}";
              networking.hostName = "${system.name}";
          })
        ];
      };
    };

    systems = [
      { name = "sysDefault"; type = "user"; system = "x86_64-linux"; }
      { name = "sys1"; type = "master"; system = "x86_64-linux"; }
      { name = "sys2"; type = "node"; system = "x86_64-linux"; }
      { name = "sys3"; type = "node"; system = "x86_64-linux"; }
      { name = "sys4"; type = "node"; system = "x86_64-linux"; }
      { name = "sys5"; type = "master"; system = "x86_64-linux"; }
      { name = "sys6"; type = "node"; system = "x86_64-linux"; }
      { name = "sys7"; type = "node"; system = "x86_64-linux"; }
      { name = "sys8"; type = "node"; system = "x86_64-linux"; }
      { name = "sys9"; type = "node"; system = "x86_64-linux"; }
      { name = "sys10"; type = "master"; system = "x86_64-linux"; }
    ];

    # Function to get the current system name, assuming an environment variable
    getCurrentSystem = builtins.getEnv "SYSTEM_NAME";  

    # Filter the system list to match the current system
    matchingSystem = builtins.head (builtins.filter (system:
      system.name == getCurrentSystem
    ) systems);

  in {
    nixosConfigurations = if matchingSystem != null then {
      inherit (generateConfig matchingSystem) value;
    } else {
      throw = "Current system '${getCurrentSystem}' is not defined in the system list. Please add it to the 'systems' list using \'export SYSTEM_NAME=sysDefault\'.";
    };
  };
}
