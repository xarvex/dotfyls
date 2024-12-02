{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.rust;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.files = {
      ".local/share/cargo".cache = true;

      ".local/share/rustup".cache = true;
    };

    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      CARGO_TARGET_DIR = "${config.home.sessionVariables.CARGO_HOME}/target";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };
  };
}
