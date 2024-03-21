{
  hardware.enableRedistributableFirmware = true;
  boot.kernel.sysctl = {"vm.swappiness" = 10;};
  hardware.enableAllFirmware = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.efi.canTouchEfiVariables = true;
}
