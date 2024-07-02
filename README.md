# dotfyls

```sh
nix run nixpkgs#nixos-generators -- --format iso --flake .#installer
```
or
```sh
nix build .#nixosConfigurations.installer.config.system.build.isoImage
```
