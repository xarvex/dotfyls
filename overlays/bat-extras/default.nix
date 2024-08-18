final: prev:

(prev.bat-extras or { }) // {
  batman = prev.bat-extras.batman.overrideAttrs (o: {
    nativeBuildInputs = o.nativeBuildInputs ++ [ prev.installShellFiles ];
    postInstall = (o.postInstall or "") + ''
      installShellCompletion ${./completions}/batman.{bash,fish,zsh}
    '';
  });
}
