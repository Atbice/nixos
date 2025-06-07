{ config, lib, pkgs, ... }:

{
  boot = {
    # Modern systemd-boot configuration
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };

    # Latest stable Linux kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # Boot optimization
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # Gaming optimization
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    # Plymouth boot splash
    plymouth.enable = true;
  };
}
