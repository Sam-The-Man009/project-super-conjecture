{config, pkgs, ...}:
{
  users = {
    master = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; 
      hashedPassword = "4b52f55fd458d57b645cd85bcbf1ad5b3628fa07add9b0e93e3fec5ca621c14a"; # Replace with hashed password
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3Nza... your_key_comment" # Replace with public key
      ];
    };
    node = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; 
      hashedPassword = "4b52f55fd458d57b645cd85bcbf1ad5b3628fa07add9b0e93e3fec5ca621c14a"; # Replace with hashed password
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3Nza... your_key_comment" # Replace with public key
      ];
    };
    user = {
      isNormalUser = true;
      extraGroups = [ "wheel" "disk" "audio" "video"]; 
      hashedPassword = "4b52f55fd458d57b645cd85bcbf1ad5b3628fa07add9b0e93e3fec5ca621c14a"; # Replace with hashed password
    };
  };
}