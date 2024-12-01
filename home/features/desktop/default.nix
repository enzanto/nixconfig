{ pkgs, ...}: {
      imports = [
        ./vscode.nix
        ./plex.nix
      ];
      home.packages = with pkgs; [
        libreoffice
        thunderbird
        firefox
        discord
      ];
}