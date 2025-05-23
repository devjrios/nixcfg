{pkgs, ...}: {
  boot.tmp.cleanOnBoot = true;
  # boot.kernelPackages = pkgs.linuxPackages_xanmod;
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.kernelPatches = [
    {
      name = "bore";
      patch = ./tkg-patches/0001-bore.patch;
    }
    {
      name = "clear";
      patch = ./tkg-patches/0002-clear-patches.patch;
    }
    {
      name = "misc";
      patch = ./tkg-patches/0012-misc-additions.patch;
    }
    {
      name = "o3";
      patch = ./tkg-patches/0013-optimize_harder_O3.patch;
    }
  ];
}
