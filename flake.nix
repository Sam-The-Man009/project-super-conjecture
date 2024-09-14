{
  description = "Dynamic NixOS configuration flake for heterogeneous systems.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";  # Specify your target system architecture
      pkgs = import nixpkgs { system = system; };

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

      # Define a function to generate NixOS configurations
      generateConfig = systemName: systemType: {
        name = "${systemName}-${systemType}";  # Construct a key like "sys1-user"
        value = pkgs.lib.nixosSystem {
          system = system;
          modules = [
            ({ config, pkgs, ... }: {
              imports = [];
              hostname = "${systemName}-${systemType}";
              # Other default settings or configurations here
            })
            (import ./types/${systemType}/imports.nix { inherit config pkgs; })
            (import ./types/${systemType}/home.nix)
          ];
          configuration = {
            # Additional configurations here if needed
            networking.hostName = "${systemName}-${systemType}";
          };
        };
      };

      # Define system names
      systemNames = [
        "sys1" "sys2" "sys3" "sys4" "sys5" "sys6" "sys7" "sys8" "sys9" "sys10"
        "sys11" "sys12" "sys13" "sys14" "sys15" "sys16" "sys17" "sys18" "sys19"
        "sys20" "sys21" "sys22" "sys23" "sys24" "sys25"
      ];

    in {
      nixosConfigurations = builtins.listToAttrs (
        builtins.concatMap (systemName:
          builtins.map (systemType: {
            name = "${systemName}-${systemType}";
            value = generateConfig systemName systemType;
          }) (builtins.attrNames types)
        ) systemNames
      );

      # Default package for testing if nixosSystem is available
      packages.x86_64-linux.default = pkgs.writeText "check-nixosSystem" (
        if pkgs.lib.nixosSystem == null then
          "nixosSystem not available"
        else
          "nixosSystem is available"
      );
    };
}
