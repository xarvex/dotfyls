{ config, lib, pkgs, self, ... }:

let
  cfg = config.dotfyls.shells;
in
{
  imports = [
    ./bash.nix
    ./zsh.nix

    (self.lib.mkSelectorModule [ "dotfyls" "shells" ]
      {
        name = "default";
        default = "zsh";
        description = "Default shell to use.";
      }
      [
        "bash"
        "zsh"
      ])
  ];

  options.dotfyls.shells = {
    historySize = lib.mkOption {
      type = lib.types.int;
      default = 10000;
      example = 100000;
      description = "Number of history lines.";
    };

    initBins = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      example = [ pkgs.fastfetch ];
      description = "";
    };
    finalInitBins = lib.mkOption {
      readOnly = true;
      type = lib.types.str;
      default = lib.concatStringsSep "\n"
        (builtins.map (pkg: lib.getExe pkg) cfg.initBins);
      description = "";
    };
  };

  config = {
    home.shellAliases = {
      ".." = "cd ..";

      ccat = "command cat";
      mman = "command man";
    };
  };
}
