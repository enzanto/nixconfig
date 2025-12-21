{pkgs, ...}: {
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
  programs.bash = {
    enable = true;
    profileExtra = ''
      if [[ $(tty) == /dev/tty1 ]]; then
        exec start-hyprland
      fi
    '';
  };
  home.packages = with pkgs; [
    opencode
    tradingview
    # jabref - Commented out due to build error.
  ];
}
