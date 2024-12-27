{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.browsers.firefox;
in
lib.mkIf (cfg'.enable && cfg.enable) {
  programs.firefox.profiles.${config.home.username}.search = {
    force = true;

    default = "Startpage - English";
    privateDefault = "Startpage - English";

    order = [
      "Startpage - English"
      "DuckDuckGo"
      "Google"
      "Wikipedia (en)"
      "Nix Search - Packages"
      "Nix Search - Options"
      "Home Manager Option Search"
      "Nerd Fonts"
    ];

    engines =
      let
        snowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      in
      {
        "Startpage - English" = {
          iconURL = "https://www.startpage.com/favicon.ico";
          definedAliases = [
            "@startpage"
            "startpage"
          ];
          urls = [
            {
              template = "https://www.startpage.com/do/dsearch";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
                {
                  name = "language";
                  value = "english";
                }
                {
                  name = "cat";
                  value = "web";
                }
              ];
            }
            {
              type = "application/x-suggestions+json";
              template = "https://www.startpage.com/suggestions";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
                {
                  name = "lui";
                  value = "english";
                }
                {
                  name = "format";
                  value = "opensearch";
                }
                {
                  name = "segment";
                  value = "startpage.defaultffx";
                }
              ];
            }
          ];

          metaData.alias = "@s";
        };

        "DuckDuckGo".metaData.alias = "@d";
        "Google".metaData.alias = "@g";
        "Wikipedia (en)".metaData.alias = "@w";

        "Nix Search - Packages" = {
          icon = snowflakeIcon;
          definedAliases = [ "@nixpackages" ];
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
              ];
            }
          ];

          metaData.alias = "@np";
        };
        "Nix Search - Options" = {
          icon = snowflakeIcon;
          definedAliases = [ "@nixoptions" ];
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
              ];
            }
          ];

          metaData.alias = "@no";
        };

        "Home Manager Option Search" = {
          icon = snowflakeIcon;
          definedAliases = [ "@homemanager" ];
          urls = [
            {
              template = "https://home-manager-options.extranix.com";
              params = [
                {
                  name = "release";
                  value = "master";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          metaData.alias = "@hm";
        };

        "Nerd Fonts" = {
          iconURL = "https://www.nerdfonts.com/assets/img/favicon.ico";
          definedAliases = [ "@nerdfonts" ];
          urls = [
            {
              template = "https://www.nerdfonts.com/cheat-sheet";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          metaData.alias = "@nf";
        };

        "Bing".metaData.hidden = true;
      };
  };
}
