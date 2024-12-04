{ pkgs, ... }:
{

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # Note to self: For the problem I have,
    # I should adjust ControllerMode, SessionMode and StreamMode
    settings = {
      General = {
        # Restricts all controllers to the specified transport.
        # Default value # is "dual", i.e. both BR/EDR and LE enabled (when supported by the HW).
        # Possible values: "dual", "bredr", "le"
        ControllerMode = "le";
        MultiProfile = "multiple";
        TemporaryTimeout = "30";
        SecureConnections = "off";
        FastConnectable = true;
        JustWorksRepairing = "always";
        Class = "0x010100";
        Privacy = "off";
      };
      GATT = {
        Cache = "no";
      };
      AVDTP = {
        # AVDTP L2CAP Signalling Channel Mode.
        # Possible values:
        # basic: Use L2CAP Basic Mode
        # ertm: Use L2CAP Enhanced Retransmission Mode
        SessionMode = "ertm";
        # AVDTP L2CAP Transport Channel Mode.
        # Possible values:
        # basic: Use L2CAP Basic Mode
        # streaming: Use L2CAP Streaming Mode
        StreamMode = "basic";
      };
    };
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire-pulse = {
      "50-combine-sink.conf" = {
        "pulse.cmd" = [
          {
            cmd = "load-module";
            args = "module-combine-sink";
          }
        ];
      };
    };
    wireplumber.enable = true;
    wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.hfphsp-backend" = "native";
        };
      };

      "11-bluetooth-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };

    };
  };
  nixpkgs.config.pulseaudio = true;
  nixpkgs.config.pipewire = true;

  environment.variables = {
    KWIN_COMPOSE = "N";
    # WIREPLUMBER_DEBUG = "spa.bluez5*:4,pw.context:3";
    # KWIN_DRM_DEVICES="/dev/dri/card1";
  };

  services.xserver.enable = true;
  # programs.xwayland.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };
  environment.systemPackages = [
    pkgs.kdePackages.kdenlive
  ];
  environment.plasma6.excludePackages = [
    pkgs.kdePackages.plasma-browser-integration
    pkgs.kdePackages.konsole
    pkgs.kdePackages.elisa
    pkgs.kdePackages.kate
    pkgs.kdePackages.khelpcenter
    pkgs.kdePackages.xwaylandvideobridge
  ];
  services.xserver.displayManager.sessionCommands = ''
    sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap - <<'EOF'
    clear lock
    keycode 66 = Home NoSymbol Home
    EOF
  '';
  services.displayManager.defaultSession = "plasmax11";

  # services.displayManager.sddm.wayland.compositor = "kwin";
  # services.displayManager.sddm.wayland.enable = true;

  services.printing.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      gyre-fonts
      noto-fonts-color-emoji
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "VictorMono" ]; })
      # nerd-fonts.symbols-only
      # nerd-fonts.victor-mono
      # nerd-fonts.ubuntu-mono
    ];
    fontconfig = {
      localConf = ''
      <?xml version="1.0"?>
      <fontconfig>
        <alias>
          <family>Glorious Monospaced Shell</family>
          <prefer>
            <family>Comic Code</family>
            <family>Comic Code Ligatures</family>
            <family>Symbols Nerd Font Mono</family>
            <family>Noto Color Emoji</family>
          </prefer>
        </alias>
        <match target="pattern">
          <test qual="any" name="family">
            <string>NewCenturySchlbk</string>
          </test>
          <edit name="family" mode="assign" binding="same">
            <string>TeX Gyre Schola</string>
          </edit>
        </match>
      </fontconfig>
      '';
    };
  };

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_DATA_DIRS = [ "${XDG_DATA_HOME}/flatpak/exports/share" ];
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

}
