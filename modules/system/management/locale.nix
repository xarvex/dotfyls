{ config, lib, ... }:

{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = lib.unique (
      map
        (
          locale:
          (builtins.replaceStrings [ "utf8" "utf-8" "UTF8" ] [ "UTF-8" "UTF-8" "UTF-8" ] locale) + "/UTF-8"
        )
        (
          [
            "C.UTF-8"
            "en_US.UTF-8"
            "sv_SE.UTF-8"
            config.i18n.defaultLocale
          ]
          ++ (builtins.attrValues (
            (builtins.removeAttrs config.i18n.extraLocaleSettings [ "LANGUAGE" ])
            // (lib.filterAttrs (_: locale: locale != null) config.hm.home.language)
          ))
        )
    );
  };
}
