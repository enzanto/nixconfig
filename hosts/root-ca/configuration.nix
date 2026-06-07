{
  config,
  pkgs,
  lib,
  ...
}: {
  # Platform
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  # Hostname
  networking.hostName = lib.mkOverride 40 "root-ca";

  # Locale
  console.keyMap = "no";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "nb_NO.UTF-8";
  };
  time.timeZone = "Europe/Oslo";

  # Boot
  boot.growPartition = true;
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  # Filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  # Proxmox VMA Image Settings
  proxmox.qemuConf = {
    cores = 1;
    memory = 1024;
    name = "root-ca";
    net0 = "virtio,bridge=vmbr0";
    bios = "ovmf";
    ostype = "l26";
  };
  virtualisation.diskSize = 10240;

  # Cloud-init
  services.cloud-init = {
    enable = true;
    network.enable = true;
  };

  # QEMU Guest Agent
  services.qemuGuest.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  security.sudo.wheelNeedsPassword = false;

  # Nix
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["root" "fredrik"];
    };
    optimise.automatic = true;
  };

  # Packages
  environment.systemPackages = with pkgs; [
    step-cli
    vim
    curl
  ];

  # System State Version
  system.stateVersion = "24.11";
}
