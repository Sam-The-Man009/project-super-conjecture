{ pkgs, environment, ... }:
{
environment.systemPackages = with pkgs; [
    # basic tools
    vim
    nano
    git
    openssh
    gparted
    xgd-user-dirs

    # megacomputer tooling
    kubernetes
    docker
    docker-compose
    ceph
    ceph-client
    prometheus
    grafana
    elk-stack


    # nvidia bs
    cuda
    cudatoolkit
    nvidia-xconfig
  ];
}