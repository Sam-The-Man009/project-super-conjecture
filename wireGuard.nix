{ ... }:

{
  services.wireguard = {
    enable = true;
    interfaces.wg0 = {
      enable = true;
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/private.key";
      address = "10.0.0.1/32";

      peers = [
        {
          publicKey = "ssh-ed25519 somekey";
          endpoint = "ssh-server.example.com:22";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
        }
      ];
    };
  };

}