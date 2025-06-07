{ config, pkgs, ... }:

{
  # Development tools system-wide
  environment.systemPackages = with pkgs; [
    # Version control
    git
    git-lfs

    # Editors
    neovim

    # Build tools
    gcc
    cmake
    gnumake

    # Container tools
    podman
    podman-compose
    podman-tui        # Terminal UI for Podman
    skopeo            # Work with container images
    buildah           # Build container images

    # Optional: Docker compatibility
    podman-desktop    # GUI for Podman (like Docker Desktop)
  ];

  # Enable Podman
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman
      dockerCompat = true;

      # Required for containers under podman
      defaultNetwork.settings = {
        dns_enabled = true;
      };

      # Enable NVIDIA Container Toolkit for GPU support
      enableNvidia = true;

      # Extra packages for Podman
      extraPackages = [ pkgs.zfs ];
    };

    # Enable container networking
    containers = {
      enable = true;
      storage.settings = {
        storage = {
          driver = "overlay";
          runroot = "/run/containers/storage";
          graphroot = "/var/lib/containers/storage";
        };
      };
    };
  };

  # NVIDIA Container Toolkit for GPU support in containers
  hardware.nvidia-container-toolkit.enable = true;

  # Optional: Enable lingering for rootless containers to run without user logged in
  users.users.bice = {
    lingering = true;
  };

  # Useful aliases and environment variables
  environment.shellAliases = {
    # Docker compatibility aliases (if dockerCompat isn't enough)
    "docker-compose" = "podman-compose";
  };

  # Configure subuid/subgid for rootless containers
  users.users.bice.subUidRanges = [
    { count = 65536; startUid = 100000; }
  ];
  users.users.bice.subGidRanges = [
    { count = 65536; startGid = 100000; }
  ];

  # Optional: Podman-specific optimizations
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 80;  # Allow rootless containers to bind to ports >= 80
  };
}
