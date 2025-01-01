{
  dotfyls,
  lib,
  pkgs,
}:

lib.recursiveUpdate dotfyls {
  name = "${dotfyls.name} - WezTerm";

  languages.lua = {
    enable = true;
    package = pkgs.luajit;
  };
}
