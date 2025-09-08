{ self, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.project-slug;

  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.project-slug = {
    enable = lib.mkEnableOption "project-name";
    package = lib.mkPackageOption self.packages.${pkgs.system} "project-name" {
      default = "project-slug";
    };

    settings = lib.mkOption {
      inherit (tomlFormat) type;
      default = { };
      example = lib.literalExpression ''
        {
          foo = {
            bar = true;
            foobar = 10;
          };
        };
      '';
      description = "Configuration used for project-name.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with cfg; [ package ];

    xdg.configHome."project-slug/config.toml".source = lib.mkIf (cfg.settings != { }) (
      tomlFormat.generate "project-slug-settings" cfg.settings
    );
  };
}
