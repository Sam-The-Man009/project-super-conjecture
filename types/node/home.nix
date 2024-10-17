{ pkgs, config, ... }: {

homeManager.users.currentUser = let
    homeDirectory = "/home/user";  
  in {
  homeManager.users.node = {
    home = {
    homeDirectory = homeDirectory;
    packages = [ 
      pkgs.git
      pkgs.zsh
    ];
    username = "node";
  };



    programs.zsh = {
      enable = true;
      sessionInit = "source ${home.homeDirectory}/.zshrc";
      
      aliases = {
        sys-rebuild = "sudo nixos-rebuild switch --flake /path/to/nixos-config";
        home-rebuild = "sudo home-manager switch --flake /path/to/home-manifest#denmarkWest";
      };
    };

    # Ensure ~/.zshrc exists and set its properties
      home.file.".zshrc" = {
        text = ''
          export EDITOR="nvim"
          export PATH=$PATH:$HOME/.local/bin
        '';
        owner = "node";
        group = "users";
        mode = "0644"; 
      };
  };
};
}