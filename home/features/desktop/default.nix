{pkgs, ...}: {
  imports = [
    ./cad.nix
    ./hyprland.nix
    ./latex.nix
    ./office.nix
    ./plex.nix
    ./vscode.nix
    ./wireshark.nix
  ];
  home.packages = with pkgs; [
    firefox
    kdePackages.okular
    obsidian
    qalculate-qt
    yubioath-flutter
  ];
}
