{
  description = "Personal Firefox";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
  };

  outputs = { flake-parts, nixpkgs, self, systems, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { system, ... }:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # TODO
      };

    flake.homeManagerModules = rec {
      default = firefox;

      firefox = ({ config, lib, pkgs, ... }: lib.mkIf config.programs.firefox.enable {
        programs.firefox = {
          profiles.${config.home.username} = {
            extraConfig = ''
              ${builtins.readFile "${pkgs.arkenfox-userjs}/user.js"}

              ${builtins.readFile ./user-overrides.js}
            '';

            search = {
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
              ];

              engines =
                let
                  snowflake_icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                in
                {
                  "Startpage - English" = {
                    iconURL = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAEqUlEQVRYR71Xa0xcRRT+ZtlSEaRYUNFaI7ESqkgLUrWa9oe10WDVxvDDCgKpNESradVidRUfRFvjWmspiUkjBtIoUlGJJKslPprGgDYEq5akRokFagEBrSAW9nHHM/d9d+/u3Y3KJIS7954555vzzfnmDOOc5waDvBngN9BfEuZhcM7AGOtxu1kVCwSkbkBaPQ9x7UL0ML8/xM1fGKM8mN78n7/Jd4gyEFTDUWRYsNBv8zuyDgHDZ4DfJgB/AEg9H7j8UiBrMRcpdZxv+DdsTQCikzDzN0PXEYaeXmCani0ZI9BLCMRtazhWrQRcrvBFxCY3goJw84FBoOldhj+nlC/CvRmCFk68y1sGbN7E5czEO2ICEMEbmxj8/njdAZdRNh6v4Ug5L745YRQY3Ii0v7SX4ew0lYy8dForPSxdAiynlaakcExMMhzvB4St8p3JGSrK56guE/vCbk+Z80g2xia0Iu741IXDxLs2FiZzVJRyFF4n4hiOz80yvNfBcOy4sFTsBYztWzhyr3LeD7YAQiGGp3cxTM9oDoGaCgkrrrF3KEkMb7Yw9J8kexVzUQFl4X7JkQd5D4TX+uBp4NVGY/XLcoDHiFdt2GnD2Djw4h5BhWKVmko+6pQfsbTEVge+6WNoOSQAKCA2rJdQsk7jzn5RQl4PtjP8ftb4/lAlh6BOGXY6QW/t9sDAKYZfhoCLMoFF6UJogLRUZz4d821j4KgD8TvlGBoeIQYUoAvcbirJSxyn254FYlaIdHeS8jkyMo5zs3O4cVWBnMZwPrUI3584idKy7XrA6wuvRWvznggAEfvBjoKpqRncWlJF6veX7qDlwG7cfBNprT4MToNBCQ9U70Rv3wn96yM1Zdi2tTxGBpT5UXVgW+1u+A4f1R1kLs7AgcZ6FORfbXE6O+uH54U30On7UnlPDCS5Xej6uAlXLM12piCaEJ0aOoO7Sx+W0685di9IQsnta7HmlmKkX5CGn0ir29p9GD49ajkkNt61Dt6XdzgGl2sjEAhRU2RKrKkf6PR9gR0eL7gkZFY9hlTJ1aRXA2c+oby7anHPnXLdxtQAFUDsfqCj8zM8W9+AuTnTiSRjMZ2LYUfkhRnp6GhrpCq4WOFEgWL7HFc/8PPAEF55/S0c/aqXFk4OtYCq7+zsLIyOUZei7gHxb+WKPLzzthfJye6YVCSkA8O/jqC751sMUltEewdZmRkUaDmKC/NRV78P7R91WRZbWb4RzzxZo67eHkdCAGItxU9NQ9nmWnz3w48Ws4bXPLhj/dqoU6P2A/barR1QYRyo7kfHJnHvpkcxPvGHHjCN2qMPWxuQcyU1EvpONebHtQfiqifVqLevHxVbnpIp0kZebg4OHdxLTczCCFf/OQARofV9H56r329pHp/3bEX5fRsiAdj1A+FWid4NRJnUUem2ffCJXhk7n6jGg5WlSkGatCahe0HkvcEM1Xre++niIETs8yNfo7goH/u8HmQsSpsfCsxRJFJRl8t6l7DAJikOkrbMy6U0klrlNOymdkq/nMo3LBrm88GC2MSfXXUkMl/ckJlyPQ81U8DV2mTFsX0PZwT9N98Z3TL5Mbc7qeof3CAjSEk+uwsAAAAASUVORK5CYII=";
                    definedAliases = [ "@startpage" "startpage" ];
                    urls = [
                      {
                        template = "https://www.startpage.com/do/dsearch";
                        params = [
                          { name = "q"; value = "{searchTerms}"; }
                          { name = "language"; value = "english"; }
                          { name = "cat"; value = "web"; }
                        ];
                      }
                      {
                        type = "application/x-suggestions+json";
                        template = "https://www.startpage.com/suggestions";
                        params = [
                          { name = "q"; value = "{searchTerms}"; }
                          { name = "lui"; value = "english"; }
                          { name = "format"; value = "opensearch"; }
                          { name = "segment"; value = "startpage.defaultffx"; }
                        ];
                      }
                    ];

                    metaData.alias = "@s";
                  };

                  "DuckDuckGo".metaData.alias = "@d";
                  "Google".metaData.alias = "@g";
                  "Wikipedia (en)".metaData.alias = "@w";

                  "Nix Search - Packages" = {
                    icon = snowflake_icon;
                    definedAliases = [ "@nixpackages" ];
                    urls = [{
                      template = "https://search.nixos.org/packages";
                      params = [
                        { name = "query"; value = "{searchTerms}"; }
                        { name = "channel"; value = "unstable"; }
                      ];
                    }];

                    metaData.alias = "@np";
                  };
                  "Nix Search - Options" = {
                    icon = snowflake_icon;
                    definedAliases = [ "@nixoptions" ];
                    urls = [{
                      template = "https://search.nixos.org/options";
                      params = [
                        { name = "query"; value = "{searchTerms}"; }
                        { name = "channel"; value = "unstable"; }
                      ];
                    }];

                    metaData.alias = "@no";
                  };

                  "Home Manager Option Search" = {
                    icon = snowflake_icon;
                    definedAliases = [ "@homemanager" ];
                    urls = [{
                      template = "https://home-manager-options.extranix.com";
                      params = [
                        { name = "release"; value = "master"; }
                        { name = "query"; value = "{searchTerms}"; }
                      ];
                    }];

                    metaData.alias = "@hm";
                  };

                  "Bing".metaData.hidden = true;
                };
            };
          };
        };
      });
    };
  };
}
