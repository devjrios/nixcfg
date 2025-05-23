{pkgs, ...}: {
  boot.tmp.cleanOnBoot = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # boot.kernelPackages = pkgs.linuxPackages_6_6;
  # boot.kernelPackages = pkgs.linuxPackages_6_12;
  # boot.kernelPackages = pkgs.linuxPackages_6_1;
}
