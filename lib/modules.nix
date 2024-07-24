{ lib }:

{
  mkSelectorModule = path: selectionOption: optionModules: optionGenerator:
    { config, ... }:
    let
      pathLast = lib.last path;
      selected = lib.getAttrFromPath (path ++ [ selectionOption.name ]) config;
      selectedPath = path ++ [ pathLast selected ];
    in
    {
      imports = [
        (lib.mkAliasOptionModule (path ++ [ "selected" ]) selectedPath)
      ];

      options = lib.setAttrByPath
        path
        {
          ${selectionOption.name} = lib.mkOption {
            inherit (selectionOption) default description;

            type = lib.types.enum (builtins.attrNames optionModules);
          };
          ${pathLast} = builtins.mapAttrs
            (module: name: { enable = lib.mkEnableOption name; }
              // optionGenerator name (lib.getAttrFromPath (path ++ [ pathLast module ]) config))
            optionModules;
        };

      config = lib.setAttrByPath selectedPath { enable = true; };
    };
}
