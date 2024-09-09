{
  description = "Dynamic NixOS configuration distributior for heterogeneous systems, combining role-based defaults with host-specific customizations. For purposes of global domination and computing aggregation.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
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

      splitInput = input: let
        parts = builtins.split "-" input;  # Split input like "sysn-master" into ["sysn", "master"].
        systemName = builtins.head parts;  
        systemType = builtins.getAttr 1 parts // "user";  
      in { systemName = systemName; systemType = systemType; };

      
      generateConfigs = systemName: systemType: {
        name = "${systemName}-${systemType}";  # Construct a key like "sys1-user". following the naming convention "sys-type"
        value = let
          hostType = types.${systemType} // {
            imports = [];  
            homeManager = {};  
          };
        in
          {
            imports = [ hostType.imports ]; 
            hostname = "${systemName}-${systemType}";  

            modules = [ home-manager.nixosModules.home-manager hostType.homeManager ];

          };
      };

      builtins.trace "nixosConfigurations"
      nixosConfigurations = builtins.listToAttrs (
        builtins.concatMap (systemName:
          builtins.map (systemType: {
            name = "${systemName}-${systemType}";
            value = generateConfigs systemName systemType;
          }) (builtins.attrNames types)
        ) systemNames
      );


    in
    {
      nixosConfigurations = nixosConfigurations;
    };
}
