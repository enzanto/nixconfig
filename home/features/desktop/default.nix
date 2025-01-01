{ pkgs, ...}: {
      imports = [
        ./vscode.nix
        ./plex.nix
		./hyprland.nix
    ./latex.nix
      ];
      home.packages = with pkgs; [
        libreoffice
        thunderbird
        firefox
        vesktop
      ];
}
