# TODO: replace the output/workspace layout when the ultrawide arrives.
# This is the current 3-monitor layout from hyprConfig/coruscant.nix, shifted by
# (+1080, +138) because sway handles negative output positions badly.
# NVIDIA env vars and --unsupported-gpu live in hosts/coruscant/configuration.nix.
{lib, ...}: let
  assign = output:
    map (n: {
      workspace = toString n;
      inherit output;
    });
in {
  output = {
    "HDMI-A-1" = {
      mode = "1920x1080";
      pos = "0 0";
      transform = "270"; # Hyprland transform 1 = sway 270
    };
    "DP-2" = {
      mode = "2560x1440@143.912Hz";
      pos = "1080 138";
    };
    "HDMI-A-2" = {
      mode = "1920x1080";
      pos = "3640 388";
    };
  };

  workspaceOutputAssign =
    assign "DP-2" (lib.range 1 8)
    ++ assign "HDMI-A-2" (lib.range 9 16)
    ++ assign "HDMI-A-1" (lib.range 17 20);

  # Primary output for XWayland (Steam etc.)
  startup = [{command = "xrandr --output DP-2 --primary";}];

  # Rotates the folder every 5 minutes on all outputs (was hyprpaper timeout = 300)
  wpaperd = {
    default = {
      path = "/home/fredrik/Pictures/wallpapers/rotation";
      duration = "5m";
    };
  };

  extraConfig = ''
    for_window [app_id="^\.virt-manager-wrapped$"] opacity 1
    for_window [app_id="^swappy$"] opacity 1
    for_window [class="^VirtualBox"] opacity 1
    for_window [app_id="^org\.wireshark\.Wireshark$"] opacity 1
    for_window [class="^steam_app_default$"] opacity 1
  '';
}
