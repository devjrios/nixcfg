{
  config,
  lib,
  pkgs,
  ...
}: {

  boot.blacklistedKernelModules = [ "nouveau" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;

  # This is for docker containers
  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;

    open = false;
    modesetting.enable = true;
    nvidiaSettings = false;
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    prime = {
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:4:0:0";

      sync.enable = true;
    };
  };

}
