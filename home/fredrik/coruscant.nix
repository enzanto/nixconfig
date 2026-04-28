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
      cad.enable = true;
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
  programs.sqls.enable = true;
  home.packages = with pkgs; [
    mysql80
    dbeaver-bin
    opencode
    tradingview
    # azure-cli
    (azure-cli.withExtensions [azure-cli.extensions.azure-firewall])
    # jabref - Commented out due to build error.
  ];
}
