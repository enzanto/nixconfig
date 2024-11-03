{ pkgs, ...}: {
      imports = [
        ./fish.nix
        ./fzf.nix
        ./neofetch.nix
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
    ];
}