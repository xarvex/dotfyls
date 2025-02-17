{
  config,
  inputs,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.development;
in
{
  imports = [
    inputs.wherenver.homeManagerModules.wherenver

    ./codespell
    ./direnv
    ./git
    ./languages
    ./vale
  ];

  options.dotfyls.development = {
    enable = lib.mkEnableOption "development" // {
      default = config.dotfyls.desktops.enable;
    };
    tools = self.lib.mkExtraPackagesOption "develop";
    ignoreDirs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "List of directories to ignore for tooling.";
    };
  };

  config = lib.mkIf cfg.enable {
    dotfyls.development.ignoreDirs = [
      ".devenv"
      ".direnv"
      ".git"
      ".github"
      ".gitlab"
      ".idea"
      ".ruff_cache"
      ".stfolder"
      ".vale"
      ".venv"
      ".vscode"
      "__pycache__"
      "bin"
      "build"
      "dist"
      "docs"
      "nix"
      "node_modules"
      "result"
      "result-dev"
      "result-man"
      "result-src"
      "target"
      "venv"
    ];
  };
}
