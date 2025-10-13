{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.features.desktop.latex;
  stablePkgs = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
in {
  options.features.desktop.latex.enable = mkEnableOption "enable latex";

  config = mkIf cfg.enable {
    home.packages = with stablePkgs; [
      texliveFull
      texstudio
    ];
  };
}
