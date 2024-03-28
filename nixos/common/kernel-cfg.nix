{ pkgs-unstable, ... }:
{
  # boot.kernelParams = [ "nohibernate" ];
  boot.tmp.cleanOnBoot = true;
  boot.kernelPackages = pkgs-unstable.linuxPackages_xanmod;
}
