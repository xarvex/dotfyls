{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg' = config.dotfyls.browsers;
  cfg = cfg'.chromium;
in
{
  options.dotfyls.browsers.chromium = {
    enable = lib.mkEnableOption "Chromium";

    vulkan = lib.mkEnableOption "Vulkan";
    ignoreGPUChecks = lib.mkEnableOption "ignoring GPU checks and blocks";
  };

  config = lib.mkIf (cfg'.enable && cfg.enable) {
    dotfyls.file = {
      ".config/chromium" = {
        mode = "0700";
        cache = true;
      };
      ".cache/chromium" = {
        mode = "0700";
        cache = true;
      };
    };

    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;

      commandLineArgs = [
        "--use-gl=angle"
        "--use-angle=${if cfg.vulkan then "vulkan" else "gl"}"

        "--enable-features=${
          builtins.concatStringsSep "," (
            [
              "UseOzonePlatform"
              "WaylandWindowDecorations"

              "AcceleratedVideoDecodeLinuxGL"
              "AcceleratedVideoDecodeLinuxZeroCopyGL"
              "AcceleratedVideoEncoder"

              "CanvasOopRasterization"
            ]
            ++ lib.optionals cfg.vulkan (
              [
                "VaapiVideoDecoder"
                "VaapiOnNvidiaGPUs"
                "Vulkan"
                "DefaultANGLEVulkan"
                "VulkanFromANGLE"
              ]
              ++ lib.optional cfg.ignoreGPUChecks "VaapiIgnoreDriverChecks"
            )
          )
        }"

        "--enable-gpu-rasterization"
        "--enable-zero-copy"

        "--canvas-oop-rasterization"
      ]
      ++ lib.optionals cfg.ignoreGPUChecks [
        "--ignore-gpu-blocklist"
        "--disable-gpu-driver-bug-workaround"
      ];
    };

    xdg.mimeApps.associations.removed = lib.genAttrs [
      "application/pdf"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/webp"
    ] (_: "chromium-browser.desktop");
  };
}
