{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../features/cli
    ../features/desktop
  ];

  home.username = lib.mkDefault "kali";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  features = {
    cli = {
      nixvim.enable = true;
    };
  };
  # home.packages = with pkgs; [
  # ];
}
