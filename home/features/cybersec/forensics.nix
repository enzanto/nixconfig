{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cybersec.forensics;
in
{
  options.features.cybersec.forensics.enable = mkEnableOption "forensics and reverse engineering tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ghidra         # NSA reverse engineering tool
      radare2        # RE framework
      binwalk        # Firmware analysis
      volatility3    # Memory forensics
      foremost       # File carving
      steghide       # Steganography
    ];
  };
}
