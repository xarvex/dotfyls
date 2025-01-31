{ lib }:

{
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
