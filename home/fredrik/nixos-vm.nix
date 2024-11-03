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
        };
        desktop = {
            vscode.enable = true;
        };
    };
    }

