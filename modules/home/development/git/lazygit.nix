{
  config,
  lib,
  self,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.git;
  cfg = cfg'.lazygit;
in
{
  options.dotfyls.development.git.lazygit.enable = lib.mkEnableOption "lazygit" // {
    default = true;
  };

  config = lib.mkIf (cfg''.enable && cfg'.enable && cfg.enable) {
    programs.lazygit = {
      enable = true;

      settings = {
        gui = {
          timeFormat = "2006-01-02";
          shortTimeFormat = "15:04";
          showListFooter = false;
          showFileTree = false;
          showRandomTip = false;
          showCommandLog = false;
          showPanelJumps = false;
          nerdFontsVersion = "3";
          filterMode = "fuzzy";
        };
        git.paging.externalDiffCommand = lib.mkIf cfg'.difftastic.enable "${self.lib.getCfgExe config.programs.lazygit} --color always";
        update.method = "never";
        quitOntopLevelReturn = true;
        disableStartupPopups = true;
        notARepository = "quit";
      };
    };
  };
}
