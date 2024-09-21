{
  description = "Dynamic NixOS configuration flake for heterogeneous systems.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    systemArchitechture = "x86_64-linux";
    pkgs = import nixpkgs { system = systemArchitechture; };

    # Function to generate configuration for a specific system and its type
    generateConfig = system: {
      name = "${system.name}-${system.type}";  # Construct a key like "sys1-user". following the naming convention "sys-type"
      value = pkgs.nixosSystem {
        system = system.Architechture;
        modules = [
          (import ./common.nix)


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
      { name = "sysDefault"; type = "user"; Architechture = "x86_64-linux"; }
      { name = "sys1"; type = "master"; Architechture = "x86_64-linux"; }
      { name = "sys2"; type = "node"; Architechture = "x86_64-linux"; }
      { name = "sys3"; type = "node"; Architechture = "x86_64-linux"; }
      { name = "sys4"; type = "node"; Architechture = "x86_64-linux"; }
      { name = "sys5"; type = "master"; Architechture = "x86_64-linux"; }
      { name = "sys6"; type = "node"; Architechture = "x86_64-linux"; }
      { name = "sys7"; type = "node"; Architechture = "x86_64-linux"; }
      { name = "sys8"; type = "node"; Architechture = "x86_64-linux"; }
      { name = "sys9"; type = "node"; Architechture = "x86_64-linux"; }
      { name = "sys10"; type = "master"; Architechture = "x86_64-linux"; }
    ];


    getCurrentSystem = builtins.getEnv "SYSTEM_NAME" or "sysDefault";  # Default to 'sysDefault'


    matchingSystem = builtins.head (builtins.filter (system:
      system.name == getCurrentSystem
    ) systems) or (builtins.head (builtins.filter (system: system.name == "sysDefault") systems));

  in {
    nixosConfigurations = {
      inherit (generateConfig matchingSystem) value;
    };
  };
}
