{
  description = "Verify nixosSystem availability";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";  # Specify your target system architecture
      pkgs = import nixpkgs { system = system; };

      # Test if pkgs.nixosSystem is available
      nixosSystemAvailable = builtins.tryEval pkgs.nixosSystem;
    in {
      defaultPackage.x86_64-linux = pkgs.writeText "check-nixosSystem" (
        if nixosSystemAvailable == null then "nixosSystem not available" else "nixosSystem is available"
      );
    };
}
