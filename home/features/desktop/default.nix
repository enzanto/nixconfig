{ pkgs, ...}: {
      imports = [
        ./vscode.nix
        ./plex.nix
		./hyprland.nix
      ];
      home.packages = with pkgs; [
        libreoffice
        thunderbird
        firefox
        discord
      ];
}
