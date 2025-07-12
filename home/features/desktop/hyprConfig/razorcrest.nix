{
  monitor = [
    "eDP-1, 1920x1080,0x0,1"
  ];

  workspace = [
    "1, monitor:eDP-1"
    "2, monitor:eDP-1"
    "3, monitor:eDP-1"
    "4, monitor:eDP-1"
    "5, monitor:eDP-1"
    "6, monitor:eDP-1"
    "7, monitor:eDP-1"
    "8, monitor:eDP-1"
  ];

  hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = ["/home/fredrik/Pictures/wallpapers/anime_girl_alone_5k-1366x768.jpg"];

      wallpaper = [
        "eDP-1,/home/fredrik/Pictures/wallpapers/anime_girl_alone_5k-1366x768.jpg"
      ];
    };
  };
}
