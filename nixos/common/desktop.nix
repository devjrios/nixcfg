{ pkgs, ... }:
{
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
      Enable = "Source,Sink,Media,Socket";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # jack.enable = true;
  };
  nixpkgs.config.pulseaudio = true;


  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  environment.variables = {
    KWIN_COMPOSE = "N";
    # KWIN_OPENGL_INTERFACE should be left out, didn't work.
    # KWIN_OPENGL_INTERFACE = "egl";
    # KWIN_TRIPLE_BUFFER = "1";
    # not sure about __GL_MaxFramesAllowed
    # __GL_MaxFramesAllowed = "1";
    # KWIN_COMPOSE = "O2ES";
    # KWIN_X11_REFRESH_RATE = "144000";
    # KWIN_X11_NO_SYNC_TO_VBLANK = "1";
    # KWIN_X11_FORCE_SOFTWARE_VSYNC = "1";
    # CLUTTER_DEFAULT_FPS = "144";
    # __GL_SYNC_DISPLAY_DEVICE = "eDP";
    # __GL_SYNC_TO_VBLANK = "0";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap - <<'EOF'
    clear lock
    keycode 66 = Home NoSymbol Home
    EOF
  '';
  services.xserver.desktopManager.plasma5.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.defaultSession = "plasmax11";

  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   plasma-browser-integration
  #   konsole
  #   oxygen
  # ];

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.printing.enable = true;

  fonts = {
    # fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      # dejavu_fonts
      # freefont_ttf
      # liberation_ttf
      # unifont
      # wine64Packages.fonts
      # corefonts
      gyre-fonts
      noto-fonts-color-emoji
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "VictorMono" ]; })
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
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

}
