{ config, pkgs, ... }:

{
  imports =
    [
      ./common
      ./hardware-configuration.nix
    ];

  users.users.jrios = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Juan Rios";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  programs.zsh.enable = true;
  programs.partition-manager.enable = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = [
    # Webdev
    pkgs.google-chrome
    pkgs.nodejs_18
    pkgs.corepack_18
    pkgs.insomnia

    # For docs
    pkgs.texliveFull
    pkgs.quarto
    pkgs.pandoc

    # System Utils
    pkgs.openconnect
    pkgs.wget
    pkgs.librsvg
    pkgs.moreutils
    pkgs.fd
    pkgs.ripgrep
    pkgs.editorconfig-core-c
    pkgs.htop

    # X11 utils
    pkgs.xclip
    pkgs.unzip

    # Extra tools
    pkgs.libreoffice-qt
    pkgs.vlc

    (pkgs.writeShellScriptBin "make" ''
    args="$@"
    nix-shell --impure -p stdenv --command "make $args"
    '')
    (pkgs.writeShellScriptBin "gcc" ''
    args="$@"
    nix-shell --impure -p stdenv --command "gcc $args"
    '')
  ];

  system.stateVersion = "23.11";
}
