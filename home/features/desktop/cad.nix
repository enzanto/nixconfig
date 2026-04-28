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
      # freecad
      (pkgs.writeShellScriptBin "freecad" ''
        export QT_QPA_PLATFORM=xcb
        exec ${pkgs.freecad}/bin/freecad "$@"
      '')
    ];
    xdg.desktopEntries.freecad = {
      name = "FreeCAD";
      genericName = "3D CAD Modeler";
      comment = "Parametric 3D CAD modeler";
      exec = "freecad %F";
      icon = "${pkgs.freecad}/share/icons/hicolor/256x256/apps/freecad.png";
      terminal = false;
      categories = ["Engineering"];
    };
  };
}
