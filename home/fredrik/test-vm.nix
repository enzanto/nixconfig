{ lib, ... }: {
  imports = [
    ./home.nix
    ../common
    ../features/cli
  ];

  # ── Home Manager ───────────────────────────────────────────────────────
  home.stateVersion = "24.11";

  # ── Plugins ────────────────────────────────────────────────────────────
  programs.nixvim.plugins.obsidian.enable = lib.mkForce false;
  programs.nixvim.plugins.vimtex.enable = lib.mkForce false;

  # ── Minimal CLI-only setup, no desktop features ──────────────────────
  features = {
    cli = {
      nixvim.enable = true;
      tmux.enable = true;
    };
  };
}
