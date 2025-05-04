{
  pkgs,
  lib,
  ...
}: {
  environment.etc = {
    "firejail/qbittorrent.local".text = ''
      dbus-user filter
      dbus-user.talk org.kde.knotifications
      dbus-user.talk org.kde.StatusNotifierWatcher
      dbus-user.talk org.freedesktop.Notifications
      dbus-user.talk org.freedesktop.StatusNotifierItem
      ignore dbus-user none
    '';
  };

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      brave = {
        executable = "${lib.getBin pkgs.brave}/bin/brave";
        profile = "${pkgs.firejail}/etc/firejail/brave.profile";
        desktop = "${pkgs.brave}/share/applications/brave-browser.desktop";
      };
      okular = {
        executable = "${lib.getBin pkgs.kdePackages.okular}/bin/okular";
        profile = "${pkgs.firejail}/etc/firejail/okular.profile";
        desktop = "${pkgs.kdePackages.okular}/share/applications/org.kde.okular.desktop";
        extraArgs = ["--net=none"];
      };
      vlc = {
        executable = "${lib.getBin pkgs.vlc}/bin/vlc";
        profile = "${pkgs.firejail}/etc/firejail/vlc.profile";
        desktop = "${pkgs.vlc}/share/applications/vlc.desktop";
        extraArgs = ["--net=none"];
      };
      qbittorrent = {
        executable = "${lib.getBin pkgs.qbittorrent}/bin/qbittorrent";
        profile = "${pkgs.firejail}/etc/firejail/qbittorrent.profile";
        desktop = "${pkgs.qbittorrent}/share/applications/org.qbittorrent.qBittorrent.desktop";
      };
    };
  };

  environment.systemPackages = [
    pkgs.google-chrome
    pkgs.brave
    pkgs.firefox-esr

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
    pkgs.qbittorrent

    (pkgs.writeShellScriptBin "powershell" ''
      pwsh "$@"
    '')
  ];
}
