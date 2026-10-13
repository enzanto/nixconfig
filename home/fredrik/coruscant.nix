{pkgs, ...}: {
  imports = [
    ./home.nix
    ../common
    ../features/cli
    ../features/desktop
    ../features/cybersec
    ../features/security
  ];

  features.security.sops.enable = true;

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
      cad.enable = false;
      vscode.enable = false;
      plex.enable = true;
      hyprland.enable = true;
      sway.enable = true;
      latex.enable = true;
      office.enable = true;
      wireshark.enable = true;
    };
    cybersec = {
      forensics.enable = true;
      web.enable = true;
    };
  };
  programs.bash = {
    enable = true;
    profileExtra = ''
        if [[ $(tty) == /dev/tty1 ]]; then
      sway
        fi
    '';
  };
  programs.sqls.enable = true;
  home.packages = with pkgs; [
    dbeaver-bin
    opencode
    tradingview
    # jabref
    claude-code
    mangohud
  ];
}
