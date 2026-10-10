{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cybersec.scanning;
in {
  options.features.cybersec.scanning.enable = mkEnableOption "scanning and reconnaissance tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      steam-run # dirty hack to run nessus
      amass # Subdomain enumeration
      angryipscanner
      dnsenum # DNS enumeration
      dnsrecon # DNS reconnaissance
      enum4linux
      fierce # DNS reconnaissance
      masscan # Fast port scanner
      nmap # Network mapper
      subfinder # Subdomain discovery
      theharvester # OSINT gathering
      whois # Domain lookups
      zenmap
    ];

    # theHarvester API-key symlink from SOPS is disabled for now — it requires the
    # sops-nix home-manager module (config.sops.defaultSymlinkPath), which nixos-vm
    # does not enable. Re-enable when a host that uses sops + scanning exists.
    # home.activation.createTheHarvesterConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #   mkdir -p $HOME/.config/theHarvester
    #   ln -sf ${config.sops.defaultSymlinkPath}/harvester-api-keys $HOME/.config/theHarvester/api-keys.yaml
    # '';
  };
}
