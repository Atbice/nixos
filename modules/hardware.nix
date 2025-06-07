{ config, pkgs, ... }:

{
  # Graphics - NVIDIA Proprietary Drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Essential for Steam and 32-bit games
  };

  # NVIDIA driver configuration
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use proprietary driver for best performance
    open = false;

    # Enable kernel mode setting
    modesetting.enable = true;

    # Power management
    powerManagement.enable = true;
    powerManagement.finegrained = false;  # Set to true for laptop GPUs

    # NVIDIA settings application
    nvidiaSettings = true;

    # Driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # CUDA Support for AI/ML Development
  nixpkgs.config.cudaSupport = true;  # Enable CUDA support in packages

  # CUDA packages for development
  environment.systemPackages = with pkgs; [
    # CUDA toolkit and libraries
    cudaPackages.cudatoolkit
    cudaPackages.cudnn

    # Optional: Additional CUDA tools
    cudaPackages.tensorrt  # High-performance deep learning inference

    # GPU monitoring tools
    nvtop          # NVIDIA GPU monitor
    nvidia-smi     # NVIDIA System Management Interface
    gpustat        # Simple GPU status tool
  ];

  # Audio - PipeWire Stack
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Firmware and Steam hardware
  hardware.enableAllFirmware = true;
  hardware.steam-hardware.enable = true;

  # Optional: Persistence mode for NVIDIA (keeps driver loaded)
  # Useful for CUDA development to avoid initialization delays
  systemd.services.nvidia-persistenced = {
    enable = true;
    description = "NVIDIA Persistence Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${config.hardware.nvidia.package.persistenced}/bin/nvidia-persistenced --persistence-mode";
      ExecStopPost = "${pkgs.coreutils}/bin/rm -f /var/run/nvidia-persistenced/nvidia-persistenced.pid";
      Restart = "always";
    };
  };
}
