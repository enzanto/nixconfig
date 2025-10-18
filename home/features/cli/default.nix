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
    coreutils
    fd
    htop
    jq
    ripgrep
    zip
    python3
    sshfs
    timeshift
    lshw
    newsboat
    wl-clipboard
  ];
}
