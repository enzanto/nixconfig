{ pkgs, ...}: {
      imports = [
        ./fish.nix
        ./fzf.nix
        ./neofetch.nix
        ./neovim.nix
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
    ];
}