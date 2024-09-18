_:

{
  time.timeZone = "America/Chicago";

  i18n = {
    # Denmark (English) is closest to Sweden (English) which does not exist.
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "en_DK.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_DK.UTF-8";

      LANGUAGE = "en_US:en:C:sv_SE:sv";
    };
  };
}
