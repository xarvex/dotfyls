{
  description = "Neovim dotfyls";

  inputs = {
    devenv.url = "github:cachix/devenv";

    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devenv.flakeModule ];

      systems = import inputs.systems;

      perSystem =
        { pkgs, ... }:
        {
          devenv.shells = rec {
            default = neovim;

            neovim = {
              devenv.root =
                let
                  devenvRoot = builtins.readFile inputs.devenv-root.outPath;
                in
                # If not overridden (/dev/null), --impure is necessary.
                lib.mkIf (devenvRoot != "") devenvRoot;

              name = "Neovim";

              packages =
                [ pkgs.neovim ]
                ++ (with pkgs; [
                  chafa
                  codespell
                  delta
                  fd
                  fzf
                  gcc
                  git
                  gnumake
                  nodejs_22
                  ripgrep
                  vale-ls
                ]);

              enterShell = ''
                NVIM_APPNAME="dotfyls/devshell/nvim/$(sha1sum - <<<"''${PWD}" | head -c40)''${PWD//[^a-zA-Z0-9]/-}"
                export NVIM_APPNAME
                mkdir -p "''${XDG_CONFIG_HOME:-''${HOME}/.config}/dotfyls/devshell/nvim"
                ln -fsT "''${PWD}" "''${XDG_CONFIG_HOME:-''${HOME}/.config}/''${NVIM_APPNAME}"
              '';

              languages = {
                lua = {
                  enable = true;
                  package = pkgs.luajit;
                };
                nix.enable = true;
              };

              pre-commit.hooks = {
                deadnix.enable = true;
                flake-checker.enable = true;
                nixfmt-rfc-style.enable = true;
                statix.enable = true;
                stylua.enable = true;
              };
            };
          };
        };

      flake.homeManagerModules = rec {
        default = neovim;

        neovim =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          let

            cfg' = config.programs.neovim;
            cfg = cfg'.dotfyls;
          in
          {
            options.programs.neovim.dotfyls.enable = lib.mkEnableOption "Neovim dotfyls";

            config = lib.mkIf (cfg'.enable && cfg.enable) {
              programs.neovim = {
                withNodeJs = lib.mkDefault false;
                withPython3 = lib.mkDefault false;
                withRuby = lib.mkDefault false;
                extraPackages = with pkgs; [
                  chafa
                  delta
                  gcc
                  git
                  gnumake
                  nodejs_22
                ];
              };

              # TODO: filter Lua files
              xdg.configFile = {
                "nvim/after" = {
                  recursive = true;
                  source = ./after;
                };
                "nvim/init.lua".source = ./init.lua;
                "nvim/lua" = {
                  recursive = true;
                  source = ./lua;
                };
              };

              systemd.user.tmpfiles.rules = [
                "C+ ${config.xdg.configHome}/nvim/lazy-lock.json 0644 - - - ${./lazy-lock.json}"
              ];
            };
          };
      };
    };
}
