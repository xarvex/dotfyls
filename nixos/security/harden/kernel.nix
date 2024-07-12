{ config, lib, ... }:

{
  options.dotfyls.security.harden.kernel = {
    enable = lib.mkEnableOption "kernel security hardening" // { default = true; };
    packages = lib.mkEnableOption "hardened kernel packages" // { default = true; };
    poison = lib.mkEnableOption "poisoning of free'd pages" // { default = true; };
  };

  config =
    let
      cfg = config.dotfyls.security.harden.kernel;
    in
    lib.mkIf cfg.enable {
      # Use hardened kernel packages compatible with ZFS.
      dotfyls.kernels.variant = lib.mkIf cfg.packages (lib.mkDefault "hardened");

      boot = {
        kernelParams = [
          # Don't merge slabs.
          "slab_nomerge"

          # Overwrite free'd pages.
          "page_poison=${if cfg.poison then "on" else "off"}"

          # Enable page allocator randomization.
          "page_alloc.shuffle=1"

          # Disable debugfs.
          "debugfs=off"
        ];

        kernel.sysctl = {
          # Hide kptrs even for processes with CAP_SYSLOG.
          "kernel.kptr_restrict" = 2;

          # Disable bpf() JIT (to eliminate spray attacks).
          "net.core.bpf_jit_enable" = false;

          # Disable ftrace debugging
          "kernel.ftrace_enabled" = false;

          # Enable strict reverse path filtering (that is, do not attempt to route
          # packets that "obviously" do not belong to the iface's network; dropped
          # packets are logged as martians).
          "net.ipv4.conf.all.log_martians" = true;
          "net.ipv4.conf.all.rp_filter" = "1";
          "net.ipv4.conf.default.log_martians" = true;
          "net.ipv4.conf.default.rp_filter" = "1";

          # Ignore broadcast ICMP (mitigate SMURF).
          "net.ipv4.icmp_echo_ignore_broadcasts" = true;

          # Ignore incoming ICMP redirects (note: default is needed to ensure that
          # the setting is applied to interfaces added after the sysctls are set).
          "net.ipv4.conf.all.accept_redirects" = false;
          "net.ipv4.conf.all.secure_redirects" = false;
          "net.ipv4.conf.default.accept_redirects" = false;
          "net.ipv4.conf.default.secure_redirects" = false;
          "net.ipv6.conf.all.accept_redirects" = false;
          "net.ipv6.conf.default.accept_redirects" = false;

          # Ignore outgoing ICMP redirects (this is IPv4 only).
          "net.ipv4.conf.all.send_redirects" = false;
          "net.ipv4.conf.default.send_redirects" = false;
        };
      };

      # Hinders security, but necessary for most Electron apps.
      # Relevant when using the hardened kernel.
      # See: https://github.com/NixOS/nixpkgs/issues/97682
      security.unprivilegedUsernsClone = true;
    };
}
