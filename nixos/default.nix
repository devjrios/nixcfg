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
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  networking.resolvconf = {
    enable = true;
    dnsSingleRequest = true;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn.overrideAttrs(previousAttrs: {
      name = "mullvad-vpn-2024-08";
      src = pkgs.fetchFromGitHub {
        owner = "mullvad";
        repo = "mullvadvpn-app";
        # release 2024.8 merge hash in main
        rev = "40f2934bde775d3dbf17429abe0be26fd6e24997";
        hash = "sha256-1t7utA/O6SU1+QncZnQac/oY5Hg4+H+5GOoDDhH4ce4=";
      };
    });
  };

  programs.zsh.enable = true;
  services.fwupd.enable = true;
  programs.nix-ld.enable = true;
  programs.dconf.enable = true;
  system.stateVersion = "23.11";
}
