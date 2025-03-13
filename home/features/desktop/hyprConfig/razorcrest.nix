{
  monitor = [
    "eDP-1, 1920x1080,0x0,1"
  ];

  hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload =
          [ "/home/fredrik/Pictures/wallpapers/anime_girl_alone_5k-1366x768.jpg" ];

      wallpaper = [
          "eDP-1,/home/fredrik/Pictures/wallpapers/anime_girl_alone_5k-1366x768.jpg"];
    };
  };
}
