_:

{
  boot = {
    # Disallow editing boot parameters.
    loader.systemd-boot.editor = false;

    blacklistedKernelModules = [
      # Obscure network protocols:
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems:
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];
  };
}
