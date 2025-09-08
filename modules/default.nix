{
  inputs,
  lib,
  self,
}:

let
  hosts =
    let
      mkHost = id: {
        enableSystem = true;
        enableHome = true;
        inherit id;
      };
    in
    {
      artemux = mkHost "fd9daca2";
      matrix = mkHost "3bb44cc9";
      pioneer = mkHost "3540bf30";
      sentinel = mkHost "ef01cd45";
    };

  mkCommonModule = id: name: { dotfyls.meta = { inherit id name; }; };
  mkHomeModules = name: [
    ./home
    ./hosts/${name}/home.nix
  ];
in
{
  nixosConfigurations =
    builtins.mapAttrs (
      name:
      { enableHome, id, ... }:
      lib.nixosSystem rec {
        specialArgs = { inherit inputs self; };
        modules = [
          ./system
          ./hosts/${name}/hardware.nix
          ./hosts/${name}/system.nix

          (mkCommonModule id name)
        ]
        ++ lib.optionals enableHome [
          inputs.home-manager.nixosModules.home-manager

          (
            { config, ... }:

            {
              home-manager = {
                extraSpecialArgs = specialArgs;
                users.${config.dotfyls.meta.user}.imports = mkHomeModules name;
              };
            }
          )
        ];
      }
    ) (lib.filterAttrs (_: host: host.enableSystem) hosts)
    // {
      # TODO: Combine with rest of config.
      installer = lib.nixosSystem {
        specialArgs = { inherit self; };
        modules = [ ./hosts/installer ];
      };
    };

  homeConfigurations = builtins.mapAttrs (
    name:
    { id, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs self; };
      modules = mkCommonModule id name ++ mkHomeModules name;
    }
  ) (lib.filterAttrs (_: host: !host.enableSystem && host.enableHome) hosts);

  inherit (import ./shared { inherit lib self; }) nixosModules homeModules;
}
