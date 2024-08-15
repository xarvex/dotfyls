{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.programs.vesktop;
in
{
  options.dotfyls.programs.vesktop = {
    enable = lib.mkEnableOption "Vesktop" // { default = config.dotfyls.desktops.enable; };
    package = lib.mkPackageOption pkgs "Vesktop" { default = "vesktop"; };
    finalPackage = self.lib.mkFinalPackageOption "Vesktop" // {
      default = cfg.package.overrideAttrs (o:
        let
          createState = pkgs.lib.dotfyls.mkCommand {
            runtimeInputs = with pkgs; [ coreutils ];
            text = ''
              cat ${./state.json} > "${config.xdg.configHome}"/vesktop/state.json
            '';
          };
        in
        {
          nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.makeWrapper ];
          postFixup = (o.postFixup or "") + ''
            wrapProgram $out/bin/vesktop --run "${lib.getExe createState}"
          '';
        });
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.persist.cacheDirectories = [ ".config/vesktop/sessionData" ];

    home.packages = with cfg; [ finalPackage ];

    xdg.configFile = {
      "vesktop/settings.json".source = ./settings.json;
      "vesktop/settings/settings.json".source = ./settings/settings.json;
    };
  };
}
