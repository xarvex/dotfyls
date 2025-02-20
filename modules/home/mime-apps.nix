{
  config,
  lib,
  self,
  ...
}:

let
  cfg = config.dotfyls.mime-apps;

  mkMimeAppOption =
    category:
    lib.mkOption {
      type = self.lib.listOrSingleton lib.types.str;
      default = [ ];
      description = "Application to use for ${category} mime-types.";
    };
  mkAssociations =
    cfg: associations: lib.optionalAttrs (cfg != [ ]) (lib.genAttrs associations (_: cfg));
in
{
  options.dotfyls.mime-apps = {
    enable = lib.mkEnableOption "mime-apps" // {
      default = config.dotfyls.desktops.enable;
    };

    files = {
      archive = mkMimeAppOption "archive";
      directory = mkMimeAppOption "directory";
      plaintext = mkMimeAppOption "plaintext";
    };
    media = {
      audio = mkMimeAppOption "audio";
      ebook = mkMimeAppOption "ebook";
      feed = mkMimeAppOption "feed";
      font = mkMimeAppOption "font";
      image = mkMimeAppOption "image";
      image-editable = mkMimeAppOption "editable image";
      model = mkMimeAppOption "model";
      pdf = mkMimeAppOption "PDF";
      raw = mkMimeAppOption "raw";
      vector = mkMimeAppOption "vector";
      vector-editable = mkMimeAppOption "editable vector";
      video = mkMimeAppOption "video";
    };
    office = {
      presentation = mkMimeAppOption "presentation";
      spreadsheet = mkMimeAppOption "spreadsheet";
      word = mkMimeAppOption "word";
    };
    security = {
      key = mkMimeAppOption "key";
      network-capture = mkMimeAppOption "network capture";
    };
    systems = {
      atari = mkMimeAppOption "Atari system";
      dreamcast = mkMimeAppOption "Dreamcast system";
      ds = mkMimeAppOption "DS system";
      ds3 = mkMimeAppOption "3DS system";
      gameboy = mkMimeAppOption "Game Boy system";
      gamecube = mkMimeAppOption "GameCube system";
      gamegear = mkMimeAppOption "Game Gear system";
      genesis = mkMimeAppOption "Genesis system";
      master-system = mkMimeAppOption "Master System system";
      msx = mkMimeAppOption "MSX system";
      n64 = mkMimeAppOption "N64 system";
      neo-geo = mkMimeAppOption "Neo Geo system";
      nes = mkMimeAppOption "NES system";
      pc-engine = mkMimeAppOption "PC Engine system";
      saturn = mkMimeAppOption "Saturn system";
      sega-cd = mkMimeAppOption "Sega CD system";
      sega-pico = mkMimeAppOption "Sega Pico system";
      sg-1000 = mkMimeAppOption "SG-1000 system";
      snes = mkMimeAppOption "SNES system";
      virtualboy = mkMimeAppOption "Virtual Boy system";
      wii = mkMimeAppOption "Wii system";
      wonderswan = mkMimeAppOption "WonderSwan system";
    };
    web = {
      email = mkMimeAppOption "email";
      webpage = mkMimeAppOption "webpage";
    };

    extraSchemes = lib.mkOption {
      type = lib.types.attrsOf (self.lib.listOrSingleton lib.types.str);
      default = { };
      description = "Extra scheme handler associations of applications.";
    };
    extraAssociations = lib.mkOption {
      type = lib.types.attrsOf (self.lib.listOrSingleton lib.types.str);
      default = { };
      description = "Associations of applications.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = lib.mkMerge [
        (mkAssociations cfg.files.archive [
          "application/gzip"
          "application/java-archive"
          "application/vnd.android.package-archive"
          "application/vnd.debian.binary-package"
          "application/vnd.ms-cab-compressed"
          "application/vnd.rar"
          "application/vnd.snap"
          "application/vnd.squashfs"
          "application/x-7z-compressed"
          "application/x-ace"
          "application/x-alz"
          "application/x-apple-diskimage"
          "application/x-archive"
          "application/x-arj"
          "application/x-bcpio"
          "application/x-bzip1"
          "application/x-bzip1-compressed-tar"
          "application/x-bzip2"
          "application/x-bzip2-compressed-tar"
          "application/x-bzip3"
          "application/x-bzip3-compressed-tar"
          "application/x-compress"
          "application/x-compressed-tar"
          "application/x-cpio"
          "application/x-cpio-compressed"
          "application/x-iso9660-appimage"
          "application/x-lha"
          "application/x-lhz"
          "application/x-lrzip"
          "application/x-lrzip-compressed-tar"
          "application/x-lz4"
          "application/x-lz4-compressed-tar"
          "application/x-lzip"
          "application/x-lzip-compressed-tar"
          "application/x-lzma"
          "application/x-lzma-compressed-tar"
          "application/x-lzop"
          "application/x-ms-wim"
          "application/x-msdownload"
          "application/x-rpm"
          "application/x-source-rpm"
          "application/x-stuffit"
          "application/x-stuffitx"
          "application/x-sv4cpio"
          "application/x-sv4crc"
          "application/x-tar"
          "application/x-tarz"
          "application/x-tzo"
          "application/x-xar"
          "application/x-xz"
          "application/x-xz-compressed-tar"
          "application/x-zoo"
          "application/x-zstd-compressed-tar"
          "application/zip"
          "application/zstd"
        ])
        (mkAssociations cfg.files.directory [
          "inode/directory"
          "x-content/blank-cd"
          "x-content/image-dcf"
          "x-content/ostree-repository"
          "x-content/software"
          "x-content/unix-software"
          "x-content/win32-software"
        ])
        (mkAssociations cfg.files.plaintext [
          "application/appinstaller"
          "application/atom+xml"
          "application/ecmascript"
          "application/json"
          "application/json5"
          "application/raml+yaml"
          "application/sql"
          "application/toml"
          "application/vnd.coffeescript"
          "application/vnd.dart"
          "application/x-awk"
          "application/x-bat"
          "application/x-csh"
          "application/x-desktop"
          "application/x-fishscript"
          "application/x-nuscript"
          "application/x-perl"
          "application/x-php"
          "application/x-powershell"
          "application/x-profile"
          "application/x-ruby"
          "application/x-shellscript"
          "application/x-troff-man"
          "application/x-troff-man-compressed"
          "application/yaml"
          "text/cache-manifest"
          "text/css"
          "text/csv-schema"
          "text/javascript"
          "text/julia"
          "text/markdown"
          "text/org"
          "text/plain"
          "text/rust"
          "text/tcl"
          "text/troff"
          "text/x-adasrc"
          "text/x-authors"
          "text/x-basic"
          "text/x-bibtex"
          "text/x-blueprint"
          "text/x-c++hdr"
          "text/x-c++src"
          "text/x-changelog"
          "text/x-cmake"
          "text/x-cobol"
          "text/x-common-lisp"
          "text/x-component"
          "text/x-copying"
          "text/x-crystal"
          "text/x-csharp"
          "text/x-csrc"
          "text/x-dbus-service"
          "text/x-dsrc"
          "text/x-eiffel"
          "text/x-elixir"
          "text/x-emacs-lisp"
          "text/x-erlang"
          "text/x-fortran"
          "text/x-gcode-gx"
          "text/x-genie"
          "text/x-gettext-translation"
          "text/x-gettext-translation-template"
          "text/x-gherkin"
          "text/x-go"
          "text/x-gradle"
          "text/x-groovy"
          "text/x-haskell"
          "text/x-idl"
          "text/x-install"
          "text/x-iptables"
          "text/x-java"
          "text/x-kaitai-struct"
          "text/x-kotlin"
          "text/x-literate-haskell"
          "text/x-log"
          "text/x-lua"
          "text/x-makefile"
          "text/x-matlab"
          "text/x-meson"
          "text/x-modelica"
          "text/x-nfo"
          "text/x-nim"
          "text/x-nimscript"
          "text/x-objc++src"
          "text/x-objcsrc"
          "text/x-ocaml"
          "text/x-ocl"
          "text/x-ooc"
          "text/x-opencl-src"
          "text/x-pascal"
          "text/x-patch"
          "text/x-python"
          "text/x-python3"
          "text/x-qml"
          "text/x-readme"
          "text/x-reject"
          "text/x-rpm-spec"
          "text/x-rst"
          "text/x-sass"
          "text/x-scala"
          "text/x-scheme"
          "text/x-scss"
          "text/x-ssa"
          "text/x-subviewer"
          "text/x-svhdr"
          "text/x-svsrc"
          "text/x-systemd-unit"
          "text/x-tex"
          "text/x-texinfo"
          "text/x-todo-txt"
          "text/x-troff-me"
          "text/x-troff-mm"
          "text/x-troff-ms"
          "text/x-twig"
          "text/x-typst"
          "text/x-vala"
          "text/x-vb"
          "text/x-verilog"
          "text/x-vhdl"
        ])
        (mkAssociations cfg.media.audio [
          "audio/AMR"
          "audio/AMR-WB"
          "audio/aac"
          "audio/ac3"
          "audio/annodex"
          "audio/basic"
          "audio/flac"
          "audio/midi"
          "audio/mobile-xmf"
          "audio/mp2"
          "audio/mp4"
          "audio/mpeg"
          "audio/ogg"
          "audio/prs.sid"
          "audio/usac"
          "audio/vnd.dts"
          "audio/vnd.dts.hd"
          "audio/vnd.rn-realaudio"
          "audio/vnd.wave"
          "audio/webm"
          "audio/x-adpcm"
          "audio/x-aifc"
          "audio/x-aiff"
          "audio/x-amzxml"
          "audio/x-ape"
          "audio/x-dff"
          "audio/x-dsf"
          "audio/x-flac+ogg"
          "audio/x-gsm"
          "audio/x-iriver-pla"
          "audio/x-it"
          "audio/x-m4b"
          "audio/x-m4r"
          "audio/x-matroska"
          "audio/x-minipsf"
          "audio/x-mo3"
          "audio/x-mod"
          "audio/x-mpegurl"
          "audio/x-ms-asx"
          "audio/x-ms-wma"
          "audio/x-musepack"
          "audio/x-opus+ogg"
          "audio/x-psf"
          "audio/x-psflib"
          "audio/x-riff"
          "audio/x-s3m"
          "audio/x-scpls"
          "audio/x-speex"
          "audio/x-speex+ogg"
          "audio/x-stm"
          "audio/x-tak"
          "audio/x-tta"
          "audio/x-voc"
          "audio/x-vorbis+ogg"
          "audio/x-wavpack"
          "audio/x-wavpack-correction"
          "audio/x-xi"
          "audio/x-xm"
          "audio/x-xmf"
          "x-content/audio-cdda"
          "x-content/audio-dvd"
          "x-content/audio-player"
        ])
        (mkAssociations cfg.media.ebook [
          "application/epub+zip"
          "application/vnd.amazon.mobi8-ebook"
          "application/vnd.comicbook+zip"
          "application/vnd.comicbook-rar"
          "application/x-cb7"
          "application/x-cbt"
          "application/x-fictionbook+xml"
          "application/x-mobipocket-ebook"
          "application/x-zip-compressed-fb2"
          "x-content/ebook-reader"
          "x-scheme-handler/opds"
        ])
        (mkAssociations cfg.media.feed [
          "application/rdf+xml"
          "application/rss+xml"
        ])
        (mkAssociations cfg.media.font [
          "application/font-tdpfr"
          "application/x-font-afm"
          "application/x-font-bdf"
          "application/x-font-dos"
          "application/x-font-framemaker"
          "application/x-font-libgrx"
          "application/x-font-linux-psf"
          "application/x-font-pcf"
          "application/x-font-speedo"
          "application/x-font-sunos-news"
          "application/x-font-tex"
          "application/x-font-tex-tfm"
          "application/x-font-ttx"
          "application/x-font-type1"
          "application/x-font-vfont"
          "application/x-gz-font-linux-psf"
          "font/collection"
          "font/otf"
          "font/ttf"
          "font/woff"
          "font/woff2"
        ])
        (mkAssociations cfg.media.image [
          "image/apng"
          "image/astc"
          "image/avif"
          "image/bmp"
          "image/dpx"
          "image/emf"
          "image/g3fax"
          "image/gif"
          "image/heif"
          "image/ief"
          "image/jp2"
          "image/jpeg"
          "image/jpm"
          "image/jpx"
          "image/jxl"
          "image/jxr"
          "image/ktx"
          "image/ktx2"
          "image/png"
          "image/qoi"
          "image/rle"
          "image/tiff"
          "image/vnd.microsoft.icon"
          "image/vnd.wap.wbmp"
          "image/vnd.zbrush.pcx"
          "image/webp"
          "image/x-adobe-dng"
          "image/x-dds"
          "image/x-dib"
          "image/x-exr"
          "image/x-icns"
          "image/x-ilbm"
          "image/x-jng"
          "image/x-jp2-codestream"
          "image/x-macpaint"
          "image/x-photo-cd"
          "image/x-portable-anymap"
          "image/x-portable-bitmap"
          "image/x-portable-graymap"
          "image/x-portable-pixmap"
          "image/x-quicktime"
          "image/x-sgi"
          "image/x-sun-raster"
          "image/x-tga"
          "image/x-xbitmap"
          "image/x-xpixmap"
          "x-content/image-picturecd"
        ])
        (mkAssociations cfg.media.image-editable [
          "application/x-krita"
          "image/openraster"
          "image/vnd.adobe.photoshop"
          "image/x-compressed-xcf"
          "image/x-gimp-gbr"
          "image/x-gimp-gih"
          "image/x-gimp-pat"
          "image/x-tiff-multipage"
          "image/x-xcf"
        ])
        (mkAssociations cfg.media.model [
          "model/3mf"
          "model/gltf+json"
          "model/gltf-binary"
          "model/iges"
          "model/mtl"
          "model/obj"
          "model/stl"
          "model/vrml"
          "text/x.gcode"
        ])
        (mkAssociations cfg.media.pdf [
          "application/oxps"
          "application/pdf"
          "application/postscript"
          "application/x-gzpdf"
          "application/x-gzpostscript"
          "application/x-xzpdf"
          "image/vnd.djvu"
          "image/vnd.djvu+multipage"
          "image/vnd.ms-modi"
        ])
        (mkAssociations cfg.media.raw [
          "image/x-canon-cr2"
          "image/x-canon-cr3"
          "image/x-canon-crw"
          "image/x-dcraw"
          "image/x-fuji-raf"
          "image/x-kodak-dcr"
          "image/x-kodak-k25"
          "image/x-kodak-kdc"
          "image/x-minolta-mrw"
          "image/x-nikon-nef"
          "image/x-nikon-nrw"
          "image/x-olympus-orf"
          "image/x-panasonic-rw"
          "image/x-panasonic-rw2"
          "image/x-pentax-pef"
          "image/x-sigma-x3f"
          "image/x-sony-arw"
          "image/x-sony-sr2"
          "image/x-sony-srf"
        ])
        (mkAssociations cfg.media.vector [
          "image/cgm"
          "image/svg+xml"
          "image/svg+xml-compressed"
          "image/wmf"
          "image/x-bzeps"
          "image/x-eps"
          "image/x-gzeps"
        ])
        (mkAssociations cfg.media.vector-editable [
          "application/illustrator"
          "application/vnd.corel-draw"
          "application/vnd.ms-visio.drawing.macroEnabled.main+xml"
          "application/vnd.ms-visio.drawing.main+xml"
          "application/vnd.ms-visio.stencil.macroEnabled.main+xml"
          "application/vnd.ms-visio.stencil.main+xml"
          "application/vnd.ms-visio.template.macroEnabled.main+xml"
          "application/vnd.ms-visio.template.main+xml"
          "application/vnd.visio"
          "image/vnd.dwg"
          "image/vnd.dxf"
          "image/x-3ds"
        ])
        (mkAssociations cfg.media.video [
          "application/annodex"
          "application/mxf"
          "application/ogg"
          "application/sdp"
          "application/smil+xml"
          "application/vnd.apple.mpegurl"
          "application/vnd.ms-asf"
          "application/vnd.rn-realmedia"
          "application/x-cue"
          "application/x-matroska"
          "video/3gpp"
          "video/3gpp2"
          "video/annodex"
          "video/dv"
          "video/isivideo"
          "video/mj2"
          "video/mp2t"
          "video/mp4"
          "video/mpeg"
          "video/ogg"
          "video/quicktime"
          "video/vnd.avi"
          "video/vnd.mpegurl"
          "video/vnd.radgamettools.bink"
          "video/vnd.radgamettools.smacker"
          "video/vnd.rn-realvideo"
          "video/vnd.vivo"
          "video/vnd.youtube.yt"
          "video/wavelet"
          "video/webm"
          "video/x-anim"
          "video/x-flic"
          "video/x-flv"
          "video/x-javafx"
          "video/x-matroska"
          "video/x-matroska-3d"
          "video/x-mjpeg"
          "video/x-mng"
          "video/x-ms-wmv"
          "video/x-nsv"
          "video/x-ogm+ogg"
          "video/x-sgi-movie"
          "video/x-theora+ogg"
          "x-content/blank-bd"
          "x-content/blank-dvd"
          "x-content/blank-hddvd"
          "x-content/video-bluray"
          "x-content/video-dvd"
          "x-content/video-hddvd"
          "x-content/video-svcd"
          "x-content/video-vcd"
        ])
        (mkAssociations cfg.office.presentation [
          "application/vnd.apple.keynote"
          "application/vnd.ms-powerpoint"
          "application/vnd.ms-powerpoint.addin.macroEnabled.12"
          "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
          "application/vnd.ms-powerpoint.slide.macroEnabled.12"
          "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
          "application/vnd.ms-powerpoint.template.macroEnabled.12"
          "application/vnd.oasis.opendocument.presentation"
          "application/vnd.oasis.opendocument.presentation-flat-xml"
          "application/vnd.oasis.opendocument.presentation-template"
          "application/vnd.openxmlformats-officedocument.presentationml.presentation"
          "application/vnd.openxmlformats-officedocument.presentationml.slide"
          "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
          "application/vnd.openxmlformats-officedocument.presentationml.template"
          "application/vnd.stardivision.impress"
          "application/vnd.sun.xml.impress"
          "application/vnd.sun.xml.impress.template"
        ])
        (mkAssociations cfg.office.spreadsheet [
          "application/mathml+xml"
          "application/vnd.apple.numbers"
          "application/vnd.lotus-1-2-3"
          "application/vnd.ms-excel"
          "application/vnd.ms-excel.addin.macroEnabled.12"
          "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
          "application/vnd.ms-excel.sheet.macroEnabled.12"
          "application/vnd.ms-excel.template.macroEnabled.12"
          "application/vnd.oasis.opendocument.chart"
          "application/vnd.oasis.opendocument.chart-template"
          "application/vnd.oasis.opendocument.spreadsheet"
          "application/vnd.oasis.opendocument.spreadsheet-flat-xml"
          "application/vnd.oasis.opendocument.spreadsheet-template"
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
          "application/vnd.stardivision.calc"
          "application/vnd.stardivision.chart"
          "application/vnd.sun.xml.calc"
          "application/vnd.sun.xml.calc.template"
          "application/x-gnumeric"
          "application/x-quattropro"
          "text/csv"
          "text/spreadsheet"
          "text/tab-separated-values"
        ])
        (mkAssociations cfg.office.word [
          "application/msword"
          "application/msword-template"
          "application/prs.plucker"
          "application/rtf"
          "application/vnd.apple.pages"
          "application/vnd.lotus-wordpro"
          "application/vnd.ms-word.document.macroEnabled.12"
          "application/vnd.ms-word.template.macroEnabled.12"
          "application/vnd.ms-works"
          "application/vnd.oasis.opendocument.text"
          "application/vnd.oasis.opendocument.text-flat-xml"
          "application/vnd.oasis.opendocument.text-master"
          "application/vnd.oasis.opendocument.text-template"
          "application/vnd.oasis.opendocument.text-web"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
          "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
          "application/vnd.palm"
          "application/vnd.stardivision.writer"
          "application/vnd.sun.xml.writer"
          "application/vnd.sun.xml.writer.global"
          "application/vnd.sun.xml.writer.template"
          "application/vnd.wordperfect"
          "application/x-abiword"
          "application/x-aportisdoc"
          "application/x-docbook+xml"
          "application/x-pocket-word"
        ])
        (mkAssociations cfg.security.key [
          "application/pgp-encrypted"
          "application/pgp-keys"
          "application/pgp-signature"
          "application/pkcs10"
          "application/pkcs12"
          "application/pkcs7-mime"
          "application/pkcs7-signature"
          "application/pkcs8"
          "application/pkcs8-encrypted"
          "application/pkix-cert"
          "application/pkix-crl"
          "application/pkix-pkipath"
          "application/x-pkcs7-certificates"
        ])
        (mkAssociations cfg.security.network-capture [
          "application/vnd.tcpdump.pcap"
        ])
        (mkAssociations cfg.systems.atari [
          "application/x-atari-2600-rom"
          "application/x-atari-7800-rom"
          "application/x-atari-lynx-rom"
        ])
        (mkAssociations cfg.systems.dreamcast [
          "application/x-dreamcast-rom"
        ])
        (mkAssociations cfg.systems.ds [
          "application/x-nintendo-ds-rom"
        ])
        (mkAssociations cfg.systems.ds3 [
          "application/x-nintendo-3ds-executable"
          "application/x-nintendo-3ds-rom"
        ])
        (mkAssociations cfg.systems.gameboy [
          "application/x-gameboy-color-rom"
          "application/x-gameboy-rom"
          "application/x-gba-rom"
        ])
        (mkAssociations cfg.systems.gamecube [
          "application/x-gamecube-rom"
        ])
        (mkAssociations cfg.systems.gamegear [
          "application/x-gamegear-rom"
        ])
        (mkAssociations cfg.systems.genesis [
          "application/x-genesis-32x-rom"
          "application/x-genesis-rom"
        ])
        (mkAssociations cfg.systems.master-system [
          "application/x-sms-rom"
        ])
        (mkAssociations cfg.systems.msx [
          "application/x-msx-rom"
        ])
        (mkAssociations cfg.systems.n64 [
          "application/x-n64-rom"
        ])
        (mkAssociations cfg.systems.nes [
          "application/x-nes-rom"
        ])
        (mkAssociations cfg.systems.neo-geo [
          "application/x-neo-geo-pocket-color-rom"
          "application/x-neo-geo-pocket-rom"
        ])
        (mkAssociations cfg.systems.pc-engine [
          "application/x-pc-engine-rom"
        ])
        (mkAssociations cfg.systems.saturn [
          "application/x-gd-rom-cue"
          "application/x-saturn-rom"
        ])
        (mkAssociations cfg.systems.sega-cd [
          "application/x-sega-cd-rom"
        ])
        (mkAssociations cfg.systems.sega-pico [
          "application/x-sega-pico-rom"
        ])
        (mkAssociations cfg.systems.sg-1000 [
          "application/x-sg1000-rom"
        ])
        (mkAssociations cfg.systems.snes [
          "application/vnd.nintendo.snes.rom"
        ])
        (mkAssociations cfg.systems.virtualboy [
          "application/x-virtual-boy-rom"
        ])
        (mkAssociations cfg.systems.wii [
          "application/x-wii-rom"
          "application/x-wii-wad"
        ])
        (mkAssociations cfg.systems.wonderswan [
          "application/x-wonderswan-color-rom"
          "application/x-wonderswan-rom"
        ])
        (mkAssociations cfg.web.email [
          "x-scheme-handler/mailto"
        ])
        (mkAssociations cfg.web.webpage [
          "application/x-mozilla-bookmarks"
          "application/xhtml+xml"
          "text/html"
          "text/htmlh"
          "x-scheme-handler/about"
          "x-scheme-handler/chrome"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/unknown"
          "x-scheme-handler/webcal"
        ])
        (builtins.mapAttrs (scheme: _: "x-scheme-handler/${scheme}") cfg.extraSchemes)
        cfg.extraAssociations
      ];
    };
  };
}
