{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.eza;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "eza"
      ]
      [
        "programs"
        "eza"
      ]
    )
  ];

  options.dotfyls.programs.eza.enable = lib.mkEnableOption "eza" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      "l." = "eza -d .* --icons=auto";
      ll = "eza -la --git";
      ls = "eza --icons=auto";
      tree = "eza -TL 2 --icons=auto";
    };

    programs.eza = {
      enable = true;

      extraOptions = [ "--hyperlink" ];
    };
  };
}
