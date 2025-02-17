{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.development;
  cfg = cfg'.codespell;
in
{
  options.dotfyls.development.codespell.enable = lib.mkEnableOption "codespell" // {
    default = true;
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.development.tools = with pkgs; [ codespell ];

    xdg.configFile."codespell/.codespellrc".source = ./.codespellrc;
  };
}
