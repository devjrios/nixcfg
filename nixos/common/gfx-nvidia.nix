{ config, lib, pkgs, ... }:
let
  nvProduction = config.boot.kernelPackages.nvidiaPackages.production;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta;
  nvidiaPkg =
    if (lib.versionOlder nvBeta.version nvProduction.version) then
      nvProduction
    else
      nvBeta;
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
