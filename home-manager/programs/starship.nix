{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.programs.starship;
in
{
  imports = [
    (self.lib.mkAliasPackageModule
      [
        "dotfyls"
        "programs"
        "starship"
      ]
      [
        "programs"
        "starship"
      ]
    )
  ];

  options.dotfyls.programs.starship.enable = lib.mkEnableOption "Starship" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      settings =
        let
          bubbleStyle = "blue";
          innerBubbleStyle = "fg:black bg:${bubbleStyle}";

          edgeBubbleStyle = "green";
          edgeBubbleInnerStyle = "fg:black bg:${edgeBubbleStyle}";

          transitionBubbleStyle = "fg:${edgeBubbleStyle} bg:${bubbleStyle}";
        in
        {
          format = lib.concatStrings [
            "($username$hostname[](${transitionBubbleStyle}))"
            "($directory[](${bubbleStyle}) )"
            "([](cyan) $git_branch$git_status$git_state )"
            "$nix_shell"

            "$fill"

            "$cmd_duration"
            "( $shlvl)"
            "( [](${bubbleStyle})$time)"

            "$line_break"

            "$character"
          ];

          character = {
            success_symbol = "[❯](purple)";
            error_symbol = "[ ](bold red)";
            vimcmd_symbol = "[](green)";
          };
          cmd_duration = {
            min_time = 10000;
            style = "dimmed white";
            format = "[$duration]($style)";
          };
          directory = rec {
            format = "[ $path ]($style)[$read_only]($read_only_style)";
            style = "${innerBubbleStyle} fg:bold black";
            read_only = "󰌾 ";
            read_only_style = style;
            home_symbol = " ";

            substitutions = {
              "Documents" = "󰈙 ";
              "Downloads" = " ";
              "Music" = "󰧔 ";
              "Pictures" = " ";
              "Videos" = "󰨛 ";
            };
          };
          fill.symbol = " ";
          git_branch = {
            symbol = "";
            format = "[$branch]($style)";
            style = "cyan";
            only_attached = true;
          };
          git_commit = {
            format = "[($hash$tag)]($style)";
            style = "cyan";
            only_detached = true;
            tag_disabled = false;
          };
          git_state = {
            format = "([$state( $progress_current/$progress_total)]($style))";
            style = "black";
          };
          git_status = {
            format = "[[(*$conflicted$deleted$renamed$modified$typechanged$staged)($untracked)](red)( $ahead_behind$stashed)]($style)";
            conflicted = "​";
            stashed = "≡";
            modified = "​";
            staged = "​";
            renamed = "​";
            deleted = "​";
            typechanged = "​";
            style = "purple";
          };
          hostname = {
            ssh_symbol = "󰌘 ";
            format = "[ $ssh_symbol$hostname ]($style)";
            style = edgeBubbleInnerStyle;
          };
          line_break.disabled = false;
          nix_shell = {
            format = "[$symbol]($style)";
            symbol = " ";
            style = "magenta";
            impure_msg = "";
            pure_msg = "";
          };
          shlvl = {
            format = "[$symbol$shlvl]($style)";
            symbol = "󰽘 ";
            style = "green";
            disabled = false;
          };
          time = {
            format = "[  $time ]($style)";
            time_format = "%H:%M";
            style = innerBubbleStyle;
            disabled = false;
          };
          username = rec {
            style_root = style_user;
            style_user = edgeBubbleInnerStyle;
            format = "[ $user ]($style)";
          };
        };
    };
  };
}
