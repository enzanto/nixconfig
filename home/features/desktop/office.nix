{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.office;
in {
  options.features.desktop.office.enable = mkEnableOption "Enables office";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      thunderbird
      libreoffice
      zathura
    ];
    # extraGroups.office.members = ["fredrik"];
  };
}
