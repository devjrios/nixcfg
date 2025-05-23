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

    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "550.163.01";
      sha256_64bit = "sha256-FIiG5PaVdvqPpnFA5uXdblH5Cy7HSmXxp6czTfpd4bY=";
      sha256_aarch64 = lib.fakeSha256;
      openSha256 = lib.fakeSha256;
      settingsSha256 = lib.fakeSha256;
      persistencedSha256 = lib.fakeSha256;
    };

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
