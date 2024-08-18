{
  description = "Personal Zsh";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
  };

  outputs = { flake-parts, nixpkgs, systems, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { system, ... }:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # TODO: bundle with config
        packages = rec {
          default = zsh;

          zsh = pkgs.zsh;
        };
      };

    flake.homeManagerModules = rec {
      default = zsh;

      zsh = ({ config, lib, pkgs, ... }: lib.mkIf config.programs.zsh.enable (
        let
          common = path: builtins.readFile ./common/${path};
        in
        {
          programs.zsh = {
            dotDir = ".config/zsh";

            envExtra = common "env-extra.zsh";

            # Everything below becomes generated .zshrc:

            initExtraFirst = common "init-extra-first.zsh";

            defaultKeymap = "viins";
            localVariables = {
              HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE = 1;
            };

            initExtraBeforeCompInit = common "init-extra-before-comp-init.zsh";

            enableCompletion = true;
            completionInit = common "completion-init.zsh";

            autosuggestion.enable = true;

            # Plugin path and fpath is added earlier, but here is where sourced:
            plugins = [
              {
                name = "powerlevel10k";
                file = "powerlevel10k.zsh-theme";
                src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
              }
              {
                name = "zsh-vi-mode";
                src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
              }
              {
                name = "you-should-use";
                src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
              }
              {
                name = "fast-syntax-highlighting";
                src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
              }
            ];

            history = rec {
              size = 10000;
              save = size;
              path = "${config.xdg.stateHome}/zsh/history";

              ignoreDups = true;
              ignoreAllDups = true;
              ignoreSpace = true;
              share = true;
            };
            autocd = true;

            initExtra = lib.concatStringsSep "\n" [
              (common "init-extra.zsh")
              (common "p10k.zsh")
            ];

            syntaxHighlighting.enable = false; # Use zsh-fast-syntax-highlighting.
            historySubstringSearch.enable = true;
          };
        }
      ));
    };
  };
}

