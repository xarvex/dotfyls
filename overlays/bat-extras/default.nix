_: prev:

prev.bat-extras
// {
  batman = prev.bat-extras.batman.overrideAttrs (o: {
    nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ prev.installShellFiles ];

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
