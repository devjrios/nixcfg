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

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      # MOZ_DISABLE_RDD_SANDBOX = "1";
      # EGL_PLATFORM = "wayland";
    };

    hardware.opengl.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      package = nvidiaPkg;
      open = true;
      modesetting.enable = true;
      nvidiaSettings = false;
      powerManagement.enable = false;

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
