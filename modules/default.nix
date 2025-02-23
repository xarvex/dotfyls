{
  inputs,
  lib,
  self,
}:

let
  hosts =
    let
      mkHost = id: system: {
        enableHome = true;
        enableSystem = true;
        inherit
          id
          system
          ;
        user = "xarvex";
      };
    in
    {
      artemux = mkHost "fd9daca2" "x86_64-linux";
      matrix = mkHost "3bb44cc9" "x86_64-linux" // {
        user = "neo";
      };
      pioneer = mkHost "3540bf30" "x86_64-linux";
      sentinel = mkHost "ef01cd45" "x86_64-linux";
    };

  mkPkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "corefonts"
          "discord"
          "nvidia-settings"
          "nvidia-x11"
          "obsidian"
          "spotify"
          "steam"
          "steam-original"
          "steam-run"
          "steam-unwrapped"
          "vintagestory"
          "vista-fonts"
          "zsh-abbr"
        ];
    };
in
{
  nixosConfigurations =
    builtins.mapAttrs (
      hostname:
      {
        enableHome,
        id,
        system,
        user,
        ...
      }:
      lib.nixosSystem rec {
        pkgs = mkPkgs system;

        specialArgs = { inherit inputs self user; };
        modules =
          [
            ./system
            ./hosts/${hostname}/hardware.nix
            ./hosts/${hostname}/system.nix

            {
              networking = {
                hostId = id;
                hostName = hostname;
              };
            }
          ]
          ++ lib.optionals enableHome [
            inputs.home-manager.nixosModules.home-manager

            {
              home-manager = {
                extraSpecialArgs = specialArgs;
                users.${user}.imports = [
                  ./home
                  ./hosts/${hostname}/home.nix
                ];
              };
            }
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
    hostname:
    { system, user, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs system;

      extraSpecialArgs = { inherit inputs self user; };
      modules = [
        ./home
        ./hosts/${hostname}/home.nix
      ];
    }
  ) (lib.filterAttrs (_: host: host.enableHome) hosts);

  inherit (import ./shared { inherit lib; }) nixosModules homeManagerModules;
}
