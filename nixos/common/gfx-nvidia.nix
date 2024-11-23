{ config, lib, pkgs, ... }:
{
  config = {

    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {

      # package = config.boot.kernelPackages.nvidiaPackages.production;

      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "550.127.05";
        sha256_64bit = "sha256-04TzT10qiWvXU20962ptlz2AlKOtSFocLuO/UZIIauk=";
        sha256_aarch64 = "sha256-3wsGqJvDf8io4qFSqbpafeHHBjbasK5i/W+U6TeEeBY=";
        openSha256 = "sha256-r0zlWPIuc6suaAk39pzu/tp0M++kY2qF8jklKePhZQQ=";
        settingsSha256 = "sha256-cUSOTsueqkqYq3Z4/KEnLpTJAryML4Tk7jco/ONsvyg=";
        persistencedSha256 = "sha256-8nowXrL6CRB3/YcoG1iWeD4OCYbsYKOOPE374qaa4sY=";
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

        # offload = {
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
      };
    };

    # This is for docker containers
    # Try again in the 24.11 release
    # hardware.nvidia-container-toolkit.enable = true;

  };
}
