{
  inputs = {
    # Nixpkgs: The Nix Packages collection.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Ensure consistent nixpkgs version

  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      deviceTypes = ["master" "node" "user"];
      deviceConfigFiles = {
        master = "${./hosts/master}/configuration.nix";
        node = "${./hosts/node}/configuration.nix";
        user = "${./hosts/user}/configuration.nix";
      };
      getDeviceOutput = type: {
        config = import self.deviceTypes.${type};
        pkgs = import nixpkgs { inherit system; };
        services = import self.deviceTypes.${type}/services.nix;
      };


      hostConfigFiles = {
        sys1 = "${./host/sys1}/unique.nix";
        sys2 = "${./host/sys2}/unique.nix";
        sys3 = "${./host/sys3}/unique.nix";
        sys4 = "${./host/sys4}/unique.nix";
        sys5 = "${./host/sys5}/unique.nix";
        sys6 = "${./host/sys6}/unique.nix";
        sys7 = "${./host/sys7}/unique.nix";
        sys8 = "${./host/sys8}/unique.nix";
        sys9 = "${./host/sys9}/unique.nix";
        sys10 = "${./host/sys10}/unique.nix";
        sys11 = "${./host/sys11}/unique.nix";
        sys12 = "${./host/sys12}/unique.nix";
        sys13 = "${./host/sys13}/unique.nix";
        sys14 = "${./host/sys14}/unique.nix";
        sys15 = "${./host/sys15}/unique.nix";
        sys16 = "${./host/sys16}/unique.nix";
        sys17 = "${./host/sys17}/unique.nix";
        sys18 = "${./host/sys18}/unique.nix";
        sys19 = "${./host/sys19}/unique.nix";
        sys20 = "${./host/sys20}/unique.nix";
        sys21 = "${./host/sys21}/unique.nix";
        sys22 = "${./host/sys22}/unique.nix";
        sys23 = "${./host/sys23}/unique.nix";
        sys24 = "${./host/sys24}/unique.nix";
        sys25 = "${./host/sys25}/unique.nix";
      };
      getHostConfig = host: {
        config = import self.hosts.${host};
        pkgs = import nixpkgs { inherit system; };
      };

      commonModules = [
        ./common.nix
        ./hardware-configuration.nix
        ./users.nix
        ./wireGuard #this one doesn't make sense for user...
      ];

      
    in
    {


          

      getHost = host: pkgs: commonModules ++ [ (getHostConfig host) ];


      hostsList = map (host: { name = "${host}"; value = getHostConfig host; }) hosts;

      hostConfigs = {
        ${toString(hosts)} = map (host: nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (getHost host pkgs) ];
        }) hosts;
      };

          # Define a function to get the device configuration based on the type
      getDeviceConfig = type: nixpkgs.lib.mkSystem { inherit (nixpkgs) system; } {
        name = "device-${type}";
        modules = [ (import deviceConfigFiles.${type}) ];
      };

      # Create a flake output for each device type
      devices = listToAttrs (map (type: getDeviceConfig type) deviceTypes);


      nixosConfigurations = {
    master = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = commonModules ++ [
        (getDeviceOutput "master")
      ];
    };

    regular = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = commonModules ++ [
        (getDeviceOutput "node")
      ];
    };

    user = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = commonModules ++ [
        (getDeviceOutput "user")
      ];
    };
  };

    homeConfigurations = {
      master = home-manager.lib.homeManagerConfiguration {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
        modules = [
          (getDeviceOutput "master").home.nix
        ];
      };

      node = home-manager.lib.homeManagerConfiguration {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
        modules = [
          (getDeviceOutput "node").home.nix
        ];
      };

      user = home-manager.lib.homeManagerConfiguration {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
        modules = [
          (getDeviceOutput "user").home.nix
        ];
      };
    };
  }
}
