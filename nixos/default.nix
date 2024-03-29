{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings = {
    # for nix-direnv
    # keep-outputs = true;
    # keep-derivations = true;

    extra-experimental-features = "nix-command flakes";
    accept-flake-config = true;
    auto-optimise-store = true;
    warn-dirty = false;
    # fallback = true;

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
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jrios = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Juan Rios";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.systemd-boot.configurationLimit = 2;
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Bogota";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Comment this out when switching to bare metal
  virtualisation.vmware.guest.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap - <<'EOF'
    clear lock
    keycode 66 = Home NoSymbol Home
    EOF
  '';
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.enableAllFirmware = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    settings = {
      max_prepared_transactions = 3;
    };
    # ensureDatabases = [ "sm" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      host  all      sm          127.0.0.1/32   scram-sha-256
      host  all      sm          ::1/128        scram-sha-256
      local all      sm                         scram-sha-256

      host  all      test        127.0.0.1/32   scram-sha-256
      host  all      test        ::1/128        scram-sha-256
      local all      test                       scram-sha-256

      local all      postgres                   trust
      local all      root                       trust
    '';
    initialScript = pkgs.writeText "init-sql-script" ''
      CREATE USER sm WITH SUPERUSER ENCRYPTED PASSWORD '1234';
    '';
  };

  services.rsyncd.enable = true;
  services.rsyncd.settings = {
    ftp = {
      gid = 100;
      uid = 1000;
      comment = "Home config";
      path = "/home/jrios/";
      list = true;
      "read only" = false;
    };
    global = {
      "hosts allow" = "*";
      gid = "nobody";
      "max connections" = 4;
      uid = "nobody";
      "use chroot" = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.wget
    pkgs.google-chrome
    pkgs.nodejs_18
    pkgs.corepack_18
    pkgs.texliveFull
    pkgs.quarto
    pkgs.openconnect
    pkgs.insomnia
    pkgs.htop
    pkgs.fd
    pkgs.ripgrep
    pkgs.pandoc
    pkgs.librsvg
    pkgs.moreutils
    pkgs.editorconfig-core-c
    pkgs.xclip
    pkgs.unzip
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

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf
      unifont
      noto-fonts-color-emoji
      wine64Packages.fonts
      corefonts
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "VictorMono" ]; })
    ];
    fontconfig = {
      localConf = ''
        <alias>
          <family>Glorious Monospaced Shell</family>
          <prefer>
            <family>Comic Code</family>
            <family>Comic Code Ligatures</family>
            <family>Symbols Nerd Font Mono</family>
            <family>Noto Color Emoji</family>
          </prefer>
        </alias>
      '';
    };
  };

  programs.zsh.enable = true;
  programs.partition-manager.enable = true;
  programs.nix-ld.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 873 ];
  };

  system.stateVersion = "23.11";

}
