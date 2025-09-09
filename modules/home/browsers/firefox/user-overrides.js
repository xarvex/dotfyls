user_pref("__user-overrides.js.cat", "START: Should we observe the box?");

/*** [SECTION 0000]: DOTFYLS ***/
// These are user preferences not found in Arkenfox nor Narsil's user.js.
user_pref("browser.bookmarks.addedImportButton", false);
user_pref("browser.migrate.content-modal.import-all.enabled", false);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("extensions.autoDisableScopes", 0);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("media.ffmpeg.encoder.enabled", true);
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
user_pref("widget.use-xdg-desktop-portal.location", 1);
user_pref("widget.use-xdg-desktop-portal.mime-handler", 1);
user_pref("widget.use-xdg-desktop-portal.native-messaging", 1);
user_pref("widget.use-xdg-desktop-portal.open-uri", 1);
user_pref("widget.use-xdg-desktop-portal.settings", 1);

/*** [SECTION 0100]: STARTUP ***/
user_pref("__user-overrides.js.cat", "0100 Error: The cat is dead!");
user_pref("browser.shell.checkDefaultBrowser", false);

user_pref("browser.topsites.contile.enabled", false);
user_pref("browser.topsites.useRemoteSetting", false);

/*** [SECTION 0200]: GEOLOCATION ***/
user_pref("__user-overrides.js.cat", "0200 Error: The cat is dead!");
user_pref("geo.provider.network.url", "");
user_pref("geo.provider.network.logging.enabled", true);

user_pref("geo.provider.geoclue.always_high_accuracy", false);
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);

/*** [SECTION 0300]: QUIETER FOX ***/
user_pref("__user-overrides.js.cat", "0300 Error: The cat is dead!");

user_pref("browser.shopping.experience2023.opted", 2);
user_pref("browser.shopping.experience2023.active", false);
user_pref("browser.search.serpEventTelemetry.enabled", false);
user_pref("corroborator.enabled", false);
user_pref("browser.contentblocking.database.enabled", false);
user_pref("browser.contentblocking.cfr-milestone.enabled", false);
user_pref("default-browser-agent.enabled", false);
user_pref("browser.contentblocking.reportBreakage.url", "");
user_pref("browser.contentblocking.report.cookie.url", "");
user_pref("browser.contentblocking.report.cryptominer.url", "");
user_pref("browser.contentblocking.report.fingerprinter.url", "");
user_pref("browser.contentblocking.report.lockwise.enabled", false);
user_pref("browser.contentblocking.report.lockwise.how_it_works.url", "");
user_pref("browser.contentblocking.report.manage_devices.url", "");
user_pref("browser.contentblocking.report.monitor.enabled", false);
user_pref("browser.contentblocking.report.monitor.how_it_works.url", "");
user_pref("browser.contentblocking.report.monitor.sign_in_url", "");
user_pref("browser.contentblocking.report.monitor.url", "");
user_pref("browser.contentblocking.report.proxy.enabled", false);
user_pref("browser.contentblocking.report.proxy_extension.url", "");
user_pref("browser.contentblocking.report.social.url", "");
user_pref("browser.contentblocking.report.tracker.url", "");
user_pref("browser.contentblocking.report.endpoint_url", "");
user_pref("browser.contentblocking.report.monitor.home_page_url", "");
user_pref("browser.contentblocking.report.monitor.preferences_url", "");
user_pref("browser.contentblocking.report.vpn.enabled", false);
user_pref("browser.contentblocking.report.hide_vpn_banner", true);
user_pref("browser.contentblocking.report.show_mobile_app", false);
user_pref("browser.vpn_promo.enabled", false);
user_pref("browser.promo.focus.enabled", false);
user_pref("app.feedback.baseURL", "");
user_pref("app.support.baseURL", "");
user_pref("app.releaseNotesURL", "");
user_pref("app.update.url.details", "");
user_pref("app.update.url.manual", "");
user_pref("app.update.staging.enabled", false);
user_pref("gecko.handlerService.schemes.mailto.0.uriTemplate", "");
user_pref("gecko.handlerService.schemes.mailto.0.name", "");
user_pref("gecko.handlerService.schemes.mailto.1.uriTemplate", "");
user_pref("gecko.handlerService.schemes.mailto.1.name", "");
user_pref("gecko.handlerService.schemes.irc.0.uriTemplate", "");
user_pref("gecko.handlerService.schemes.irc.0.name", "");
user_pref("gecko.handlerService.schemes.ircs.0.uriTemplate", "");
user_pref("gecko.handlerService.schemes.ircs.0.name", "");
user_pref("browser.translation.engine", "");
user_pref("services.settings.server", "");

