{
  config,
  lib,
  user,
  ...
}:

let
  cfg' = config.dotfyls.input;
  cfg = cfg'.uinput;
  hmCfg = config.hm.dotfyls.input.uinput;
in
{
  options.dotfyls.input.uinput = {
    enable = lib.mkEnableOption "uinput" // {
      default = hmCfg.enable;
    };
    inputGroup = lib.mkEnableOption "add input group to user" // {
      default = hmCfg.inputGroup;
    };
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    hardware.uinput.enable = true;

    users.groups = {
      uinput.members = [ user ];
      input.members = lib.optional cfg.inputGroup user;
    };
  };
}
