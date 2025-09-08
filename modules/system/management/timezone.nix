{ config, lib, ... }:

lib.mkIf (config.time.timeZone == null) {
  # TODO: Does not function as `/etc/localtime` is a symlink to a timezone.
  # See: https://github.com/nix-community/impermanence/issues/153
  # dotfyls.file."/etc/localtime" = lib.mkIf (config.time.timeZone == null) {
  #   dir = false;
  #   cache = true;
  # };

  security.polkit.extraConfig =
    # javascript
    ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.timedate1.set-timezone"
            && subject.user == "${config.dotfyls.meta.user}") {
          return polkit.Result.YES;
        }
      });
    '';
}
