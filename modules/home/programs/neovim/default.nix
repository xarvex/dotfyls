{
  config,
  inputs,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.neovim;
in
{
  imports = [
    inputs.dotfyls-neovim.homeManagerModules.neovim

    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "neovim"
      ]
      [
        "programs"
        "neovim"
      ]
    )
  ];

  options.dotfyls.programs.neovim.enable = lib.mkEnableOption "Neovim" // {
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
      defaultEditor = true;
      vimAlias = true;

      dotfyls.enable = true;
    };
  };
}
