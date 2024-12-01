{ lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    eval-cache = false;
    experimental-features = "nix-command flakes";
    accept-flake-config = true;
    auto-optimise-store = true;
    warn-dirty = false;
    fallback = true;

    substituters = lib.mkForce [ "https://nix-community.cachix.org" "https://cache.thalheim.io" ];
    trusted-substituters = lib.mkForce [ "https://nix-community.cachix.org" "https://cache.thalheim.io" ];
    trusted-public-keys = lib.mkForce [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "cache.thalheim.io-1:R7msbosLEZKrxk/lKxf9BTjOOH7Ax3H0Qj0/6wiHOgc=" ];

    trusted-users = [ "@wheel" "root" "jrios" ];
    builders-use-substitutes = true;

    http-connections = 128;
    max-substitution-jobs = 128;
    connect-timeout = 5;
    max-jobs = "auto";
    log-lines = 25;

    # Make legacy nix commands use the XDG base directories instead of creating directories in $HOME.
    use-xdg-base-directories = true;
  };
}
