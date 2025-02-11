{
  monitor = [
    "HDMI-A-1,1920x1080,-1080x-138,1,transform,1"
    "DP-2,2560x1440@143.91,0x0,1"
    "HDMI-A-2, 1920x1080,2560x250,1"
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
  '';
}
