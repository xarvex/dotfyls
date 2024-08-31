_:

{
  time.timeZone = "America/Chicago";

  i18n = {
    # Denmark (English) is closest to Sweden (English) which does not exist.
    defaultLocale = "en_DK.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_DK.UTF-8";
      LC_IDENTIFICATION = "en_DK.UTF-8";
      LC_MEASUREMENT = "en_DK.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_DK.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_DK.UTF-8";
      LC_TELEPHONE = "en_DK.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };
}
