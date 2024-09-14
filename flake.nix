{
  description = "My NixOS configuration flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";  # Specify your target system architecture
      pkgs = import nixpkgs { inherit system; };

      systemNames = [
        "sys1" "sys2" "sys3" "sys4" "sys5" "sys6" "sys7" "sys8" "sys9" "sys10" "sys11" "sys12" "sys13" "sys14" "sys15" "sys16" "sys17" "sys18" "sys19" "sys20" "sys21" "sys22" "sys23" "sys24" "sys25"
      ];

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

      generateConfig = systemName: systemType: {
        # Define the configuration for a specific systemName and systemType
        pkgs.nixosSystem {
          system = "x86_64-linux";  # Specify your target system architecture
          modules = [
            # Minimal example to include in the configuration
            ({ config, pkgs, ... }: {
              imports = [
                # Any necessary imports
              ];
              hostname = "${systemName}-${systemType}";
              # Include any default settings or modules here
              environment.systemPackages = with pkgs; [ wget vim ]; # Example
            })
            # Include your configuration files and modules
            # You may need to adjust this based on your actual module paths
            (let
              hostType = types.${systemType} // {
                imports = [];
                homeManager = {};
              };
            in {
              imports = [ hostType.imports ];
              hostname = "${systemName}-${systemType}";
              modules = [ home-manager.nixosModules.home-manager hostType.homeManager ];
            })
          ];
        }
      };

    in {
      nixosConfigurations = builtins.listToAttrs (
        builtins.concatMap (systemName:
          builtins.map (systemType: {
            name = "${systemName}-${systemType}";
            value = generateConfig systemName systemType;
          }) (builtins.attrNames types)
        ) systemNames
      );
    };
}
