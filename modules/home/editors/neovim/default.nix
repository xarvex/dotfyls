{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.editors;
  cfg = cfg'.neovim;

  luaFormat = pkgs.formats.lua { };

  copyLock = pkgs.writers.writeDash "dotfyls-neovim-copy-lock" ''
    ${lib.getExe' pkgs.coreutils "mkdir"} -p "''${XDG_CONFIG_HOME:-''${HOME}/.config}/nvim" || exit 0
    ${lib.getExe' pkgs.coreutils "cp"} ${./lazy-lock.json} "''${XDG_CONFIG_HOME:-''${HOME}/.config}/nvim/lazy-lock.json" || exit 0
    ${lib.getExe' pkgs.coreutils "chmod"} u+w "''${XDG_CONFIG_HOME:-''${HOME}/.config}/nvim/lazy-lock.json" || exit 0
  '';
in
{
  options.dotfyls.editors.neovim = {
    enable = lib.mkEnableOption "Neovim";

    lsp = lib.mkOption {
      type = lib.types.attrsOf luaFormat.type;
      default = { };
      description = "Attrset of language servers and their configuration.";
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
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

    home.packages = [
      (lib.hiPrio (
        pkgs.runCommandLocal "nvim-desktop" { nativeBuildInputs = with pkgs; [ coreutils ]; } ''
          install -D \
            ${config.programs.neovim.package}/share/applications/nvim.desktop \
            $out/share/applications/nvim.desktop
        ''
      ))
    ];

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
          ghostscript_headless
          git
          gnumake
          imagemagick
          nodePackages.nodejs
        ])
        ++ lib.optionals config.dotfyls.development.enable config.dotfyls.development.tools;
      extraWrapperArgs = [
        "--run"
        "${copyLock}"
      ];

      vimAlias = true;
    };

    xdg.configFile = lib.mkMerge [
      {
        "nvim/after" = {
          recursive = true;
          source = ./after;
        };
        "nvim/lua".source = ./lua;
        "nvim/init.lua".source = ./init.lua;
      }
      (lib.mapAttrs' (
        server: configuration:
        lib.nameValuePair "nvim/after/lsp/${server}.lua" {
          source = luaFormat.generate "nvim-after-lsp-${server}-lua" configuration;
        }
      ) cfg.lsp)
    ];
  };
}
