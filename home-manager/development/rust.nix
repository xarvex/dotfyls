{ config, lib, ... }:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.languages.rust;
in
{
  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.persist.directories = [
      ".local/share/cargo"
      ".local/share/rustup"
    ];

    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };
  };
}
