{ config, lib, ... }:

let
  cfg = config.dotfyls.boot.kernel.harden;
in
{
  options.dotfyls.boot.kernel.harden = {
    enable = lib.mkEnableOption "kernel hardening" // {
      default = true;
    };
    enablePatches = lib.mkEnableOption "kernel hardening patches";

    poison = lib.mkEnableOption "poisoning of free'd pages" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # Hinders kernel security, but is essential to browser sandboxing.
    # Other processes require this, too, for example rootless containers.
    # Relevant when using the hardened kernel where this is disabled.
    # See: https://github.com/NixOS/nixpkgs/issues/97682
    # See: https://discourse.nixos.org/t/proposal-to-deprecate-the-hardened-profile/63081/5
    security.unprivilegedUsernsClone = lib.mkIf config.boot.kernelPackages.kernel.isHardened true;

    boot = {
      kernelParams = [
        # Don't merge slabs.
        "slab_nomerge"

        # Overwrite memory with zeros.
        "init_on_alloc=1"
        "init_on_free=1"

        # Poison freed pages.
        "page_poison=${if cfg.poison then "on" else "off"}"

        # Randomize page allocation.
        "page_alloc.shuffle=1"

        # Randomize kernel stack offset.
        "randomize_kstack_offset=on"

        # Disable debugfs.
        "debugfs=off"
      ];
      kernel.sysctl = {
        # Disable SysRq key.
        "kernel.sysrq" = false;

        # Enable kernel address space randomization.
        "kernel.randomize_va_space" = 2;

        # Hide kptrs even for processes with CAP_SYSLOG.
        "kernel.kptr_restrict" = 2;

        # Disable ftrace debugging.
        "kernel.ftrace_enabled" = false;

        # Disable ptrace debugging even for processes with CAP_SYS_PTRACE.
        "kernel.yama.ptrace_scope" = 3;

        # Restrict eBPF JIT.
        "kernel.unprivileged_bpf_disabled" = true;
        "net.core.bpf_jit_harden" = 2;

        # Restrict userfaultfd() system call.
        "vm.unprivileged_userfaultfd" = false;
      };

      kernelPatches = lib.mkIf cfg.enablePatches [
        {
          name = "bpf-jit-always";
          patch = null;
          extraStructuredConfig.BPF_JIT_ALWAYS_ON = lib.mkForce lib.kernel.yes;
        }
      ];
    };
  };
}
