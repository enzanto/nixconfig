{ pkgs, inputs,...}: {
      imports = [
        ./fish.nix
        ./fzf.nix
        ./neofetch.nix
        ./neovim.nix
        ./nixvim.nix
        inputs.nixvim.homeManagerModules.nixvim
      ];
    programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
    };
    home.packages = with pkgs; [
        coreutils
        fd
        htop
        jq
        ripgrep
        zip
        python3
        timeshift
        lshw
        newsboat
        xclip
    ];
}
