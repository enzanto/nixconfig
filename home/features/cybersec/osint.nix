{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cybersec.osint;
in {
  options.features.cybersec.osint.enable = mkEnableOption "osint frameworks and tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      holehe # Cli to check if mail is used on different sites
      maigret # CLI tool to check usernames
    ];
  };
}
