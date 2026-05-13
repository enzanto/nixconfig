{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cybersec.networking;
in {
  options.features.cybersec.networking.enable = mkEnableOption "network sniffing and MITM tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # wireshark # Packet analyzer
      tcpdump # CLI packet capture
      ettercap # MITM attacks
      bettercap # Network attack/monitoring
      responder # LLMNR/NBT-NS/MDNS poisoner
      mitmproxy # Interactive HTTPS proxy
      dnsmasq # DNS/DHCP server
      bridge-utils # Bridge management
    ];
  };
}
