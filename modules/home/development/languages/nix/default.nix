{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.nix;
in
{
  options.dotfyls.development.languages.nix.enable = lib.mkEnableOption "Nix" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls.development = {
      tools = with pkgs; [
        deadnix
        nil
        nixd
        nixfmt-rfc-style
        statix
      ];
      languages.servers = {
        nil_ls.settings.nil.flake.nixpkgsInputName = null;
        nixd.settings.nixd =
          let
            flake = "(builtins.getFlake (if (builtins.getEnv \"FLAKE\" == \"\") then ./. else (builtins.getEnv \"FLAKE\")))'";
          in
          {
            nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
            formatting.command = null;
            options = {
              nixos.expr = "${flake}.nixosConfigurations.artemux.options";
              home_manager.expr = "${flake}.homeConfigurations.artemux.options";
            };
          };
      };
    };

    home.sessionVariables.FLAKE_CHECKER_NO_TELEMETRY = "true";
  };
}
