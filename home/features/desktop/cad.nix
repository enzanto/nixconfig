{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.cad;
in {
  options.features.desktop.cad.enable = mkEnableOption "enable cad";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bambu-studio
      blender
      freecad
    ];
  };
}
