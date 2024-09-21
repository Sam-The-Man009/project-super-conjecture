{ config, pkgs, ... }:

{
  imports = [
    (import ./pkgs.nix { inherit config pkgs; })
    (import ./services.nix { inherit config pkgs; })
  ];
}
