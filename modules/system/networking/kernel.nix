{
  boot.kernel.sysctl = {
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
    "net.ipv6.conf.all.accept_redirects" = false;
    "net.ipv4.conf.default.accept_redirects" = false;
    "net.ipv4.conf.default.secure_redirects" = false;
    "net.ipv6.conf.default.accept_redirects" = false;

    # Ignore outgoing ICMP redirects (this is IPv4 only).
    "net.ipv4.conf.all.send_redirects" = false;
    "net.ipv4.conf.default.send_redirects" = false;
  };
}
