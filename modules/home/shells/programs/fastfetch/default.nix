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

  choose-logo = pkgs.writeScript "dotfyls-fastfetch-choose-logo" (
    let
      jq = lib.getExe pkgs.jq;
      printf = lib.getExe' pkgs.coreutils "printf";

      suffix = if json.logo.type == "small" then "_small" else "";
    in
    ''
      #!${lib.getExe pkgs.dash}
       
      logo="$(fastfetch -c none -s OS --format json | ${jq} -r .[0].result.id)${suffix}"
      file="${./logos}/''${logo}.txt"

      if [ -e "''${file}" ]; then
          ${printf} '%s' "''${file}"
      else
          ${printf} '%s' "${pkgs.fastfetch.src}/src/logo/ascii/''${logo}.txt"
      fi
    ''
  );
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
