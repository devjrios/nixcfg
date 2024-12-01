{ pkgs, ... }:
{

  networking.firewall.enable = false;

  environment.systemPackages = [
    pkgs.google-chrome
    pkgs.brave
    pkgs.firefox-esr
    pkgs.mullvad-browser
    
    pkgs.texliveFull
    pkgs.pandoc

    # System Utils
    pkgs.powershell
    pkgs.openconnect
    pkgs.wget
    pkgs.moreutils
    pkgs.fd
    pkgs.ripgrep
    pkgs.editorconfig-core-c
    pkgs.htop
    pkgs.dos2unix
    pkgs.jq
    pkgs.git
    pkgs.exiftool
    pkgs.jdupes
    pkgs.rsync
    pkgs.bandwhich
    pkgs.quickemu
    
    # X11 utils
    pkgs.xclip
    pkgs.unzip

    # Extra tools
    pkgs.libreoffice-qt
    pkgs.vlc
    pkgs.audacity

    pkgs.subversionClient
    pkgs.drawio
    
    (pkgs.writeShellScriptBin "powershell" ''
    pwsh "$@"
    '')
  ];
}
