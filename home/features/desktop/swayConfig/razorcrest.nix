{lib, ...}: {
  output = {
    "eDP-1" = {
      mode = "1920x1080";
      pos = "0 0";
      bg = "/home/fredrik/Pictures/wallpapers/anime_girl_alone_5k-1366x768.jpg fill";
    };
  };

  workspaceOutputAssign =
    map (n: {
      workspace = toString n;
      output = "eDP-1";
    }) (lib.range 1 8);
}
