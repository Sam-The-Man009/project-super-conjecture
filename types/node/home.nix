{ pkgs, ... }:
{
  # Define the home manager profile for master host
  home.profile = { ... }: {
    # Create the /home/user directory if it doesn't exist
    home.homeDirectory = "/home/node";

    # Install some packages specific to the master host
    home.packages = [ pkgs.git pkgs.zsh ];

    # Set up the shell to use zsh and enable some features
    programs.zsh = {
    enable = true;
    sessionInit = "source ${home.homeDirectory}/.zshrc";
    aliases = {
      sys-rebuild = "sudo nixos-rebuild switch --flake /path/to/nixos-config#denmarkWest"; # gotta put in the path at some point
      home-rebuild = "sudo home-manager --flake /path/to/home-manifest#denmarkWest switch";
    };
  };


    # Create the ~/.zshrc file if it doesn't exist
    home.file = {
      ".zshrc" = {
        source = "/home/user/.zshrc";
        owner = "root";
        group = "users";
        permissions = "644";
      };
    };

    # Define the content of .zshrc file
    # systemd.user.zshrc = mkIf (fileExists "/home/user/.zshrc") ''
    #   echo 'export EDITOR="nvim"' > /home/user/.zshrc
    #   echo 'export PATH=$PATH:$HOME/.local/bin' >> /home/user/.zshrc
    # '';
  };
}