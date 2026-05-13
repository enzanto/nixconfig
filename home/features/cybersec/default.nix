{pkgs, ...}: {
  imports = [
    ./scanning.nix
    ./cracking.nix
    ./web.nix
    ./exploitation.nix
    ./wireless.nix
    ./networking.nix
    ./osint.nix
    ./forensics.nix
  ];

  # Core tools always included
  home.packages = with pkgs; [
    obsidian # Note-taking for research
    inetutils
  ];
}
