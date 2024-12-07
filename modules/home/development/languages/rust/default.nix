{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.rust;
in
{
  options.dotfyls.development.languages.rust.enable = lib.mkEnableOption "Rust" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
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
