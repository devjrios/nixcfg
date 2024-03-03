{ config, lib, pkgs, ... }:
let
  nvStable = config.boot.kernelPackages.nvidiaPackages.stable;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta;
  nvidiaPkg =
    if (lib.versionOlder nvBeta.version nvStable.version) then
      config.boot.kernelPackages.nvidiaPackages.stable
    else
      config.boot.kernelPackages.nvidiaPackages.beta;
in
{
  config = {

    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      package = nvidiaPkg;
      open = false;
      modesetting.enable = true;
      nvidiaSettings = false;
      powerManagement.enable = true;
      powerManagement.finegrained = true;

      prime = {
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:4:0:0";

        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };

  };
}
