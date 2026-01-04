{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./fish.nix
    ./fzf.nix
    ./neofetch.nix
    ./neovim.nix
    ./nixvim.nix
    ./tmux.nix
    inputs.nixvim.homeModules.nixvim
  ];
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  home.packages = with pkgs; [
    btop
    coreutils
    fd
    htop
    jq
    lshw
    ncdu
    newsboat
    python3
    ripgrep
    sshfs
    timeshift
    wl-clipboard
    zip
  ];
}
