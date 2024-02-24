{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings = {
    extra-experimental-features = "nix-command flakes";
    accept-flake-config = true;
    auto-optimise-store = true;
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
    # ensureDatabases = [ "sm" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      host  all      sm          127.0.0.1/32   scram-sha-256
      host  all      sm          ::1/128        scram-sha-256
      local all      sm                         scram-sha-256

      local all      postgres                   trust
      local all      root                       trust
    '';
    initialScript = pkgs.writeText "init-sql-script" ''
      CREATE USER sm WITH SUPERUSER ENCRYPTED PASSWORD '1234';
    '';
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.wget
    pkgs.google-chrome
    pkgs.vscode
    pkgs.nodejs_18
    pkgs.corepack_18
    pkgs.go
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
    (pkgs.writeShellScriptBin "make" ''nix-shell --impure -p stdenv --command "make $@"'')
    (pkgs.writeShellScriptBin "gcc" ''nix-shell --impure -p stdenv --command "gcc $@"'')
  ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH            = [ "${XDG_BIN_HOME}" ];
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
  programs.nix-ld.enable = true;

  system.stateVersion = "23.11";

}
