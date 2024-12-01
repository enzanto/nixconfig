{
    config,
    lib,
    pkgs,
    ...
}:
with lib; let
    cfg = config.features.desktop.gaming;
in {
    options.features.desktop.gaming.enable = mkEnableOption "enable gaming";

    config = mkIf cfg.enable {
        programs.steam = {
            enable = true;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
            };
    };
}
