{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.shells;
  cfg = cfg'.zsh;

  inherit (import "${inputs.home-manager}/modules/programs/zsh/lib.nix" { inherit config lib; })
    dotDirRel
    ;
in
{
  options.dotfyls.shells.zsh.enable = lib.mkEnableOption "Zsh";

  config = lib.mkIf cfg.enable {
    dotfyls.file = {
      ".local/state/zsh" = {
        mode = "0700";
        persist = true;
      };
      ".cache/zsh".cache = true;
    };

    home.file."${dotDirRel}/.zshrc".text = lib.mkAfter (builtins.readFile ./init-extra-last.zsh);

    programs.zsh = lib.mkMerge [
      {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";

        envExtra = builtins.readFile ./env-extra.zsh;
      }
      # Everything below becomes generated .zshrc:
      {
        initContent = lib.mkBefore cfg'.greet;

        defaultKeymap = "viins";
        localVariables.HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE = 1;
      }
      {
        initContent = lib.mkOrder 550 (builtins.readFile ./init-extra-before-comp-init.zsh);

        enableCompletion = true;
        completionInit = builtins.readFile ./completion-init.zsh;

        autosuggestion.enable = true;

        # Plugin path and fpath is added earlier, but here is where sourced:
        plugins = [
          {
            name = "zsh-vi-mode";
            src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
          }
          {
            name = "zsh-abbr";
            src = "${pkgs.zsh-abbr}/share/zsh/zsh-abbr";
          }
          {
            name = "fast-syntax-highlighting";
            src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
          }
        ];

        history = {
          size = cfg'.historySize;
          save = config.programs.zsh.history.size;
          path = "${config.xdg.stateHome}/zsh/history";

          ignoreDups = true;
          ignoreAllDups = true;
          ignoreSpace = true;
          share = true;
        };
        autocd = true;

        syntaxHighlighting.enable = false; # Use zsh-fast-syntax-highlighting.
        historySubstringSearch.enable = true;
      }
    ];
  };
}
