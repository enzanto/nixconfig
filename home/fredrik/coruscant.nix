{ 
    #config, 
    pkgs, 
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
            nixvim.enable=false;
        };
        desktop = {
            vscode.enable = true;
            plex.enable = true;
            hyprland.enable = true;
            latex.enable = true;
            wireshark.enable=true;
        };
    };
    home.packages = with pkgs; [
        tradingview
    ];
    }

