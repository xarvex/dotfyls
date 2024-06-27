{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    persistwd = {
      url = "gitlab:/xarvex/persistwd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "gitlab:dotfyls/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "gitlab:dotfyls/wezterm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      commonArgs = {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs;

        pkgs = import nixpkgs {
          system = "x86_64-linux";

          config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
            "discord"
            "spotify"
          ];
        };

        user = "xarvex";
      };
    in
    {
      nixosConfigurations = import ./hosts/nixos.nix commonArgs;
      homeConfigurations = import ./hosts/home.nix commonArgs;
    };
}
