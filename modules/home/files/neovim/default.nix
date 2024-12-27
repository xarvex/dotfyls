{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.dotfyls.files.neovim;
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

      defaultEditor = true;
      vimAlias = true;
    };

    # TODO: Filter Lua files.
    xdg.configFile = {
      "nvim/after" = {
        recursive = true;
        source = ./nvim/after;
      };
      "nvim/init.lua".source = ./nvim/init.lua;
      "nvim/lua" = {
        recursive = true;
        source = ./nvim/lua;
      };
    };

    systemd.user.tmpfiles.rules = [
      "C+ ${config.xdg.configHome}/nvim/lazy-lock.json 0644 - - - ${./nvim/lazy-lock.json}"
    ];
  };
}
