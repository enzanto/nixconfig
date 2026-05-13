{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./home.nix
    ../common
    ../features/cli
    ../features/desktop
    ../features/cybersec
  ];

  # Override obsidian workspaces for the VM
  programs.nixvim.plugins.obsidian.settings.workspaces = lib.mkForce [
    {
      name = "Main";
      path = "~/Obsidian/Main";
    }
  ];

  # Enable SPICE vdagent in user session for clipboard sharing
  systemd.user.services.spice-vdagent = {
    Unit = {
      Description = "SPICE guest agent";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  features = {
    cli = {
      fish.enable = true;
      fzf.enable = true;
      nixvim.enable = true;
      tmux.enable = true;
    };
    desktop = {
      wireshark.enable = true;
    };
    cybersec = {
      scanning.enable = true;
      cracking.enable = true;
      web.enable = true;
      exploitation.enable = true;
      wireless.enable = true;
      networking.enable = true;
      osint.enable = true;
      forensics.enable = true;
    };
  };
}
