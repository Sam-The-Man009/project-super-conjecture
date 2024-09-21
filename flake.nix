{
  description = "Dynamic NixOS configuration distributor for heterogeneous systems, combining role-based defaults with host-specific customizations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    systemArchitecture = "x86_64-linux";
    pkgs = import nixpkgs { system = systemArchitecture; };
    lib = nixpkgs.lib;

    # Function to generate configuration for a specific system and its type
    generateConfig = config: system: {
      name = "${system.name}-${system.type}";
      value = lib.nixosSystem {
        system = system.Architecture;
        modules = [
          (import ./common.nix { inherit config pkgs; })
          (import ./types/${system.type}/imports.nix { inherit config pkgs; })
          (import ./types/${system.type}/home.nix { inherit config pkgs; })

          # is this the anonymous lambda?
          ({ config, pkgs, ... }: {
            imports = [];
            hostname = "${system.name}";
            networking.hostName = "${system.name}";
          })
        ];
      };
    };


  systems = [
    { name = "sysDefault"; type = "user"; Architecture = "x86_64-linux"; }
    { name = "sys1"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys2"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys3"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys4"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys5"; type = "master"; Architecture = "x86_64-linux"; }
    { name = "sys6"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys7"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys8"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys9"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys10"; type = "master"; Architecture = "x86_64-linux"; }
    { name = "sys11"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys12"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys13"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys14"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys15"; type = "master"; Architecture = "x86_64-linux"; }
    { name = "sys16"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys17"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys18"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys19"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys20"; type = "master"; Architecture = "x86_64-linux"; }
    { name = "sys21"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys22"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys23"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys24"; type = "node"; Architecture = "x86_64-linux"; }
    { name = "sys25"; type = "master"; Architecture = "x86_64-linux"; }
  ];


    # Get the current system name from the environment or default to 'sysDefault'
    getCurrentSystem = let
      envValue = builtins.getEnv "SYSTEM_NAME";
    in
      if envValue != "" then envValue else "sysDefault";

    # Filter the system list to find the matching system or default to 'sysDefault'
    matchingSystem = let
      filteredSystems = builtins.filter (system: system.name == getCurrentSystem) systems;
    in
      if builtins.length filteredSystems != [] 
      then builtins.head filteredSystems 
      else builtins.head (builtins.filter (system: system.name == "sysDefault") systems);

  in {
    nixosConfigurations = {
      "${matchingSystem.name}" = (generateConfig config matchingSystem).value;
    };
  };
}
