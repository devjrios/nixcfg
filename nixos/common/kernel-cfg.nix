{ pkgs, ... }:
{
  # boot.kernelParams = [ "nohibernate" ];
  boot.tmp.cleanOnBoot = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
}
