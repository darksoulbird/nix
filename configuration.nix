{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./locale.nix
    ./packages.nix
  ];

  # ========== KERNEL HARDENING ==========
  boot.kernelParams = [
    "slab_nomerge"
    "init_on_alloc=1"
    "init_on_free=1"
    "pti=on"
    "randomize_kstack_offset=on"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.conf.all.log_martians" = true;

    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.printk" = "3 3 3 3";

    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_rnd_compat_bits" = 16;
  };

  # ========== BOOT ==========
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ========== AUTO UPGRADE ==========
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "04:00";
  };

  # ========== NETEWORK ==========
  networking = {
    hostName = "node";
    networkmanager.enable = true;
    wg-quick.interfaces.wg0.configFile = "/etc/wireguard/wg0.conf";
  };

  # ========== USERS ==========
  users.groups = { common = {}; dialout = {}; };
  users.users.alma = {
    isNormalUser = true;
    description = "Alma";
    extraGroups = [ "wheel" "vboxusers" ];
  };

  # ========== NIX CONFIG ==========
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # ========== DESKTOP AND GRAPHIC SERVER ==========
  services.xserver.enable = true;
  services.xserver.xkb.layout = "latam";
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.wayland = true;

  # ========== PRINTING ==========
  services.printing.enable = false;

  # ========== OPENGL ==========
  hardware.graphics = { enable = true; enable32Bit = false; };

  # ========== VIRTUALIZATION ==========
  virtualisation.virtualbox.host.enable = false;
  virtualisation.virtualbox.host.enableExtensionPack = false;

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # ========== GIT ==========
  programs.git = {
    enable = true;
    config = {
      user.name = "bird";
      user.email = "dark_soul_bird@proton.me";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ========== FONTS ==========
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  # ========== FIREFOX ==========
  programs.firefox.enable = true;

  system.stateVersion = "25.11";
}