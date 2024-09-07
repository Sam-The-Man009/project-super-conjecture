{
  description = "Dynamic NixOS configuration for heterogeneous systems";

  inputs = {
    # Nixpkgs: The Nix Packages collection.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      systemNames = [
        "sys1" "sys2" "sys3" "sys4" "sys5" "sys6" "sys7" "sys8" "sys9" "sys10"
        "sys11" "sys12" "sys13" "sys14" "sys15" "sys16" "sys17" "sys18" "sys19" "sys20"
        "sys21" "sys22" "sys23" "sys24" "sys25"
      ];

      types = {
        master = { config, pkgs, ... }: {
          nixosConfigurations.master = import ./types/master/imports.nix { inherit config pkgs; };
          homeManagerConfiguration = import ./types/master/home.nix;
        };

        node = { config, pkgs, ... }: {
          nixosConfigurations.node = import ./types/node/imports.nix { inherit config pkgs; };
          homeManagerConfiguration = import ./types/node/home.nix;
        };

        user = { config, pkgs, ... }: {
          nixosConfigurations.user = import ./types/user/imports.nix { inherit config pkgs; };
          homeManagerConfiguration = import ./types/user/home.nix;
        };
      };

    in
    {
      nixosConfigurations = {
        # Dynamically create NixOS configurations for each system
        inherit (types) master node user;
      };

      # Define configurations for each system
      hosts = builtins.listToAttrs (
        builtins.map (systemName: {
          name = systemName;
          value = import ./hosts/${systemName}/unique.nix { inherit systemName nixpkgs home-manager; };
        }) systemNames
      );
    };
}
