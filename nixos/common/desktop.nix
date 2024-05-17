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
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    sleep 5 && ${pkgs.xorg.xmodmap}/bin/xmodmap - <<'EOF'
    clear lock
    keycode 66 = Home NoSymbol Home
    EOF
  '';
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.printing.enable = true;

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

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];
  };

  services.tomcat = {
    enable = true;
    user = "tomcat";
    webapps = [ "/var/run/user/1000/tomcat9/webapps" "/srv/jrios/tomcat9/webapps" ];
    extraGroups = [ "users" "wheel" ];
    javaOpts = [ "-Dawt.useSystemAAFontSettings=lcd" ];
    package = pkgs.tomcat9;
    jdk = pkgs.zulu8;
    purifyOnStart = true;
    baseDir = "/var/lib/tomcat9";
  };

}
