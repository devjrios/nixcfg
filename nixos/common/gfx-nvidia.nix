{ config, lib, pkgs, ... }:
{
  config = {

    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
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
