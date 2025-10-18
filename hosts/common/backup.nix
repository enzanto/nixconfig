{
  config,
  lib,
  pkgs,
  ...
}: let
  common-excludes = [
    ".cache"
    "*/cache2"
    "*/Cache"
    ".config/Code/CachedData"
    ".container-diff"
    ".npm/_cacache"
    "*/node_modules"
    "*/bower_components"
    "*/_build"
    "*/.tox"
    "*/venv"
    "*/.venv"
    "Downloads"
    "virtualMachines"
    "vmware"
    "AI"
    ".local/share/Steam"
    "Games"
  ];

  backupPath = "/home/fredrik";

  localBorgJob = name: {
    encryption.mode = "none";
    extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
    repo = "/mnt/backup-drive/${name}";
    compression = "zstd,1";
    startAt = "daily";
    user = "fredrik";
  };

  remoteBorgJob = name: {
    encryption.mode = "none";
    environment.BORG_RSH = "ssh";
    environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
    environment.BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
    extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
    repo = "ssh://BORG//mnt/borg/${config.networking.hostName}/${name}";
    compression = "zstd,1";
    startAt = "daily";
    user = "fredrik";
  };

  prunePolicy = {
    within = "1d";
    daily = 7;
    weekly = 4;
    monthly = 2;
  };
in {
  config = {
    services.borgbackup.jobs = {
      # home-local =
      #   localBorgJob "backups/station/home-local"
      #   // rec {
      #     paths = backupPath;
      #     exclude = map (x: paths + "/" + x) common-excludes;
      #     prune.keep = prunePolicy;
      #   };

      home-remote =
        remoteBorgJob "backups/station/home-remote"
        // rec {
          paths = backupPath;
          exclude = map (x: paths + "/" + x) common-excludes;
          prune.keep = prunePolicy;
        };
    };
  };
}
