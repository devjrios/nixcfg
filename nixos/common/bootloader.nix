{
  hardware.enableRedistributableFirmware = true;
  # boot.kernel.sysctl = {"vm.swappiness" = 10;};
  hardware.enableAllFirmware = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  # boot.loader.initScript.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.extraEntries = {
    "firmware_update.conf" = ''
    title    Linux Firmware Updater
    efi    /EFI/nixos/fwupdx64.efi
    '';
  };
}
