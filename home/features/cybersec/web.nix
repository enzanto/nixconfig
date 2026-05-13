{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cybersec.web;
in {
  options.features.cybersec.web.enable = mkEnableOption "web application testing tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sqlmap # SQL injection scanner
      nikto # Web server scanner
      ffuf # Fast web fuzzer
      gobuster # Directory/DNS brute-forcer
      dirb # Web content scanner
      feroxbuster # Recursive content discovery
      httpie # HTTP client
      whatweb # Web technology identifier
      burpsuite
    ];
  };
}
