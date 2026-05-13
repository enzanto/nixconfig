{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cybersec.cracking;
in
{
  options.features.cybersec.cracking.enable = mkEnableOption "password cracking tools";

   config = mkIf cfg.enable {
     home.packages = with pkgs; [
       john           # John the Ripper password cracker
       hashcat        # GPU password cracker
       hydra          # Network login brute-forcer
       wordlists      # SecLists wordlists collection
       seclists       # Security assessment wordlists (passwords, usernames, web shells)
       rockyou        # Famous rockyou.txt wordlist for brute force attacks
       crunch         # Wordlist generator
       cewl           # Custom wordlist generator from websites
     ];
   };
}
