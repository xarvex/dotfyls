{
  coreutils,
  pam_u2f,
  writeShellApplication,
}:

writeShellApplication {
  name = "dotfyls-pamu2fcfg";

  runtimeInputs = [
    coreutils
    pam_u2f
  ];

  text = builtins.readFile ./script.sh;
}
