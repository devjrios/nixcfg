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
  networking.resolvconf.dnsSingleRequest = true;
  networking.networkmanager.wifi.powersave = false;

  programs.zsh.enable = true;
  services.fwupd.enable = true;
  programs.nix-ld.enable = true;
  # programs.dconf.enable = false;

  networking.extraHosts = ''
  192.168.10.70 nepqas.medellin.gov.co
  '';

  system.stateVersion = "23.11";
}
