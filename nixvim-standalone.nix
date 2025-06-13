{pkgs, ...}: {
  imports = [
    ./home/features/cli/nixvim.nix
  ];

  features.cli.nixvim.enable = true;
}
