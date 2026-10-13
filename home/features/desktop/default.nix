{pkgs, ...}: {
  imports = [
    ./cad.nix
    ./hyprland.nix
    ./sway.nix
    ./latex.nix
    ./office.nix
    ./plex.nix
    ./vscode.nix
    ./wayland-common.nix
    ./wireshark.nix
  ];
  home.packages = with pkgs; [
    firefox
    kdePackages.okular
    obsidian
    vlc
    qalculate-qt
    yubioath-flutter
  ];
}
