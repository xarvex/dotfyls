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
      ".hg"
      ".idea"
      ".mypy_cache"
      ".pyenv"
      ".pytest_cache"
      ".ruff_cache"
      ".stfolder"
      ".svn"
      ".vale"
      ".venv"
      ".vscode"
      "__pycache__"
      "__pypackages__"
      "bin"
      "build"
      "dist"
      "docs"
      "nix"
      "node_modules"
      "result"
      "result-bin"
      "result-dev"
      "result-lib"
      "result-man"
      "result-src"
      "site-packages"
      "target"
      "venv"
    ];
  };
}
