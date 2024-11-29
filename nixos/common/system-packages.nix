{ pkgs, ... }:
{

  networking.firewall.enable = false;

  environment.systemPackages = [
    # Webdev
    pkgs.google-chrome
    pkgs.brave
    pkgs.nodejs_20

    # For docs
    pkgs.texliveFull
    pkgs.pandoc
    pkgs.vscode-fhs

    # System Utils
    pkgs.powershell
    pkgs.openconnect
    pkgs.wget
    pkgs.librsvg
    pkgs.moreutils
    pkgs.fd
    pkgs.ripgrep
    pkgs.editorconfig-core-c
    pkgs.htop
    pkgs.dos2unix
    pkgs.jq
    pkgs.git
    pkgs.quickemu
    pkgs.firefox-esr
    pkgs.mullvad-browser

    # X11 utils
    pkgs.xclip
    pkgs.unzip

    # Extra tools
    pkgs.libreoffice-qt
    pkgs.vlc

    pkgs.subversionClient
    pkgs.drawio

    (pkgs.writeShellScriptBin "make" ''
    args="$@"
    nix-shell --impure -p stdenv --command "make $args"
    '')
    (pkgs.writeShellScriptBin "gcc" ''
    args="$@"
    nix-shell --impure -p stdenv --command "gcc $args"
    '')
    (pkgs.writeShellScriptBin "powershell" ''
    pwsh "$@"
    '')
  ];
}
