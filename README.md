# dotfyls

```sh
nix run nixpkgs#nixos-generators -- --format iso --flake .#installer
```

or

```sh
nix build .#nixosConfigurations.installer.config.system.build.isoImage
```

## Legacy

Are you looking for my old dotfyls configurations?
They have all been consolidated into this repository, with the old put into a branch.

| Program | Location | Legacy Branch |
|---------|----------------------------------------------------|----------------|
| Firefox | ./modules/home/browsers/firefox | legacy-firefox |
| Neovim | ./modules/home/editors/neovim | legacy-neovim |
| WezTerm | ./modules/home/terminals/wezterm | legacy-wezterm |
| Zsh | ./modules/home/shells/zsh | legacy-zsh |
