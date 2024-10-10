{
  description = "Dynamic NixOS configuration distributor for heterogeneous systems, combining role-based defaults with host-specific customizations.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = { self, nixpkgs, home-manager, inputs, ... }: let
    systemArchitecture = "x86_64-linux";
    pkgs = import nixpkgs { system = systemArchitecture; };
    lib = nixpkgs.lib;
    config = import ./common.nix { inherit pkgs lib outputs; };

    # Function to generate configuration for a specific system and its type
    generateConfig = system: config: {
      name = "${system.name}-${system.type}";
      value = lib.nixosSystem {
        system = system.Architecture;
        # extraSpecialArgs = {inherit inputs;};
        modules = [
          (import ./types/${system.type}/imports.nix { inherit config pkgs inputs; })

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.myUser = import ./types/${system.type}/home.nix { inherit config pkgs inputs; };
          }

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
      { name = "sys3"; type = "node"; Architecture = "aarch64-linux"; }
      { name = "sys4"; type = "node"; Architecture = "aarch64-linux"; }
      { name = "sys5"; type = "node"; Architecture = "aarch64-linux"; }
      { name = "sys6"; type = "master"; Architecture = "x86_64-linux"; }
      { name = "sys7"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys8"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys9"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys10"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys11"; type = "master"; Architecture = "x86_64-linux"; }
      { name = "sys12"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys13"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys14"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys15"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys16"; type = "master"; Architecture = "x86_64-linux"; }
      { name = "sys17"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys18"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys19"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys20"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys21"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys22"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys23"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys24"; type = "node"; Architecture = "x86_64-linux"; }
      { name = "sys25"; type = "node"; Architecture = "x86_64-linux"; }

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
      "${matchingSystem.name}" = (generateConfig matchingSystem config).value;
    };
  };
}
