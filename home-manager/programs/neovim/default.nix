{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.neovim;
in
{
  imports = [
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
    dotfyls.files = {
      persistDirectories = [
        ".local/share/nvim"
        ".local/state/nvim"
      ];
      cacheDirectories =
        [
          ".cache/nvim"
        ]
        ++ lib.optionals config.dotfyls.development.enable [
          ".local/share/dotfyls/devshell/nvim"
          ".local/state/dotfyls/devshell/nvim"
          ".cache/dotfyls/devshell/nvim"
        ];
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
