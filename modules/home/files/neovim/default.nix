{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.files.neovim;

  copyLock = pkgs.writeShellApplication {
    name = "dotfyls-neovim-copy-lock";

    runtimeInputs = with pkgs; [ coreutils ];

    text = ''
      mkdir -p "''${XDG_CONFIG_HOME:-''${HOME}/.config}/nvim" || exit 0
      cp ${./nvim/lazy-lock.json} "''${XDG_CONFIG_HOME:-''${HOME}/.config}/nvim/lazy-lock.json" || exit 0
      chmod u+w "''${XDG_CONFIG_HOME:-''${HOME}/.config}/nvim/lazy-lock.json" || exit 0
    '';
  };
in
{
  options.dotfyls.files.neovim.enable = lib.mkEnableOption "Neovim" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls = {
      file =
        {
          ".local/share/nvim" = {
            mode = "0700";
            persist = true;
          };
          ".local/state/nvim" = {
            mode = "0700";
            persist = true;
          };
          ".cache/nvim".cache = true;
        }
        // lib.optionalAttrs config.dotfyls.development.enable {
          ".local/share/dotfyls/devshell/nvim" = {
            mode = "0700";
            persist = true;
          };
          ".local/state/dotfyls/devshell/nvim" = {
            mode = "0700";
            persist = true;
          };
          ".cache/dotfyls/devshell/nvim".cache = true;
        };

      mime-apps.files.plaintext = "nvim.desktop";
    };

    home.packages = [
      (lib.hiPrio (
        pkgs.runCommandNoCCLocal "nvim-desktop" { } ''
          mkdir -p $out/share/applications
          cp ${config.programs.neovim.package}/share/applications/nvim.desktop $out/share/applications/nvim.desktop
        ''
      ))
    ];

    home.sessionVariables = rec {
      VISUAL = "nvim";
      EDITOR = VISUAL;
      SUDO_EDITOR = EDITOR;
    };

    programs.neovim = {
      enable = true;
      withNodeJs = lib.mkDefault false;
      withPython3 = lib.mkDefault false;
      withRuby = lib.mkDefault false;
      extraPackages =
        (with pkgs; [
          chafa
          delta
          gcc
          git
          gnumake
          nodejs_22
        ])
        ++ lib.optionals config.dotfyls.development.enable config.dotfyls.development.tools;
      extraWrapperArgs = [
        "--run"
        (lib.getExe copyLock)
      ];

      vimAlias = true;
    };

    xdg.configFile."nvim" = {
      recursive = true;
      source = lib.fileset.toSource {
        root = ./nvim;
        fileset = lib.fileset.fileFilter (file: lib.hasSuffix ".lua" file.name) ./nvim;
      };
    };
  };
}
