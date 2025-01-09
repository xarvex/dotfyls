{
  config,
  lib,
  pkgs,
  self,
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
  imports = [
    (self.lib.mkAliasPackageModule [ "dotfyls" "files" "neovim" ] [ "programs" "neovim" ])
  ];

  options.dotfyls.files.neovim.enable = lib.mkEnableOption "Neovim" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file =
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

    programs.neovim = {
      enable = true;
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
      extraWrapperArgs = [
        "--run"
        (lib.getExe copyLock)
      ];

      defaultEditor = true;
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
