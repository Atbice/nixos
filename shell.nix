{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;  # Required for CUDA
      cudaSupport = true;  # Enable CUDA support globally
    };
  }
}:

let
  # Custom Python environment with packages
  pythonEnv = pkgs.python312.withPackages (ps: with ps; [
    # Deep learning with CUDA
    torch                # PyTorch (CUDA enabled via cudaSupport)
    torchvision
    torchaudio

    # Hugging Face ecosystem
    transformers
    accelerate
    datasets
    tokenizers

    # Core scientific computing
    numpy
    pandas
    matplotlib
    seaborn
    scipy
    scikit-learn

    # Computer vision
    opencv4
    pillow

    # Jupyter ecosystem
    jupyter
    jupyterlab         # Added: modern Jupyter interface
    ipython
    ipywidgets         # Added: interactive widgets

    # Development tools
    black
    pylint
    pytest
    mypy              # Added: type checking

    # Utilities
    tqdm
    requests
    python-dotenv
    rich

    # Additional tools
    tensorboard
    plotly            # Added: interactive plots

    # Note: Install these via pip in the shell:
    # wandb, gradio (not in nixpkgs)
  ]);

in pkgs.mkShell {
  buildInputs = with pkgs; [
    # ========== Nix Development ==========
    nixpkgs-fmt
    nil
    statix
    deadnix
    nix-tree         # Added: visualize dependencies

    # Python environment
    pythonEnv

    # Python tools
    uv
    ruff
    poetry            # Added: alternative package manager

    # CUDA toolkit
    cudaPackages.cudatoolkit
    cudaPackages.cudnn

    # ========== Rust Development ==========
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy
    cargo-watch
    cargo-edit
    cargo-flamegraph
    cargo-nextest      # Added: better test runner

    # Build tools
    pkg-config
    cmake
    clang
    mold              # Added: fast linker

    # Graphics/Game libraries
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    vulkan-loader
    vulkan-headers
    vulkan-validation-layers
    vulkan-tools      # Added: vulkaninfo, etc.
    alsa-lib
    udev

    # Additional libraries
    freetype
    expat
    glfw              # Added: alternative to SDL2

    # ========== Development Tools ==========
    git
    git-lfs
    tig
    lazygit           # Added: better git TUI

    # System monitoring
    htop
    btop              # Added: better htop
    nvtop
    gpustat           # Added: simple GPU status

    # File tools
    tree
    ripgrep
    fd
    bat
    eza               # Added: better ls

    # Data tools
    jq
    yq
    fx                # Added: interactive JSON

    # Code tools
    tokei
    hyperfine
    watchexec         # Added: generic file watcher
  ];

  # Library paths
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc.lib
    pkgs.cudaPackages.cudatoolkit
    pkgs.cudaPackages.cudnn
    pkgs.vulkan-loader
    pkgs.SDL2
    pkgs.alsa-lib
    pkgs.udev
    pkgs.xorg.libX11
    pkgs.xorg.libXcursor
    pkgs.xorg.libXi
    pkgs.xorg.libXrandr
    pkgs.libGL          # Added: OpenGL
    pkgs.libGLU         # Added: OpenGL utilities
  ];

  # Environment variables
  CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
  EXTRA_LDFLAGS = "-L${pkgs.cudaPackages.cudatoolkit}/lib";
  EXTRA_CCFLAGS = "-I${pkgs.cudaPackages.cudatoolkit}/include";
  RUST_BACKTRACE = "1";

  # Added: Vulkan environment
  VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";

  shellHook = ''
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║        🚀 AI & Game Development Environment 🎮            ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""

    # Python info
    echo "🐍 Python ${pkgs.python312.version} Environment"
    if python -c "import torch; exit(0 if torch.cuda.is_available() else 1)" 2>/dev/null; then
      echo "   ├─ PyTorch: ✅ CUDA Available"
      python -c "import torch; print(f'   ├─ CUDA Version: {torch.version.cuda}')"
      python -c "import torch; print(f'   └─ GPU: {torch.cuda.get_device_name(0) if torch.cuda.device_count() > 0 else \"No GPU\"}')"
    else
      echo "   └─ PyTorch: ❌ CUDA Not Available"
    fi
    echo ""

    # Rust info
    echo "🦀 Rust ${pkgs.rustc.version}"
    echo "   └─ Game libraries: SDL2, Vulkan, ALSA"
    echo ""

    # Quick GPU check
    if command -v nvidia-smi &> /dev/null; then
      echo "🎮 GPU Status:"
      nvidia-smi --query-gpu=name,memory.total,utilization.gpu --format=csv,noheader | sed 's/^/   └─ /'
      echo ""
    fi

    # Helpful commands
    echo "💡 Quick Start:"
    echo "   Python ML:  jupyter lab          # Start JupyterLab"
    echo "   Monitoring: nvtop                # GPU monitor"
    echo "   Rust:       cargo watch -x run   # Auto-rebuild"
    echo ""

    # Install missing Python packages
    echo "📦 Installing additional Python packages..."
    pip install --quiet wandb gradio 2>/dev/null && echo "   └─ ✅ wandb, gradio installed" || echo "   └─ ℹ️  Run 'pip install wandb gradio' if needed"
    echo ""

    # Set prompt
    export PS1="\[\033[1;35m\][ai-dev]\[\033[0m\] \[\033[1;34m\]\w\[\033[0m\] ❯ "
  '';
}
