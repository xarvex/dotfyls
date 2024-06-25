{ ... }:

{
  nix =
    let
      nixPath = [
        "nixpkgs=flake:nixpkgs"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    in
    {
      inherit nixPath;

      channel.enable = false;

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 14d";
      };

      settings = {
        nix-path = nixPath;

        auto-optimise-store = true;
        use-xdg-base-directories = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };
}
