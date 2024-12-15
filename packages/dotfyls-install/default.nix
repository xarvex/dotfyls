{
  git,
  writeShellApplication,
}:

writeShellApplication {
  name = "dotfyls-install";

  runtimeInputs = [ git ];

  text = builtins.readFile ./script.sh;
}
