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

    default = "startpage";
    privateDefault = "startpage";

    order = [
      "startpage"
      "ddg"
      "google"
      "wikipedia"
      "nix-packages"
      "nix-options"
      "home-manager"
      "nerd-fonts"
    ];

    engines =
      let
        snowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      in
      {
        startpage = {
          name = "Startpage - English";
          icon = "https://www.startpage.com/favicon.ico";
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

        ddg.metaData.alias = "@d";
        google.metaData.alias = "@g";
        wikipedia.metaData.alias = "@w";

        nix-packages = {
          name = "Nix Search - Packages";
          icon = snowflakeIcon;
          iconMapObj."16" = "https://search.nixos.org/favicon.png";
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
        nix-options = {
          name = "Nix Search - Options";
          icon = snowflakeIcon;
          iconMapObj."16" = "https://search.nixos.org/favicon.png";
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

        home-manager = {
          name = "Home Manager Option Search";
          icon = "https://home-manager-options.extranix.com/images/favicon.png";
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

        nerd-fonts = {
          name = "Nerd Fonts";
          icon = "https://www.nerdfonts.com/assets/img/favicon.ico";
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

        bing.metaData.hidden = true;
      };
  };
}
