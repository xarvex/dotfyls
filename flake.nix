{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
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

  outputs = { nixpkgs, self, ... }@inputs:
    let
      system = "x86_64-linux";
      commonArgs = {
        inherit (nixpkgs) lib;
        inherit self inputs nixpkgs;

        pkgs = import nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };

        specialArgs = { inherit self inputs; };

        user = "xarvex";
      };
    in
    {
      nixosConfigurations = import ./hosts/nixos.nix commonArgs;
      homeConfigurations = import ./hosts/home.nix commonArgs;
    };
}
