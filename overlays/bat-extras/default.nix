_: final: prev:

prev.bat-extras
// {
  batman = prev.bat-extras.batman.overrideAttrs (o: {
    nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ final.installShellFiles ];

    postInstall =
      (o.postInstall or "")
      + ''
        installShellCompletion \
          ${./completions/batman.bash} \
          ${./completions/batman.fish} \
          ${./completions/batman.zsh}
      '';
  });
}
