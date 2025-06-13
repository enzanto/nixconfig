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
  programs.bash = {
    enable = true;
    profileExtra = ''
      if [[ $(tty) == /dev/tty1 ]]; then
        Hyprland
      fi
    '';
  };
  home.packages = with pkgs; [
    networkmanagerapplet
    azure-cli
  ];
}
