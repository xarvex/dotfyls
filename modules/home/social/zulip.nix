{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.social;
  cfg = cfg'.zulip;
in
{
  options.dotfyls.social.zulip.enable = lib.mkEnableOption "Zulip" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file.".config/Zulip" = {
      mode = "0700";
      cache = true;
    };

    home.packages = with pkgs; [ zulip ];
  };
}
