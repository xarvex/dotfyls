final: prev:

(prev.bat-extras or { }) // {
  batman = prev.bat-extras.batman.overrideAttrs (o: {
    postInstall = (o.postInstall or "") + ''
      mkdir -p $out/share/bash-completion/completions
      printf '%s\n' 'complete -F _comp_cmd_man batman' > $out/share/bash-completion/completions/batman

      mkdir -p $out/share/fish/vendor_completions.d
      printf '%s\n' 'complete batman --wraps man' > $out/share/fish/vendor_completions.d/batman.fish

      mkdir -p $out/share/zsh/site-functions
      cat << EOF > $out/share/zsh/site-functions/_batman
      #compdef batman
      _man "\$@"
      EOF
    '';
  });
}
