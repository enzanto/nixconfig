{
  #config,
  pkgs,
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
    };
    desktop = {
      vscode.enable = true;
      plex.enable = true;
      hyprland.enable = true;
      latex.enable = true;
      wireshark.enable = true;
    };
  };
  home.packages = with pkgs; [
    tradingview
    azure-cli
    bicep
  ];
}
