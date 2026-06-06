{ lib, ... }: {
  imports = [
    ./home.nix
    ../common
    ../features/cli
  ];

  home.stateVersion = "24.11";

  programs.nixvim.plugins.obsidian.enable = lib.mkForce false;
  programs.nixvim.plugins.vimtex.enable = lib.mkForce false;

  features = {
    cli = {
      nixvim.enable = true;
      tmux.enable = true;
    };
  };
}
