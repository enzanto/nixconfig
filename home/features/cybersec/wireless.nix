{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cybersec.wireless;
in
{
  options.features.cybersec.wireless.enable = mkEnableOption "wireless pentesting tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hostapd        # Rogue access point
      aircrack-ng    # WiFi cracking suite
      kismet         # Wireless network detector
      wifite2        # Automated WiFi attack tool
      iw             # WiFi interface management
    ];
  };
}
