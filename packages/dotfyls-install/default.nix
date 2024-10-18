{
  git,
  writeShellApplication,
}:

writeShellApplication {
  name = "dotfyls-pamu2fcfg";

  runtimeInputs = [ git ];

  text = builtins.readFile ./script.sh;
}
