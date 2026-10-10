{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.features.security.sops;
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];
  options.features.security.sops.enable = mkEnableOption "Enables HM sops secrets";

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "/home/fredrik/.config/sops/age/keys.txt";
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSymlinkPath = "/run/user/1000/secrets";
      defaultSecretsMountPoint = "/run/user/1000/secrets.d";

      secrets.open_ai = {
        path = "${config.sops.defaultSymlinkPath}/open_ai";
      };
    };
  };
}
