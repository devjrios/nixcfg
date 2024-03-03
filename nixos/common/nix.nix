{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {

    experimental-features = "nix-command flakes";
    accept-flake-config = true;
    auto-optimise-store = true;
    warn-dirty = false;
    fallback = true;

    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.thalheim.io"
    ];
    trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.thalheim.io"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.thalheim.io-1:R7msbosLEZKrxk/lKxf9BTjOOH7Ax3H0Qj0/6wiHOgc="
    ];

    trusted-users = [ "@wheel" "root" "jrios" ];
    builders-use-substitutes = true;

    http-connections = 128;
    connect-timeout = 5;
    max-jobs = "auto";
    log-lines = 25;
  };
}