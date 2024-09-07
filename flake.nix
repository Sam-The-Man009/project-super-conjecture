#{ inputs, outputs, ... }:
{
  inputs = {
    # Nixpkgs: The Nix Packages collection.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      systemNames = ["sys1" "sys2" "sys3" "sys4" "sys5" "sys6" "sys7" "sys8" "sys9" "sys10"
        "sys11" "sys12" "sys13" "sys14" "sys15" "sys16" "sys17" "sys18" "sys19" "sys20"
        "sys21" "sys22" "sys23" "sys24" "sys25"];

      types = {
        master = { config, pkgs, ... }: {
          nixosConfigurations.master = import ./types/master/imports.nix { inherit (config) configuration; };
          homeManagerConfiguration = import ./types/master/home.nix;
        };

        node = { config, pkgs, ... }: {
          nixosConfigurations.node = import ./types/node/imports.nix { inherit (config) configuration; };
          homeManagerConfiguration = import ./types/node/home.nix;
        };

        user = { config, pkgs, ... }: {
          nixosConfigurations.user = import ./types/user/imports.nix { inherit (config) configuration; };
          homeManagerConfiguration = import ./types/user/home.nix;
        };
      };

    in
    {
      description = "Dynamic NixOS configuration distributior for heterogeneous systems, combining role-based defaults with host-specific customizations. For purposes of global domination and computing aggregation.";

      imports = [ self.inputs.common ];

      types = types;

      hosts = systemNames.map (systemName: {
        nixosConfigurations.${systemName} = import ./hosts/${systemName}/unique.nix;
        #homeManagerConfiguration = import ./hosts/${systemName}/home.nix;
      });

    }
}