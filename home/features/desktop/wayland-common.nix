{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop;
in {
  # Shared by the hyprland and sway modules while both exist side by side
  config = mkIf (cfg.hyprland.enable || cfg.sway.enable) {
    home.packages = with pkgs; [
      brightnessctl
      alacritty
      satty
      swappy
      # xfce.thunar
      waypaper
      rofi-bluetooth
      rofi-systemd
    ];
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      extraConfig = {
        modi = "drun,run,window,calc";
        drun-display-format = "{icon} {name}";
        display-drun = "🕵 Application";
        show-icons = true;
      };
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
        rofi-power-menu
        rofi-top
        # rofi-bluetooth
      ];
      theme = "rounded-nord-dark";
    };
  };
}
