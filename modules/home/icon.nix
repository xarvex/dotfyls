{ config, lib, ... }:

let
  cfg = config.dotfyls.icon;

  withProperty = property: names: icon: {
    "by${property}" =
      if builtins.isList names then lib.genAttrs names (_: icon) else { ${names} = icon; };
  };
  withFile = withProperty "Filename";
  withDir = withProperty "Dirname";
  withExt = withProperty "Extension";

  general = {
    clock = " ";
    home = " ";
    layer = "󰽘 ";

    branch = " ";
    commit = " ";
    stash = "≡";
    vim = " ";

    spellcheck = " ";
    hint = "󱠂 ";
    info = " ";
    warning = " ";
    error = " ";
  };
  file = {
    audio = "󰧔 ";
    book = " ";
    image = "󰐞 ";
    video = "󰨛 ";

    code = " ";
    config = " ";
    environment = "󱃻 ";
    instructions = "󰺾 ";
    legal = " ";
    lock = "󰌾 ";
    script = "󱆃 ";
    shell = " ";

    git = "󰊢 ";
  };
  dir = {
    cache = "󰪺 ";
    config = "󱁿 ";
    local = "󱧼 ";
    network = "󰡰 ";
    network-secure = "󰢭 ";
    secure = "󰢬 ";

    home = "󱂵 ";

    desktop = " ";
    documents = "󰲂 ";
    downloads = "󰉍 ";
    music = "󱍙 ";
    pictures = "󰉏 ";
    public = "󰉙 ";
    templates = "󱋣 ";
    videos = "󰉔 ";

    git = " ";
    github = " ";
  };
  application = {
    firefox = "󰈹 ";
    kde = " ";
    man-db = "󱚊 ";
    mpv = " ";
    qt = " ";
    steam = " ";
    xorg = " ";
  };

  data = {
    json = "󰘦 ";
    toml = " ";
    yaml = " ";
    xml = "󰗀 ";
  };
  markup = {
    markdown = " ";
    tex = " ";
    typst = " ";
  };
  code = rec {
    ada = " ";
    agda = "󱗆 ";
    ap = file.code;
    apl = " ";
    assembly = " ";
    b = "󰫯 ";
    bash = " ";
    c = " ";
    carbon = " ";
    chapel = file.code;
    clean = file.code;
    clojure = " ";
    clojuredart = " ";
    clojurescript = " ";
    cobol = "󰒓 ";
    coffeescript = " ";
    commonlisp = " ";
    cpp = " ";
    crystal = " ";
    csharp = " ";
    css = " ";
    d = " ";
    dafny = file.code;
    dart = " ";
    dylan = commonlisp;
    eiffel = "󱕫 ";
    elixir = " ";
    elm = " ";
    erlang = " ";
    eulisp = " ";
    fennel = " ";
    fish = " ";
    fortran = " ";
    fsharp = " ";
    fstar = file.code;
    gleam = "󰦥 ";
    go = " ";
    groovy = " ";
    hack = " ";
    haskell = " ";
    haxe = " ";
    html = " ";
    hy = commonlisp;
    idris = file.code;
    isabelle = file.code;
    j = "󰫷 ";
    java = " ";
    javascript = " ";
    julia = " ";
    kotlin = " ";
    lasso = "🦏";
    lean = file.code;
    livescript = " ";
    lua = " ";
    matlab = " ";
    ml = file.code;
    mojo = "🔥";
    nemerle = file.code;
    nial = "󰻈 ";
    nim = " ";
    nix = " ";
    objectivec = " ";
    objectivecpp = " ";
    ocaml = " ";
    odin = " ";
    opa = file.code;
    parasail = "󰲴 ";
    pascal = "󰬗 ";
    perl = " ";
    php = " ";
    prolog = " ";
    purescript = " ";
    python = " ";
    r = " ";
    racket = scheme;
    raku = " ";
    red = "󱥒 ";
    ring = "󰟫 ";
    ruby = " ";
    rust = " ";
    scala = " ";
    scheme = " ";
    sisal = file.code;
    smalltalk = "󰨦 ";
    snobol = file.code;
    solidity = " ";
    standardml = file.code;
    swift = " ";
    typescript = "󰛦 ";
    ur = file.code;
    v = " ";
    vala = " ";
    zig = " ";
    zsh = "󰬇 ";
  };
  framework = {
    astro = " ";
    razor = " ";
    react = " ";
    rubyonrails = " ";
    svelte = " ";
    vue = " ";
  };
  tool = {
    cargo = "󰏗 ";
    composer = " ";
    gradle = " ";
    poetry = " ";
    slim = " ";
  };
