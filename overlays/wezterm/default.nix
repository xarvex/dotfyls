_: prev:

# Use until release made and available with fix.
prev.wezterm.overrideAttrs (o: {
  # https://github.com/wez/wezterm/pull/5264
  patches = (o.patches or [ ]) ++ [ ./5264.patch ];
})
