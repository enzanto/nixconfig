{
  monitor = [
    "DP-2,2560x1440@143.91,0x0,1"
    "HDMI-A-1,1920x1080,-1080x-138,1,transform,1"
    "HDMI-A-2, 1920x1080,2560x250,1"
  ];
  workspace = [
    "1, monitor:DP-2"
    "2, monitor:DP-2"
    "3, monitor:DP-2"
    "4, monitor:DP-2"
    "5, monitor:DP-2"
    "6, monitor:DP-2"
    "7, monitor:DP-2"
    "8, monitor:DP-2"
    "9, monitor:HDMI-A-2"
    "10, monitor:HDMI-A-2"
    "11, monitor:HDMI-A-2"
    "12, monitor:HDMI-A-2"
    "13, monitor:HDMI-A-2"
    "14, monitor:HDMI-A-2"
    "15, monitor:HDMI-A-2"
    "16, monitor:HDMI-A-2"
    "17, monitor:HDMI-A-1"
    "18, monitor:HDMI-A-1"
    "19, monitor:HDMI-A-1"
    "20, monitor:HDMI-A-1"
  ];

  extraConfig = ''
    # Environment variables for Hyprland configuration
    env = GBM_BACKEND,nvidia-drm           # Use NVIDIA GBM backend
    env = WLR_DRM_NO_ATOMIC,1              # Disable atomic mode setting for wlroots
    env = WLR_NO_HARDWARE_CURSORS,1        # Disable hardware cursors
    env = LIBVA_DRIVER_NAME,nvidia         # Set VAAPI driver to NVIDIA
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia  # Set GLX vendor library to NVIDIA
    env = __GL_GSYNC_ALLOWED,1             # Enable GSync for NVIDIA
    env = NVD_BACKEND,direct               # Enable direct mode for NVIDIA
    cursor {
      no_hardware_cursors = true
    }
    windowrulev2 = opacity 1.0 override, class:^(.virt-manager-wrapped)$
    windowrulev2 = opacity 1.0 override, class:^(swappy)$
    windowrulev2 = opacity 1.0 override, class:^(VirtualBox Machine)$
    windowrulev2 = opacity 1.0 override, class:^(VirtualBox Manager)$
    windowrulev2 = opacity 1.0 override, class:^(VirtualBox)$
  '';
  hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = ["/home/fredrik/Pictures/wallpapers/1.jpg"];

      wallpaper = [
        "DP-2,/home/fredrik/Pictures/wallpapers/1.jpg"
        "HDMI-A-2,/home/fredrik/Pictures/wallpapers/1.jpg"
        "HDMI-A-1,/home/fredrik/Pictures/wallpapers/1.jpg"
      ];
    };
  };
}
