{ 
    #config, 
    ... 
    }: { imports = [ 
    ./home.nix 
    ../common
    ../features/cli
    ../features/desktop ]; 
    
    features = {
        cli = {
            fish.enable = true;
            fzf.enable = true;
            neofetch.enable = true;
            neovim.enable=true;
        };
        desktop = {
            vscode.enable = true;
            plex.enable = false;
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
    }

