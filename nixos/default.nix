{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common
    ./hardware-configuration.nix
    ./battery.nix
  ];

  users.users.jrios = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Juan Rios";
    extraGroups = ["networkmanager" "wheel" "wireshark"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0wYyniHUD5ulERQYCKg2a2D8hV8Bm2pRo3HCQJJedD jrios@ospinternational.com"
    ];
  };

  networking.hostName = "nixos";
  # networking.extraHosts = ''
  #   192.168.10.70 nepqas.medellin.gov.co
  # '';
  # networking.firewall.enable = false;
  networking.firewall = {
    allowedUDPPorts = [ 5353 1688 ]; # For device discovery
    allowedUDPPortRanges = [{ from = 32768; to = 61000; }]; # For Streaming
    allowedTCPPorts = [ 8010 1688 ];  # For gnomecast server
  };
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

  programs.wireshark.enable = true;
  programs.zsh.enable = true;
  services.fwupd.enable = true;
  programs.nix-ld.enable = true;
  programs.dconf.enable = true;
  system.stateVersion = "23.11";
}
