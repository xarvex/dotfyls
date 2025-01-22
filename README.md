# dotfyls

```sh
nix run nixpkgs#nixos-generators -- --format iso --flake .#installer
```
or
```sh
nix build .#nixosConfigurations.installer.config.system.build.isoImage
```

## Legacy

Are you looking for my old dotfyls configs?
They have all been consolidated into this repository, with the old put into a branch.

| Program | Location                                           | Legacy Branch  |
|---------|----------------------------------------------------|----------------|
| Firefox | ./modules/home/browsers/firefox                    | legacy-firefox |
| Neovim  | ./modules/home/files/neovim/nvim                   | legacy-neovim  |
| WezTerm | ./modules/home/terminals/terminals/wezterm/wezterm | legacy-wezterm |
| Zsh     | ./modules/home/shells/shells/zsh                   | legacy-zsh     |
