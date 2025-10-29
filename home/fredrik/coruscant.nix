{
  #config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home.nix
    ../common
    ../features/cli
    ../features/desktop
  ];

  features = {
    cli = {
      fish.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
      neovim.enable = false;
      nixvim.enable = true;
      tmux.enable = true;
    };
    desktop = {
      vscode.enable = false;
      plex.enable = true;
      hyprland.enable = true;
      latex.enable = true;
      wireshark.enable = true;
    };
  };
  home.packages = with pkgs; [
    opencode
    tradingview
    jabref
  ];
}
