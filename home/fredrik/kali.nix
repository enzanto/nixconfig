{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ../features/cli
  ];

  home.username = lib.mkDefault "kali";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  programs.nixvim.plugins.obsidian.enable = lib.mkForce false;
  features = {
    cli = {
      nixvim.enable = true;
      tmux.enable = true;
    };
  };
  # home.packages = with pkgs; [
  # ];
  programs.home-manager.enable = true;
}