in
{
  options.dotfyls = {
    icon' = lib.mkOption { default = { }; };
    icon = {
      general = lib.mkOption { default = { }; };
      file = lib.mkOption { default = { }; };
      dir = lib.mkOption { default = { }; };
      application = lib.mkOption { default = { }; };

      data = lib.mkOption { default = { }; };
      markup = lib.mkOption { default = { }; };
      code = lib.mkOption { default = { }; };
      framework = lib.mkOption { default = { }; };
      tool = lib.mkOption { default = { }; };

      byFilename = lib.mkOption { default = { }; };
      byDirname = lib.mkOption { default = { }; };
      byName = lib.mkOption { default = { }; };
      byExtension = lib.mkOption { default = { }; };
    };
  };

  config = {
    dotfyls.icon = lib.mkMerge [
      {
        inherit general;
        inherit file;
        inherit dir;
        inherit application;

        inherit data;
        inherit markup;
        inherit code;
        inherit tool;

        byName = lib.mkMerge [
          cfg.byDirname
          cfg.byFilename
        ];
      }

      (withFile [ "conf" "config" ] file.config)
      (withDir [
        "conf"
        "conf.d"
        "config"
        "config.d"
        "rules.d"
        "tmpfiles.d"
        "user-tmpfiles.d"
      ] dir.config)
      (withExt [ "cfg" "conf" "config" ] file.config)

      (withDir "Desktop" dir.desktop)
      (withDir "Documents" dir.documents)
      (withDir "Downloads" dir.downloads)
      (withDir "Music" dir.music)
      (withDir "Pictures" dir.pictures)
      (withDir "Public" dir.public)
      (withDir "Templates" dir.templates)
      (withDir "Videos" dir.videos)

      (withDir ".cache" dir.cache)
      (withDir ".config" dir.config)
      (withDir ".local" dir.local)

      (withFile [ ".login" ".logout" ".profile" ] file.shell)
      (withDir ".mozilla" application.firefox)
      (withFile "kvantum.kvconfig" application.kde)
      (withFile ".manpath" application.man-db)
      (withFile "mpv.conf" application.mpv)
      (withFile [ "qt5ct.conf" "qt6ct.conf" ] application.qt)
      (withDir ".ssh" dir.network-secure)
      (withDir ".steam" application.steam)
      (withFile [
        ".Xauthority"
        ".Xresources"
        ".Xsession"
        ".xbindkeysrc"
        ".xinitrc"
        ".xserverrc"
        ".xsession"
        ".xsession-errors"
        ".xsessionrc"
        "Xauthority"
        "Xresources"
        "Xsession"
        "xbindkeysrc"
        "xinitrc"
        "xserverrc"
        "xsession"
        "xsession-errors"
        "xsessionrc"
      ] application.xorg)

      (withDir ".git" dir.git)
      (withDir ".github" dir.github)
      (withFile [ ".envrc" ".envrc.recommended" ] file.environment)
      (withFile ".gitignore" file.git)
      (withFile ".pre-commit-config.yaml" general.commit)
      (withFile [ "CONTRIBUTING" "CONTRIBUTING.md" "CONTRIBUTING.txt" ] file.instructions)
      (withFile [ "LICENSE" "LICENSE.md" "LICENSE.txt" ] file.legal)
      (withFile [ "README" "README.md" "README.txt" ] file.book)

      (withExt [
        "aac"
        "aif"
        "aifc"
        "aiff"
        "alac"
        "ape"
        "flac"
        "m4a"
        "mka"
        "mp2"
        "mp3"
        "ogg"
        "opus"
        "pcm"
        "swf"
        "wav"
        "wma"
        "wv"
      ] file.audio)
      (withExt [
        "arw"
        "avif"
        "bmp"
        "cbr"
        "cbz"
        "cr2"
        "dvi"
        "gif"
        "heic"
        "heif"
        "ico"
        "j2c"
        "j2k"
        "jfi"
        "jfif"
        "jif"
        "jp2"
        "jpe"
        "jpeg"
        "jpf"
        "jpg"
        "jpx"
        "jxl"
        "nef"
        "orf"
        "pbm"
        "pgm"
        "png"
        "pnm"
        "ppm"
        "pxm"
        "raw"
        "tif"
        "tiff"
        "webp"
        "xpm"
      ] file.image)
      (withExt [
        "3g2"
        "3gp"
        "3gp2"
        "3gpp"
        "3gpp2"
        "avi"
        "cast"
        "flv"
        "h264"
        "heics"
        "m2ts"
        "m2v"
        "m4v"
        "mkv"
        "mov"
        "mp4"
        "mpeg"
        "mpg"
        "ogm"
        "ogv"
        "video"
        "vob"
        "webm"
        "wmv"
      ] file.video)

      (withExt "ini" file.config)
      (withExt [ "json" "json5" "jsonc" ] data.json)
      (withExt "toml" data.toml)
      (withExt [ "yaml" "yml" ] data.yaml)
      (withExt [ "xml" "xul" ] data.xml)

      (withExt [ "jmd" "markdown" "md" "mkd" "rdoc" "rmd" ] markup.markdown)
      (withExt [
        "bib"
        "bst"
        "cls"
        "latex"
        "ltx"
        "sty"
        "tex"
      ] markup.tex)
      (withExt "typ" markup.typst)

      (withExt "sh" file.script)
      (withExt [ "ada" "adb" "ads" ] code.ada)
      (withExt [ "agda" "lagda" ] code.agda)
      (withExt [ ".." ".+" ] code.ap)
      (withExt "apl" code.apl)
      (withExt "asm" code.assembly)
      (withExt "b" code.b)
      (withFile [ ".bashrc" ".bash_history" ".bash_logout" ".bash_profile" "bashrc" ] code.bash)
      (withExt "bash" code.bash)
      (withExt [ "c" "h" ] code.c)
      (withExt "carbon" code.carbon)
      (withExt "chpl" code.chapel)
      (withExt [ "abc" "dcl" "icl" ] code.clean)
      (withExt [ "clj" "cljr" "edn" ] code.clojure)
      (withExt "cljd" code.clojuredart)
      (withExt [ "cljc" "cljs" ] code.clojurescript)
      (withExt [ "cbl" "ccp" "cob" "cpy" ] code.cobol)
      (withExt [ "coffee" "litcoffee" "litcoffee.md" "litcoffee.tex" ] code.coffeescript)
      (withExt [
        "cl"
        "fasl"
        "l"
        "lisp"
        "lsp"
      ] code.commonlisp)
      (withExt [
        "c++"
        "cc"
        "cpp"
        "cxx"
        "h++"
        "hh"
        "hpp"
        "hxx"
      ] code.cpp)
      (withExt "cr" code.crystal)
      (withExt [ "cs" "csproj" "csx" ] code.csharp)
      (withExt "css" code.css)
      (withExt "d" code.d)
      (withExt "dfy" code.dafny)
      (withExt "dart" code.dart)
      (withExt [ "dylan" "lid" ] code.dylan)
      (withExt "e" code.eiffel)
      (withExt [ "ex" "exs" ] code.elixir)
      (withExt "elm" code.elm)
      (withExt [ "hrl" "erl" ] code.erlang)
      (withExt "em" code.eulisp)
      (withFile ".fennelrc" code.fennel)
      (withExt "fnl" code.fennel)
      (withFile "fish_variables" code.fish)
      (withExt "fish" code.fish)
      (withExt [ "f" "f77" "f90" "f95" "for" ] code.fortran)
      (withExt [ "fs" "fsi" "fsproj" "fsscript" "fsx" ] code.fsharp)
      (withExt "fst" code.fstar)
      (withExt "gleam" code.gleam)
      (withFile [ "go.mod" "go.sum" "go.work" ] code.go)
      (withExt "go" code.go)
      (withExt [ "groovy" "gsh" "gvy" "gy" ] code.groovy)
      (withExt "hack" code.hack)
      (withExt [ "hs" "lhs" ] code.haskell)
      (withExt [ "hx" "hxml" ] code.haxe)
      (withExt [ "htm" "html" "shtml" "xhtml" ] code.html)
      (withExt "hy" code.hy)
      (withExt [ "idr" "lidr" ] code.idris)
      (withExt "thy" code.isabelle)
      (withExt [ "ijp" "ijs" "ijt" "ijx" "jproj" ] code.j)
      (withExt [ "class" "jad" "jar" "java" "war" ] code.java)
      (withFile "jsconfig.json" code.javascript)
      (withExt [ "cjs" "js" "mjs" ] code.javascript)
      (withExt "jl" code.julia)
      (withExt [ "kt" "kts" ] code.kotlin)
      (withExt [ "LassoApp" "lasso" ] code.lasso)
      (withExt "lean" code.lean)
      (withExt "ls" code.livescript)
      (withExt [ "lua" "luac" "luau" ] code.lua)
      (withExt [
        "fig"
        "mat"
        "maxmaci64"
        "mexa64"
        "mexamaca64"
        "mexw64"
        "mlapp"
        "mlappinstall"
        "mlpkginstall"
        "mltbx"
        "mlx"
        "p"
      ] code.matlab)
      (withExt [ "ml" "mli" ] code.ml)
      (withExt [ "mojo" "🔥" ] code.mojo)
      (withExt "n" code.nemerle)
      (withExt [ "ndf" "nlg" ] code.nial)
      (withExt [ "nim" "nimble" "nims" ] code.nim)
      (withFile "flake.lock" code.nix)
      (withExt "nix" code.nix)
      (withExt "m" code.objectivec)
      (withExt "mm" code.objectivecpp)
      (withExt [
        "cma"
        "cmi"
        "cmo"
        "cmt"
        "cmti"
        "cmx"
        "cmxa"
        "cmxs"
        "ml"
        "mli"
        "mll"
        "mly"
      ] code.ocaml)
      (withExt "odin" code.odin)
      (withExt "opa" code.opa)
      (withExt [ "psi" "psl" ] code.parasail)
      (withExt "pas" code.pascal)
      (withExt [ "pl" "plx" "pm" "pod" "t" ] code.perl)
      (withFile "php.ini" code.php)
      (withExt [ "phar" "php" ] code.php)
      (withExt [ "pro" "P" ] code.prolog)
      (withExt "purs" code.purescript)
      (withFile [
        ".python_history"
        "MANIFEST"
        "MANIFEST.in"
        "constraints.txt"
        "pyproject.toml"
        "pyvenv.cfg"
        "requirements-dev.txt"
        "requirements.txt"
      ] code.python)
      (withExt [ "py" "pyc" "pyd" "pyi" "pyo" "pyw" ] code.python)
      (withExt [ "R" "r" "rdata" "rds" ] code.r)
      (withExt [ "raku" "rakudoc" "rakumod" "rakutest" ] code.raku)
      (withExt "rkt" code.racket)
      (withExt [ "red" "reds" ] code.red)
      (withExt [ "rh" "rform" "ring" ] code.ring)
      (withFile [ ".rvm" ".rvmrc" "Rakefile" "rvmrc" ] code.ruby)
      (withExt [
        "gem"
        "gemfile"
        "gemspec"
        "guardfile"
        "rb"
        "rspec"
        "rspec_parallel"
        "rspec_status"
        "ru"
      ] code.ruby)
      (withFile [ ".rustfmt.toml" "rustfmt.toml" ] code.rust)
      (withExt [ "rlib" "rmeta" "rs" ] code.rust)
      (withExt "scala" code.scala)
      (withExt [ "scm" "ss" ] code.scheme)
      (withExt "sis" code.sisal)
      (withExt "st" code.smalltalk)
      (withExt "sno" code.snobol)
      (withExt "sol" code.solidity)
      (withExt "sml" code.standardml)
      (withExt "swift" code.swift)
      (withFile "tsconfig.json" code.typescript)
      (withExt [ "cts" "ts" "mts" ] code.typescript)
      (withExt [ "ur" "urp" "urs" ] code.ur)
      (withExt [ "v" "vsh" ] code.v)
      (withExt "vala" code.vala)
      (withExt [ "zig" "zon" ] code.zig)
      (withFile [
        ".zlogin"
        ".zlogout"
        ".zprofile"
        ".zsh_history"
        ".zsh_sessions"
        ".zshenv"
        ".zshrc"
      ] code.zsh)
      (withExt "zsh" code.zsh)

      (withExt "astro" framework.astro)
      (withExt [ "cshtml" "razor" ] framework.razor)
      (withExt [ "jsx" "tsx" ] framework.react)
      (withFile "rubydoc" framework.rubyonrails)
      (withExt "erb" framework.rubyonrails)
      (withExt "svelte" framework.svelte)
      (withExt "vue" framework.vue)

      (withFile [ "Cargo.lock" "Cargo.toml" ] tool.cargo)
      (withFile ".codespellrc" general.spellcheck)
      (withFile [ "composer.json" "composer.lock" ] tool.composer)
      (withFile [
        "build.gradle.kts"
        "gradle"
        "gradle.properties"
        "gradlew"
        "gradlew.bat"
        "settings.gradle.kts"
      ] tool.gradle)
      (withExt "gradle" tool.gradle)
      (withFile "poetry.lock" tool.poetry)
      (withFile "QtProject.conf" application.qt)
      (withExt [ "qml" "qrc" "qss" ] application.qt)
      (withExt "slim" tool.slim)
      (withFile "vale.ini" general.spellcheck)
    ];
  };
}
