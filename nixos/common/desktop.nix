{ pkgs, ... }:
{
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
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    kate
    khelpcenter
    xwaylandvideobridge
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
