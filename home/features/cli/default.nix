{ pkgs, ...}: {

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