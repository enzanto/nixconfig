{pkgs, ...}: {
  imports = [
    ./cad.nix
    ./hyprland.nix
    ./latex.nix
    ./plex.nix
    ./vscode.nix
    ./wireshark.nix
  ];
  home.packages = with pkgs; [
    firefox
    kdePackages.okular
    libreoffice
    obsidian
    qalculate-qt
    thunderbird
    vesktop
    yubioath-flutter
    zathura
  ];
}
