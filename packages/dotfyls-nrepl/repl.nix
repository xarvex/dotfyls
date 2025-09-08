# https://bmcgee.ie/posts/2023/01/nix-and-its-slow-feedback-loop/#how-you-should-use-the-repl
#
# WARNING: Cannot use lib functions here, as a nixpkgs input is not guaranteed.
{ flakePath, host }:

let
  mkPkgsReplMembers = pkgs: {
    packages = pkgs;
    inherit pkgs;
    p = pkgs;
  };
  mkConfigurationRepl =
    configuration:
    let
      cfg = configuration.config;
    in
    {
      nixpkgs = configuration.pkgs;
      n = configuration.pkgs;

      inherit configuration;

      config = cfg;
      inherit cfg;
      c = cfg;

      inherit (cfg) dotfyls;
      dot = cfg.dotfyls;
      d = cfg.dotfyls;
    }
    // mkPkgsReplMembers configuration.pkgs;
  mkHomeReplMembers = cfg: {
    homeConfig = cfg;
    homeconfig = cfg;
    homeCfg = cfg;
    homecfg = cfg;
    hmConfig = cfg;
    hmconfig = cfg;
    hmCfg = cfg;
    hmcfg = cfg;
    hmC = cfg;
    hmc = cfg;
    hm = cfg;

    homeDotfyls = cfg.dotfyls;
    homedotfyls = cfg.dotfyls;
    homeDot = cfg.dotfyls;
    homedot = cfg.dotfyls;
    homeD = cfg.dotfyls;
    homed = cfg.dotfyls;
    hmDotfyls = cfg.dotfyls;
    hmdotfyls = cfg.dotfyls;
    hmDot = cfg.dotfyls;
    hmdot = cfg.dotfyls;
    hmD = cfg.dotfyls;
    hmd = cfg.dotfyls;
  };
  mkSystemRepl =
    configuration:
    let
      cfg = configuration.config;
    in
    {
      nixosConfiguration = configuration;
      nixosconfiguration = configuration;
      osConfiguration = configuration;
      osconfiguration = configuration;

      nixosConfig = cfg;
      nixosconfig = cfg;
      nixosCfg = cfg;
      nixoscfg = cfg;
      nixosC = cfg;
      nixosc = cfg;
      osConfig = cfg;
      osconfig = cfg;
      osCfg = cfg;
      oscfg = cfg;
      osC = cfg;
      osc = cfg;

      nixosDotfyls = cfg.dotfyls;
      nixosdotfyls = cfg.dotfyls;
      nixosDot = cfg.dotfyls;
      nixosdot = cfg.dotfyls;
      nixosD = cfg.dotfyls;
      nixosd = cfg.dotfyls;
      osDotfyls = cfg.dotfyls;
      osdotfyls = cfg.dotfyls;
      osDot = cfg.dotfyls;
      osdot = cfg.dotfyls;
      osD = cfg.dotfyls;
      osd = cfg.dotfyls;
    }
    // mkHomeReplMembers cfg.hm
    // mkConfigurationRepl configuration;
  mkHomeRepl =
    configuration:
    {
      homeConfiguration = configuration;
      homeconfiguration = configuration;
    }
    // mkHomeReplMembers configuration.config
    // mkConfigurationRepl configuration;

  flake = builtins.getFlake flakePath;
  hostRepls =
    (
      if flake ? homeConfigurations then
        builtins.mapAttrs (_: mkHomeRepl) flake.homeConfigurations
      else
        { }
    )
    // (
      if flake ? nixosConfigurations then
        builtins.mapAttrs (_: mkSystemRepl) flake.nixosConfigurations
      else
        { }
    );

  repl =
    flake
    // (
      if hostRepls == { } then
        if flake ? packages then
          mkPkgsReplMembers flake.packages.${builtins.currentSystem}
        else if flake ? legacyPackages then
          mkPkgsReplMembers flake.legacyPackages.${builtins.currentSystem}
        else
          { }
      else
        hostRepls // hostRepls.${host} or { }
    )
    // (
      let
        lib =
          flake.inputs.nixpkgs.lib or flake.inputs.nixpkgs-lib.lib or flake.inputs.nixpkgs-unstable.lib
            or null;
      in
      if lib == null then
        { }
      else
        {
          inherit lib;
          l = lib;
        }
    )
    // {
      b = builtins;

      inherit flake;
      self = flake;
    };
in
repl
// (
  if builtins.pathExists "${flake}/repl.nix" then
    let
      flakeRepl = import "${flake}/repl.nix";
      result = if builtins.isFunction flakeRepl then flakeRepl repl else flakeRepl;
    in
    {
      inherit result;
      r = result;
      out = result;
      o = result;
    }
  else
    { }
)
