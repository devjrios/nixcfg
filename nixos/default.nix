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
  networking.resolvconf.enable = true;
  networking.networkmanager.wifi.powersave = false;

  programs.zsh.enable = true;
  services.fwupd.enable = true;
  programs.nix-ld.enable = true;

  system.stateVersion = "23.11";
}
