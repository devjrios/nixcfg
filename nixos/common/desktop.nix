{
  pkgs,
  chadwm-src,
  lib,
  ...
}: {
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
        ControllerMode = "bredr";
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
    pulse.enable = true;
    extraConfig.pipewire-pulse = {
      "50-combine-sink" = {
        "pulse.cmd" = [
          {
            cmd = "load-module";
            args = "module-combine-sink";
          }
        ];
      };
    };
    wireplumber.enable = true;
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
  services.xserver.windowManager.dwm.package =
    (pkgs.dwm.overrideAttrs (finalAttrs: previousAttrs: {
      pname = "chadwm";
      version = "6.5";
      name = lib.strings.concatStringsSep "-" [finalAttrs.pname finalAttrs.version];
      src = chadwm-src.override {
        postFetch = ''
          cd "$out" && find . -maxdepth 1 ! -name "chadwm" ! -name "scripts" ! -name "." -exec rm -rf {} + && \
          mv scripts bin && mv chadwm/* ./ && rm -rf chadwm
        '';
        hash = "sha256-85TB5fXVdqmb2Xyu9yrUlfyK/HOvnmpoW3v3Dn1w1F4=";
      };
      prePatch = null;
      postPatch = let
        bar_fixup = "sed -i 's@#!/bin/dash@#!$out/bin/dash@g' bin/bar_themes/*";
      in ''
        sed -i "s@/usr/local@$out@g" config.mk
        sed -i "s@~/.config/chadwm/scripts/@$out/share/chadwm/@g" bin/bar.sh
        sed -i "s@~/.config/chadwm/scripts/@$out/share/chadwm/@g" bin/run.sh
        ${bar_fixup}
        ${previousAttrs.postPatch or ""}
      '';
      buildInputs = previousAttrs.buildInputs;
      nativeBuildInputs = [(lib.getDev pkgs.imlib2)];
      postInstall = let
        runtimeDeps = lib.strings.concatStringsSep " " (
          map (pkg: "${lib.getBin pkg}/bin/${lib.strings.getName pkg}") [
            pkgs.dash
            pkgs.picom
            pkgs.feh
            pkgs.light
            pkgs.rofi
            pkgs.maim
            pkgs.acpi
            pkgs.eww
            pkgs.xorg.xsetroot
          ]
        );
      in ''
        mkdir -p $out/share/chadwm
        cp -r bin/* $out/share/chadwm
        cp -r ${runtimeDeps} $out/bin
        cp -r ${lib.getBin pkgs.rofi}/bin/rofi-sensible-terminal $out/bin
        cp -r ${lib.getBin pkgs.pulseaudio}/bin/pactl $out/bin
        ln -s $out/share/chadwm/run.sh $out/bin/dwm
      '';
      passthru.updateScript = builtins.gitUpdater {url = "git://github.com/siduck/chadwm";};
    }))
    .override {
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/MinePro120/ddwm/commit/22c0656aab491c1bd21951c773de21de7bdd3c48.patch?full_index=1";
          hash = "sha256-/YYQhptTLI4+kMgTZ5Tb1uHsy2gCPh3v9Qfn6/hLr1A=";
          postFetch = ''
            sed -i "s@chadwm/config.def.h@config.def.h@g" $out
            sed -i "s@a/scripts/@a/bin/@g" $out
            sed -i "s@b/scripts/@b/bin/@g" $out
          '';
          excludes = ["chadwm/config.def.h"];
        })
      ];
      conf = ./chadwm-config.def.h;
    };
  services.xserver.windowManager.dwm.enable = true;
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
    pkgs.kdePackages.krdp
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
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly" "VictorMono" "JetBrainsMono"];})
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
    TERMINAL = "alacritty"; # used for rofi-sensible-terminal
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_DATA_DIRS = ["${XDG_DATA_HOME}/flatpak/exports/share"];
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = ["${XDG_BIN_HOME}"];
  };
}
