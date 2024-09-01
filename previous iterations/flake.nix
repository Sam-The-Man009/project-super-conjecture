{
  inputs = {
    # Nixpkgs: The Nix Packages collection.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager: Manage user-specific configurations.
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure consistent nixpkgs version
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      deviceTypes = ["master" "node" "user"];
      deviceType.master = "./hosts/master/";
      deviceType.user = "./hosts/user/";
      deviceType.node = "./hosts/node/";
      system = "x86_64-linux";
      commonModules = [
        ./common.nix
        ./hardware-configuration.nix
        ./users.nix
        ./wireGuard #this one doesn't make sense for user...
      ];
    in
    {
      nixosConfigurations = {
        master = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [
            ${master}/configuration.nix
            ${master}/pkgs.nix
            ${master}/services.nix
          ];
        };

        regular = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [
            ${node}/configuration.nix
            ${node}/pkgs.nix
            ${node}/services.nix
          ];
        };

        user = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = commonModules ++ [
            ${user}/configuration.nix
            ${user}/pkgs.nix
            ${user}/services.nix
          ];
        };
      };

      homeConfigurations = {
        master = home-manager.lib.homeManagerConfiguration {
          inherit system;
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ${master}/home.nix
          ];
        };

        node = home-manager.lib.homeManagerConfiguration {
          inherit system;
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ${node}/home.nix
          ];
        };

        user = home-manager.lib.homeManagerConfiguration {
          inherit system;
          pkgs = import nixpkgs { inherit system; };
          modules = [
            ${user}/home.nix
          ];
        };
      };
    };
}
