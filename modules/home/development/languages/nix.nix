{
  config,
  lib,
  osConfig ? null,
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
    dotfyls = {
      development.tools = with pkgs; [
        deadnix
        nil
        nixd
        nixfmt-rfc-style
        statix
      ];
      editors.neovim.lsp = {
        nil_ls.settings.nil.flake.nixpkgsInputName = null;
        nixd.settings.nixd =
          let
            flake = ''(builtins.getFlake "${
              if config.dotfyls.meta.location != null then config.dotfyls.meta.location else "./."
            }")'';
          in
          {
            nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
            formatting.command = [ ];
            options = {
              nixos.expr = "${flake}.nixosConfigurations.${config.dotfyls.meta.name}.options";
              home_manager.expr =
                if osConfig == null then
                  "${flake}.homeConfigurations.${config.dotfyls.meta.name}.options"
                else
                  "${flake}.nixosConfigurations.${config.dotfyls.meta.name}.options.home-manager.users.type.getSubOptions []";
            };
          };
      };
    };

    home.sessionVariables.FLAKE_CHECKER_NO_TELEMETRY = lib.boolToString true;
  };
}
