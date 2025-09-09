{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfyls.security.ssh;
in
{
  options.dotfyls.security.ssh = {
    enable = lib.mkEnableOption "OpenSSH" // {
      default = config.dotfyls.desktops.enable;
    };
    enableAgent = lib.mkEnableOption "OpenSSH agent" // {
      # default = config.dotfyls.desktops.enable;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        dotfyls.file.".ssh" = {
          mode = "0700";
          persist = true;
        };

        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;

          matchBlocks =
            let
              hardening = {
                addKeysToAgent = "no";
                controlMaster = "no";
                controlPath = "none";
                controlPersist = "no";
                forwardAgent = false;
                forwardX11 = false;
                forwardX11Trusted = false;
                hashKnownHosts = true;
                identitiesOnly = true;
                sendEnv = [ ];
                setEnv = { };

                extraOptions = {
                  GatewayPorts = "no";
                  HostbasedAuthentication = "no";
                  PermitLocalCommand = "no";
                  Protocol = "2";
                  StrictHostKeyChecking = "yes";
                  VerifyHostKeyDNS = "yes";
                };
              };

              mkGitHost =
                host: userKnownHosts:
                lib.recursiveUpdate hardening {
                  inherit host;

                  addKeysToAgent = lib.mkIf cfg.enableAgent "2m";
                  hashKnownHosts = false;
                  user = "git";
                  userKnownHostsFile = "${pkgs.writeText "ssh-user-known-hosts-${host}" userKnownHosts}";

                  extraOptions = {
                    ConnectionAttempts = "3";
                    KbdInteractiveAuthentication = "no";
                    PasswordAuthentication = "no";
                    PreferredAuthentications = "publickey";
                  };
                };
            in
            {
              "*" = lib.recursiveUpdate hardening {
                userKnownHostsFile = "${config.xdg.configHome}/ssh/known_hosts";

                extraOptions.StrictHostKeyChecking = "ask";
              };

              "codeberg.org" = mkGitHost "codeberg.org" ''
                codeberg.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVIC02vnjFyL+I4RHfvIGNtOgJMe769VTF1VR4EB3ZB
                codeberg.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8hZi7K1/2E2uBX8gwPRJAHvRAob+3Sn+y2hxiEhN0buv1igjYFTgFO2qQD8vLfU/HT/P/rqvEeTvaDfY1y/vcvQ8+YuUYyTwE2UaVU5aJv89y6PEZBYycaJCPdGIfZlLMmjilh/Sk8IWSEK6dQr+g686lu5cSWrFW60ixWpHpEVB26eRWin3lKYWSQGMwwKv4LwmW3ouqqs4Z4vsqRFqXJ/eCi3yhpT+nOjljXvZKiYTpYajqUC48IHAxTWugrKe1vXWOPxVXXMQEPsaIRc2hpK+v1LmfB7GnEGvF1UAKnEZbUuiD9PBEeD5a1MZQIzcoPWCrTxipEpuXQ5Tni4mN
                codeberg.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL2pDxWr18SoiDJCGZ5LmxPygTlPu+cCKSkpqkvCyQzl5xmIMeKNdfdBpfbCGDPoZQghePzFZkKJNR/v9Win3Sc=
              '';
              "github.com" = mkGitHost "github.com" ''
                github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
                github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
                github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
              '';
              "gitlab.com" = mkGitHost "gitlab.com" ''
                gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
                gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
                gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=
              '';
            };
        };
      }

      (
        # TODO: Get this working at all.
        let
          # HACK: `ssh-agent` cannot use credentials without this.
          # See: https://github.com/nix-community/home-manager/issues/5194
          # From: https://github.com/NixOS/nixpkgs/blob/430e9d75945118f91f2972c3926a183f632b0817/nixos/modules/programs/ssh.nix#L14-L18
          askPasswordWrapper =
            pkgs.writeScript "ssh-askpass-wrapper"
              # bash
              ''
                #!${pkgs.runtimeShell} -e
                eval export $(systemctl --user show-environment | ${lib.getExe pkgs.gnugrep} -E '^(DISPLAY|WAYLAND_DISPLAY|XAUTHORITY)=')
                exec ${config.home.sessionVariables.SSH_ASKPASS} "''${@}"
              '';
        in
        lib.mkIf cfg.enableAgent {
          home.sessionVariables.SSH_ASKPASS = "${pkgs.gcr_4}/libexec/gcr4-ssh-askpass";

          services.ssh-agent.enable = true;

          # Adapted: https://github.com/NixOS/nixpkgs/blob/430e9d75945118f91f2972c3926a183f632b0817/nixos/modules/programs/ssh.nix#L393-L397
          systemd.user.services.ssh-agent.Service.Environment = [
            "DISPLAY=fake"
            "SSH_ASKPASS=${askPasswordWrapper}"
          ];
        }
      )
    ]
  );
}
