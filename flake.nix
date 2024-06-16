{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "gitlab:dotfyls/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, self, ... }@inputs:
    let
      system = "x86_64-linux";
      commonArgs = {
        inherit (nixpkgs) lib;
        inherit self inputs nixpkgs;

        pkgs = import nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;

          config.allowUnfree = true;
        };

        specialArgs = { inherit self inputs; };

        user = "xarvex";
      };
    in
    {
      nixosConfigurations = import ./host/nixos.nix commonArgs;
      homeConfigurations = import ./host/home.nix commonArgs;
    };
}
