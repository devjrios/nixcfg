{
  imports = [
    ./nix.nix
    ./bootloader.nix
    ./locale.nix
    ./system-packages.nix
    ./desktop.nix
    ./dev-services.nix
    ./kernel-cfg.nix
    ./gfx-nvidia.nix
  ];
  environment.shellAliases.sudo = "doas";
  security = {
    rtkit.enable = true;
    sudo.enable = false;
    doas = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
