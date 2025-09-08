{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.management.monitor;
  cfg = cfg'.btop;
  hmCfg = config.hm.dotfyls.management.monitor;
in
{
  options.dotfyls.management.monitor = {
    enable = lib.mkEnableOption "monitoring" // {
      default = hmCfg.enable;
    };
    btop.enable = lib.mkEnableOption "Btop" // {
      default = hmCfg.btop.enable;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    security.wrappers.btop = {
      source = lib.getExe pkgs.btop;
      owner = "root";
      group = "root";
      # See: https://github.com/aristocratos/btop/blob/0f398abd64febfbc5f2115be3156682f47308f48/Makefile#L332-L336
      capabilities = "cap_perfmon=+ep";
    };
  };
}
