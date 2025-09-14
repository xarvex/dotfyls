{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg' = config.dotfyls.shells.tools;
  cfg = cfg'.starship;

  iCfg = config.dotfyls.icon;
in
{
  options.dotfyls.shells.tools.starship.enable = lib.mkEnableOption "Starship" // {
    default = cfg'.enableFun;
  };

  config = lib.mkIf cfg.enable {
    dotfyls.shells.bash.blesh.initExtra =
      let
        tput = lib.getExe' pkgs.ncurses "tput";
      in
      # bash
      ''
        bleopt prompt_ps1_final="$(${tput} setaf 2)${config.dotfyls.icon.general.prompt}$(${tput} sgr0) "
      '';

    programs = {
      fish.interactiveShellInit = lib.mkAfter (
        let
          starship = self.lib.getCfgExe config.programs.starship;
        in
        # fish
        ''
          function starship_transient_prompt_func
              ${starship} module character
          end

          if functions -q transient_execute
              functions -c transient_execute _starship_transient_execute

              function transient_execute
                  commandline -f expand-abbr
                  _starship_transient_execute
              end
          end
        ''
      );

      starship = {
        enable = true;
        enableTransience = true;

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
              "([${iCfg.general.branch}](cyan)$git_branch$git_status$git_state )"
              "$nix_shell"

              "$fill"

              "$cmd_duration"
              "( $shlvl)"
              "( [](${bubbleStyle})$time)"

              "$line_break"

              "$character"
            ];

            character = {
              success_symbol = "[${lib.trimWith { end = true; } iCfg.general.prompt}](bold green)";
              error_symbol = "[${lib.trimWith { end = true; } iCfg.general.prompt}](bold red)";
              vimcmd_symbol = "[${lib.trimWith { end = true; } iCfg.general.vim}](bold blue)";
              vimcmd_replace_one_symbol = "[${lib.trimWith { end = true; } iCfg.general.vim}](bold yellow)";
              vimcmd_replace_symbol = "[${lib.trimWith { end = true; } iCfg.general.vim}](bold yellow)";
              vimcmd_visual_symbol = "[${lib.trimWith { end = true; } iCfg.general.vim}](bold purple)";
            };
            cmd_duration = {
              min_time = 10000;
              style = "dimmed white";
              format = "[$duration]($style)";
            };
            directory = rec {
              format = "[ $path ]($style)[$read_only]($read_only_style)";
              style = "${innerBubbleStyle} fg:bold black";
              read_only = iCfg.file.lock;
              read_only_style = style;
              home_symbol = iCfg.general.home;

              substitutions = {
                inherit (iCfg.byDirname)
                  Desktop
                  Documents
                  Downloads
                  Music
                  Pictures
                  Public
                  Templates
                  Videos
                  ;
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
              stashed = iCfg.general.stash;
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
              symbol = iCfg.code.nix;
              style = "magenta";
              impure_msg = "";
              pure_msg = "";
            };
            shlvl = {
              format = "[$symbol$shlvl]($style)";
              symbol = iCfg.general.layer;
              style = "green";
              disabled = false;
            };
            time = {
              format = "[ ${iCfg.general.clock}$time ]($style)";
              time_format = "%H:%M";
              style = innerBubbleStyle;
              disabled = false;
            };
            username = {
              style_root = edgeBubbleInnerStyle;
              style_user = edgeBubbleInnerStyle;
              format = "[ $user ]($style)";
            };
          };
      };
    };
  };
}
