{ pkgs, ...}: {
      imports = [
        ./vscode.nix
        ./plex.nix
		./hyprland.nix
    ./latex.nix
    ./wireshark.nix
      ];
      home.packages = with pkgs; [
        libreoffice
        thunderbird
        firefox
        vesktop
        yubioath-flutter
        qalculate-qt
      ];
}
