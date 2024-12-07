{ lib }:

rec {
  mkAliasOptionModules = from: to: options: {
    imports = map (module: (lib.mkAliasOptionModule (from ++ [ module ]) (to ++ [ module ]))) options;
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

  mkSelectorModule =
    path: selectionOption:
    { config, ... }:
    {
      options = lib.setAttrByPath path {
        ${selectionOption.name} = lib.mkOption {
          type = lib.types.enum (builtins.attrNames (lib.getAttrFromPath path config).${lib.last path});
          inherit (selectionOption) default description;
        };
      };

      config = lib.setAttrByPath (
        path
        ++ [
          (lib.last path)
          (lib.getAttrFromPath path config).${selectionOption.name}
        ]
      ) { enable = lib.mkDefault true; };
    };
}
