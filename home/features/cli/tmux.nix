{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.tmux;
in {
  options.features.cli.tmux.enable = mkEnableOption "Enables tmux";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      customPaneNavigationAndResize = true;
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;
      plugins = with pkgs.tmuxPlugins; [
        # sensible
        # yank
        logging
        nord
        vim-tmux-navigator
        # resurrect
        # continuum
      ];
      # extraConfig = ''
      # '';
    };
  };
}
