{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.desktop.wireshark;
in {
    options.features.desktop.wireshark.enable = mkEnableOption "Enables wireshark";

    config = mkIf cfg.enable {
        # programs.wireshark.enable = true;
        home.packages = with pkgs; [
            wireshark-qt
            hostapd
            dnsmasq
            bridge-utils
            nettools
            # Above tools is needed for MITM router from nmatt
        ];
        # extraGroups.wireshark.members = ["fredrik"];

    };
}