{ pkgs, ... }:
{
  # boot.kernelParams = [ "nohibernate" ];
  # boot.kernelParams = [ "zswap.enabled=1" ];
  boot.tmp.cleanOnBoot = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  boot.modprobeConfig.enable = true;
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';
  # boot.kernelPackages = pkgs.linuxPackages_6_1;
  # boot.kernelPackages = pkgs.linuxPackages_6_6;
}
