{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.programs;
  cfg = cfg'.fastfetch;

  json = lib.importJSON ./config.jsonc;

  choose-logo = pkgs.writers.writeDash "dotfyls-fastfetch-choose-logo" ''
    logo="$(fastfetch -c none -s OS --format json | ${lib.getExe pkgs.jq} -r .[0].result.id)${
      if json.logo.type == "small" then "_small" else ""
    }"
    file="${./logos}/''${logo}.txt"

    if [ -e "''${file}" ]; then
        ${lib.getExe' pkgs.coreutils "printf"} '%s' "''${file}"
    else
        ${lib.getExe' pkgs.coreutils "printf"} '%s' "${pkgs.fastfetch.src}/src/logo/ascii/''${logo}.txt"
    fi
  '';
in
{
  options.dotfyls.shells.programs.fastfetch.enable = lib.mkEnableOption "Fastfetch" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.shells.greet = self.lib.getCfgExe config.programs.fastfetch;

    home.shellAliases = rec {
      f = fetch;
      fetch = "fastfetch";

      neofetch = "fastfetch -c neofetch";
    };

    programs.fastfetch = {
      enable = true;

      settings = json // {
        logo = (builtins.removeAttrs json.logo [ "type" ]) // {
          source = "$(${choose-logo})";
        };
      };
    };
  };
}
