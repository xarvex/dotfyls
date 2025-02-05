{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg'' = config.dotfyls.development;
  cfg' = cfg''.languages;
  cfg = cfg'.rust;
in
{
  options.dotfyls.development.languages.rust.enable = lib.mkEnableOption "Rust" // {
    default = cfg'.defaultEnable;
  };

  config = lib.mkIf (cfg''.enable && cfg.enable) {
    dotfyls = {
      development = {
        tools = with pkgs; [
          cargo
          clippy
          rust-analyzer
          rustc
          rustfmt
          vscode-extensions.vadimcn.vscode-lldb.adapter
        ];
        languages.servers.rust_analyzer.settings.rust-analyzer = {
          hover = {
            gotoTypeDef.enable = false;
            implementations.enable = false;
          };
          imports.granularity.enforce = true;
          procMacro.ignored = {
            async-recursion = [ "async_recursion" ];
            async-trait = [ "async_trait" ];
            leptos_macro = [ "server" ];
            napi-derive = [ "napi" ];
          };
          typing.triggerChars = "=.{><";
          files.excludeDirs = cfg''.ignoreDirs;
        };
      };

      file = {
        ".local/share/cargo".cache = true;

        ".local/share/rustup".cache = true;
      };
    };

    home = {
      packages = [ pkgs.mold-wrapped ];
      sessionVariables = rec {
        RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
        RUSTFLAGS = "-C link-arg=-fuse-ld=mold";
        RUSTDOCFLAGS = RUSTFLAGS;

        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        CARGO_TARGET_DIR = "${config.home.sessionVariables.CARGO_HOME}/target";

        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      };
    };
  };
}
