{ pkgs, ... }:
{
  environment.systemPackages = [
    # Webdev
    pkgs.google-chrome
    pkgs.nodejs_18
    pkgs.corepack_18

    # For docs
    pkgs.texliveFull
    pkgs.pandoc
    pkgs.asciidoctor-with-extensions
    pkgs.quarto

    # System Utils
    pkgs.openconnect
    pkgs.wget
    pkgs.librsvg
    pkgs.moreutils
    pkgs.fd
    pkgs.ripgrep
    pkgs.editorconfig-core-c
    pkgs.htop

    # X11 utils
    pkgs.xclip
    pkgs.unzip

    # Extra tools
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
}