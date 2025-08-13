{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["custom/weather" "pulseaudio" "battery" "clock" "network" "bluetooth" "tray"];
        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "📓";
            "4" = "🎥";
            "5" = "📨";
            # "3" = "";
            # "4" = "";
            # "5" = "";
            # "6" = "";
            # "7" = "";
            "6" = "🎓";
            "7" = "🎮";
            "8" = "";
            "9" = "📈";
            "magic" = "";
          };

          persistent-workspaces = {
            "DP-2" = [1 2 3 4 5 6 7 8];
            "HDMI-A-2" = [9 10 11 12 13 14 15 16];
            "HDMI-A-1" = [17 18 19 20];
          };
        };

        "custom/weather" = {
          format = " {} ";
          exec = "curl -s 'wttr.in/?format=3'";
          interval = 300;
          class = "weather";
        };

        "pulseaudio" = {
          format = "{icon}   {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "";
          format-icons = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" ""];
          };
          on-click = "pavucontrol";
        };

        "bluetooth" = {
          on-click = "rofi-bluetooth";
        };

        "battery" = {
          #bat = "BAT0";
          states = {
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        "clock" = {
          format = "{:%d.%m.%Y - %H:%M}";
          format-alt = "{:%A, %B %d at %R}";
        };

        "network" = {
          format-wifi = "wifi {bandwidthDownBits}";
          format-ethernet = "enth {bandwidthDownBits}";
          format-disconnected = "no network";
          interval = 5;
          tooltip = false;
          on-click = "nm-applet";
        };

        "tray" = {
          icon-size = 14;
          spacing = 1;
        };
      };
    };
  };
}