/*** [SECTION 0400]: SAFE BROWSING (SB) ***/
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");
user_pref(
	"browser.safebrowsing.downloads.remote.block_potentially_unwanted",
	false,
);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref("browser.safebrowsing.allowOverride", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous_host", false);
user_pref("browser.safebrowsing.passwords.enabled", false);
user_pref("browser.safebrowsing.provider.google.updateURL", "");
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.updateURL", "");
user_pref("browser.safebrowsing.provider.google4.gethashURL", "");
user_pref("browser.safebrowsing.provider.google.reportURL", "");
user_pref("browser.safebrowsing.reportPhishURL", "");

user_pref("browser.safebrowsing.provider.google4.reportURL", "");
user_pref("browser.safebrowsing.provider.google.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.provider.google.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.dataSharing.enabled", false);
user_pref("browser.safebrowsing.provider.google4.dataSharingURL", "");
user_pref("browser.safebrowsing.provider.google.advisory", "");
user_pref("browser.safebrowsing.provider.google.advisoryURL", "");
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.advisoryURL", "");
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.provider.mozilla.gethashURL", "");
user_pref("browser.safebrowsing.provider.mozilla.updateURL", "");

/*** [SECTION 0600]: BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on] ***/
user_pref("__user-overrides.js.cat", "0600 Error: The cat is dead!");

/*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS ***/
user_pref("__user-overrides.js.cat", "0700 Error: The cat is dead!");
user_pref("network.trr.mode", 5);
user_pref("network.trr.uri", "");
user_pref("network.trr.custom_uri", "");

user_pref("network.trr.confirmationNS", "");

/*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
user_pref("__user-overrides.js.cat", "0800 Error: The cat is dead!");
user_pref("browser.urlbar.clipboard.featureGate", false);
user_pref("browser.urlbar.suggest.engines", false);

user_pref("browser.urlbar.merino.enabled", false);

/*** [SECTION 0900]: PASSWORDS ***/
user_pref("__user-overrides.js.cat", "0900 Error: The cat is dead!");

user_pref("signon.generation.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("signon.management.page.breachAlertUrl", "");
// 0=once per session, 1=every time it's needed, 2=after n minutes
user_pref("security.ask_for_password", 1);
user_pref("security.password_lifetime", 5);

/*** [SECTION 1000]: DISK AVOIDANCE ***/
user_pref("__user-overrides.js.cat", "1000 Error: The cat is dead!");

/*** [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP) ***/
user_pref("__user-overrides.js.cat", "1200 Error: The cat is dead!");
user_pref("security.OCSP.require", false);

user_pref("security.remote_settings.intermediates.enabled", false);
user_pref("security.remote_settings.intermediates.bucket", "");
user_pref("security.remote_settings.intermediates.collection", "");
user_pref("security.remote_settings.intermediates.signer", "");
user_pref("security.remote_settings.crlite_filters.bucket", "");
user_pref("security.remote_settings.crlite_filters.collection", "");
user_pref("security.remote_settings.crlite_filters.signer", "");
user_pref("security.certerrors.mitm.priming.enabled", false);
user_pref("security.certerrors.mitm.priming.endpoint", "");
user_pref("security.pki.mitm_canary_issuer", "");
user_pref("security.pki.mitm_canary_issuer.enabled", false);
user_pref("security.pki.mitm_detected", false);

/*** [SECTION 1600]: REFERERS ***/
user_pref("__user-overrides.js.cat", "1600 Error: The cat is dead!");

/*** [SECTION 1700]: CONTAINERS ***/
user_pref("__user-overrides.js.cat", "1700 Error: The cat is dead!");

/*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/
user_pref("__user-overrides.js.cat", "2000 Error: The cat is dead!");

/*** [SECTION 2400]: DOM (DOCUMENT OBJECT MODEL) ***/
user_pref("__user-overrides.js.cat", "2400 Error: The cat is dead!");

/*** [SECTION 2600]: MISCELLANEOUS ***/
user_pref("__user-overrides.js.cat", "2600 Error: The cat is dead!");

user_pref("beacon.enabled", false);
user_pref("browser.uitour.url", "");
user_pref("dom.payments.defaults.saveAddress", false);
user_pref("dom.payments.defaults.saveCreditCard", false);
user_pref("extensions.webservice.discoverURL", "");

/*** [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION) ***/
user_pref("__user-overrides.js.cat", "2700 Error: The cat is dead!");

/*** [SECTION 2800]: SHUTDOWN & SANITIZING ***/
user_pref("__user-overrides.js.cat", "2800 Error: The cat is dead!");
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false);
user_pref("privacy.clearHistory.historyFormDataAndDownloads", false);

/*** [SECTION 4000]: FPP (fingerprintingProtection) ***/
user_pref("__user-overrides.js.cat", "4000 Error: The cat is dead!");

/*** [SECTION 4500]: RFP (resistFingerprinting) ***/
user_pref("__user-overrides.js.cat", "4500 Error: The cat is dead!");
user_pref("privacy.resistFingerprinting", false);
user_pref("privacy.resistFingerprinting.letterboxing", false);
// 0=prompt, 1=disabled, 2=enabled (requires RFP)
user_pref("privacy.spoof_english", 2);
user_pref("browser.display.use_system_colors", true);
user_pref("widget.non-native-theme.enabled", false);
user_pref("webgl.disabled", false);

/*** [SECTION 5000]: OPTIONAL OPSEC ***/
user_pref("__user-overrides.js.cat", "5000 Error: The cat is dead!");
user_pref("signon.rememberSignons", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.autoFill", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("keyword.enabled", false);

user_pref("browser.urlbar.suggest.weather", false);
user_pref("security.sandbox.gpu.level", 1);
user_pref("fission.autostart", true);
user_pref("gfx.webrender.all", true);
user_pref("signon.firefoxRelay.feature", "disabled");
user_pref("dom.private-attribution.submission.enabled", false);

/*** [SECTION 5500]: OPTIONAL HARDENING ***/
user_pref("__user-overrides.js.cat", "5500 Error: The cat is dead!");

/*** [SECTION 6000]: DON'T TOUCH ***/
user_pref("__user-overrides.js.cat", "6000 Error: The cat is dead!");

/*** [SECTION 7000]: DON'T BOTHER ***/
user_pref("__user-overrides.js.cat", "7000 Error: The cat is dead!");

/*** [SECTION 8000]: DON'T BOTHER: FINGERPRINTING ***/
user_pref("__user-overrides.js.cat", "8000 Error: The cat is dead!");

/*** [SECTION 9000]: NON-PROJECT RELATED ***/
user_pref("__user-overrides.js.cat", "9000 Error: The cat is dead!");

user_pref("startup.homepage_welcome_url", "");
user_pref("app.update.auto", false);
user_pref("extensions.update.enabled", false);
user_pref("extensions.update.autoUpdateDefault", false);
user_pref("extensions.getAddons.cache.enabled", false);
// user_pref("browser.search.update", false);
user_pref("accessibility.typeaheadfind", false);
user_pref("clipboard.autocopy", false);
// 0=none, 1-multi-line, 2=multi-line & single-line
user_pref("layout.spellcheckDefault", 0);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref(
	"browser.newtabpage.activity-stream.section.highlights.includePocket",
	false,
);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref(
	"browser.newtabpage.activity-stream.section.highlights.includeBookmarks",
	false,
);
user_pref(
	"browser.newtabpage.activity-stream.section.highlights.includeDownloads",
	false,
);
user_pref(
	"browser.newtabpage.activity-stream.section.highlights.includeVisited",
	false,
);
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.screenshots.disabled", true);
user_pref("reader.parse-on-load.enabled", false);
user_pref("browser.tabs.firefox-view", false);
user_pref("network.manage-offline-status", false);
user_pref("browser.preferences.moreFromMozilla", false);

/*** [SECTION 9999]: DEPRECATED / RENAMED ***/
user_pref("__user-overrides.js.cat", "9999 Error: The cat is dead!");

user_pref("__user-overrides.js.cat", "SUCCESS: The cat is alive!");
