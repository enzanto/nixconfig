{pkgs, ...}: {
  imports = [
    ./hyprland.nix
    ./latex.nix
    ./plex.nix
    ./vscode.nix
    ./wireshark.nix
  ];
  home.packages = with pkgs; [
    firefox
    libreoffice
    obsidian
    qalculate-qt
    thunderbird
    vesktop
    yubioath-flutter
  ];
}
