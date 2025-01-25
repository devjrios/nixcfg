{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common
    ./hardware-configuration.nix
  ];

  users.users.jrios = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Juan Rios";
    extraGroups = ["networkmanager" "wheel"];
  };

  networking.hostName = "nixos";
  # networking.firewall.enable = false;
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  networking.resolvconf = {
    enable = true;
    dnsSingleRequest = true;
  };

  # services.mullvad-vpn = {
  #   enable = true;
  #   package = pkgs.mullvad-vpn;
  # };

  programs.zsh.enable = true;
  services.fwupd.enable = true;
  programs.nix-ld.enable = true;
  programs.dconf.enable = true;
  system.stateVersion = "23.11";
}
