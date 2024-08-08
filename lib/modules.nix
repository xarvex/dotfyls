{ lib }:

rec {
  mkAliasOptionModules = from: to: options:
    {
      imports = builtins.map
        (module: (lib.mkAliasOptionModule (from ++ [ module ]) (to ++ [ module ])))
        options;
    };

  mkAliasPackageModule = from: to:
    { config, options, ... }:
    {
      imports = [ (mkAliasOptionModules from to [ "package" ]) ];

      options = lib.setAttrByPath from
        (lib.optionalAttrs ((lib.getAttrFromPath to options) ? finalPackage) {
          finalPackage = (lib.getAttrFromPath to options).finalPackage;
        });

      config = lib.setAttrByPath from
        (lib.optionalAttrs ((lib.getAttrFromPath to options) ? finalPackage) {
          finalPackage = lib.mkIf (!((lib.getAttrFromPath from options).finalPackage ? default)) (lib.getAttrFromPath to config).finalPackage;
        });
    };

  mkCommonModules = path: generator: optionModules:
    { config, ... }:
    {
      options = lib.setAttrByPath path (builtins.mapAttrs
        (module: opts:
          lib.recursiveUpdate
            (generator (builtins.removeAttrs opts [ "specialArgs" ]) (lib.getAttrFromPath path config).${module})
            (opts.specialArgs or { }))
        optionModules);
    };

  mkSelectorModule' = selectionPath: selectorPath: selectionOption: selections:
    { config, ... }:
    let
      selections' = if (builtins.isAttrs selections) then builtins.attrNames selections else selections;
      selected = (lib.getAttrFromPath selectorPath config).${selectionOption.name};
    in
    {
      imports = [ (lib.mkAliasOptionModule (selectorPath ++ [ "selected" ]) (selectionPath ++ [ selected ])) ];

      options = lib.recursiveUpdate
        (lib.setAttrByPath selectorPath {
          ${selectionOption.name} = lib.mkOption {
            inherit (selectionOption) default description;

            type = lib.types.enum selections';
          };
        })
        (if (builtins.isAttrs selections) then
          (lib.setAttrByPath selectionPath
            (builtins.mapAttrs (module: name: { enable = lib.mkEnableOption name; }) selections))
        else { });

      config = lib.setAttrByPath selectorPath { selected.enable = true; };
    };

  mkSelectorModule = path: selectionOption: selections:
    {
      imports = [ (mkSelectorModule' (path ++ [ (lib.last path) ]) path selectionOption selections) ];
    };
}
