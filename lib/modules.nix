{ lib }:

rec {
  mkAliasOptionModules = from: to: options: {
    imports = builtins.map (
      module: (lib.mkAliasOptionModule (from ++ [ module ]) (to ++ [ module ]))
    ) options;
  };

  mkAliasPackageModule' =
    from: to:
    { options, ... }:
    let
      toOpts = lib.getAttrFromPath to options;
    in
    {
      imports = [ (mkAliasOptionModules from to [ "package" ]) ];

      options = lib.setAttrByPath from (
        lib.optionalAttrs (toOpts ? finalPackage) { inherit (toOpts) finalPackage; }
      );
    };
  # Must be copied from mkAliasPackageModule', otherwise will stack overflow.
  mkAliasPackageModule =
    from: to:
    { config, options, ... }:
    let
      fromOpts = lib.getAttrFromPath from options;
      toOpts = lib.getAttrFromPath to options;
      toCfg = lib.getAttrFromPath to config;
    in
    {
      imports = [ (mkAliasOptionModules from to [ "package" ]) ];

      options = lib.setAttrByPath from (
        lib.optionalAttrs (toOpts ? finalPackage) { inherit (toOpts) finalPackage; }
      );

      config = lib.setAttrByPath from (
        lib.optionalAttrs (toOpts ? finalPackage) {
          finalPackage = lib.mkIf (
            !(fromOpts.finalPackage ? default) || fromOpts.finalPackage.default == null
          ) toCfg.finalPackage;
        }
      );
    };

  mkCommonModules =
    path: generator: optionModules:
    { config, ... }:
    {
      options = lib.setAttrByPath path (
        builtins.mapAttrs (
          module: opts:
          lib.recursiveUpdate (generator (builtins.removeAttrs opts [
            "specialArgs"
          ]) (lib.getAttrFromPath path config).${module}) (opts.specialArgs or { })
        ) optionModules
      );
    };

  mkSelectorModule' =
    selectionPath: selectorPath: selectionOption: selections:
    { config, ... }:
    let
      selections' = if (builtins.isAttrs selections) then builtins.attrNames selections else selections;
      selected = (lib.getAttrFromPath selectorPath config).${selectionOption.name};
    in
    {
      imports = [
        (lib.mkAliasOptionModule (selectorPath ++ [ "selected" ]) (selectionPath ++ [ selected ]))
      ];

      options =
        lib.recursiveUpdate
          (lib.setAttrByPath selectorPath {
            ${selectionOption.name} = lib.mkOption {
              inherit (selectionOption) default description;

              type = lib.types.enum selections';
            };
          })
          (
            if (builtins.isAttrs selections) then
              (lib.setAttrByPath selectionPath (
                builtins.mapAttrs (_: name: { enable = lib.mkEnableOption name; }) selections
              ))
            else
              { }
          );

      config = lib.setAttrByPath selectorPath { selected.enable = true; };
    };

  mkSelectorModule = path: selectionOption: selections: {
    imports = [ (mkSelectorModule' (path ++ [ (lib.last path) ]) path selectionOption selections) ];
  };
}
