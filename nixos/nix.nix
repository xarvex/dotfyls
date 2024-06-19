{ ... }:

{
  nix = {
    channel.enable = false;

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };

    settings = {
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
