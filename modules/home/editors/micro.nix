{ config, lib, ... }:

let
  cfg' = config.dotfyls.editors;
  cfg = cfg'.micro;
in
{
  options.dotfyls.editors.micro.enable = lib.mkEnableOption "micro";

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    # TODO: Try this out.
  };
}
