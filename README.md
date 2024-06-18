```sh
mkdir -p /tmp/config/etc
git clone git@gitlab.com:dotfyls/dotfyls.git /tmp/config/etc/nixos
# git clone https://gitlab.com/dotfyls/dotfyls.git /tmp/config/etc/nixos
sudo nix run 'github:nix-community/disko#disko-install' -- --flake '/tmp/config/etc/nixos#host' --disk main /dev/sda
```
