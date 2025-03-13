{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.files.localsend;
in
{
  options.dotfyls.files.localsend.enable = lib.mkEnableOption "LocalSend" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.file.".local/share/org.localsend.localsend_app".cache = true;

    home.packages = with pkgs; [ localsend ];
  };
}
