{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.social;
  cfg = cfg'.signal;
in
{
  options.dotfyls.social.signal.enable = lib.mkEnableOption "Signal" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".config/Zulip" = {
      mode = "0700";
      cache = true;
    };

    home.packages = with pkgs; [ signal-desktop ];
  };
}
