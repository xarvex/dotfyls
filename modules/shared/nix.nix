system:
{
  config,
  inputs,
  lib,
  osConfig ? null,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.nix;
in
{
  options.dotfyls.nix = lib.optionalAttrs (!system) {
    enableSettings = lib.mkEnableOption "configuring Nix settings" // {
      default = osConfig == null;
    };
  };

  config = {
    nix =
      let
        nixPath = lib.mapAttrsToList (name: _: "${name}=flake:${name}") inputs;
        registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs;
      in
      {
        package = lib.mkIf (system || osConfig == null) pkgs.nixVersions.latest;

        inherit nixPath;
        registry = {
          n = registry.nixpkgs;
          packages = registry.nixpkgs;
          pkgs = registry.nixpkgs;
          p = registry.nixpkgs;
        }
        //
          lib.genAttrs
            [
              "nixpkgs-master"
              "nixpkgs-main"
              "n-master"
              "n-main"
              "packages-master"
              "packages-main"
              "pkgs-master"
              "pkgs-main"
              "p-master"
              "p-main"
              "master"
              "main"
              "m"
            ]
            (id: {
              from = {
                type = "indirect";
                inherit id;
              };
              to = {
                type = "github";
                owner = "NixOS";
                repo = "nixpkgs";
              };
            })
        // registry;

        gc = {
          automatic = true;

          dates = "*-*-* 05:00:00";
          options = "--delete-older-than 14d";
        };

        settings = lib.mkIf (system || cfg.enableSettings) {
          auto-optimise-store = true;
          use-xdg-base-directories = true;

          experimental-features = [
            "nix-command"
            "flakes"
          ];
          nix-path = nixPath;
          flake-registry = "";

          trusted-users = [ config.dotfyls.meta.user ];
          substituters = [
            "https://devenv.cachix.org"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
      };

    nixpkgs = lib.mkIf (system || osConfig == null || !osConfig.home-manager.useGlobalPkgs) {
      config = {
        cudaSupport = config.hardware.nvidia.enabled;

        allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "corefonts"
            "cuda-merged"
            "cuda_cccl"
            "cuda_cudart"
            "cuda_cuobjdump"
            "cuda_cupti"
            "cuda_cuxxfilt"
            "cuda_gdb"
            "cuda_nvcc"
            "cuda_nvdisasm"
            "cuda_nvml_dev"
            "cuda_nvprune"
            "cuda_nvrtc"
            "cuda_nvtx"
            "cuda_profiler_api"
            "cuda_sanitizer_api"
            "discord"
            "libcublas"
            "libcufft"
            "libcurand"
            "libcusolver"
            "libcusparse"
            "libnpp"
            "libnvjitlink"
            "nvidia-settings"
            "nvidia-x11"
            "obsidian"
            "spotify"
            "steam"
            "steam-original"
            "steam-run"
            "steam-unwrapped"
            "vintagestory"
            "vista-fonts"
            "zsh-abbr"
          ];
      };
      overlays = [ self.overlays.default ];
    };
  };
}
