{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wireguard-tools
    tree
    gh
    python3
    curl
    wget
    jq
    zip
    unzip
    gnutar
    gzip
    xz
    bzip2
    tmux
    rsync
    ncdu
    btop
  ];
}