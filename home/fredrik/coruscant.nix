{ config, ... }: { imports = [ 
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
            plex.enable = true;
            hyprland.enable = false;
        };
    };
    }

