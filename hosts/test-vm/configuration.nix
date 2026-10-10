{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # ── Platform ──────────────────────────────────────────────────────────
  nixpkgs.hostPlatform = "x86_64-linux";

  # ── Hostname ──────────────────────────────────────────────────────────
  networking.hostName = lib.mkOverride 40 "test-vm"; # need to take presedence over proxmox-img which has mkdefault with a value of 50

  # ── Locale ─────────────────────────────────────────────────────────────
  console.keyMap = "no";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "nb_NO.UTF-8";
  };
  time.timeZone = "Europe/Oslo";

  # ── Boot ──────────────────────────────────────────────────────────────
  boot.growPartition = true;
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  # ── Filesystems ───────────────────────────────────────────────────────
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  # ── Proxmox VMA Image Settings ────────────────────────────────────────
  proxmox.qemuConf = {
    cores = 2;
    memory = 4096;
    name = "test-vm";
    net0 = "virtio,bridge=vmbr0";
    bios = "ovmf";
    ostype = "l26";
  };
  virtualisation.diskSize = 16384;

  # ── SSH ───────────────────────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  security.sudo.wheelNeedsPassword = false;

  # ── Packages ──────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    vim
    curl
    git
  ];

  # ── Wazuh Agent ───────────────────────────────────────────────────────
  services.wazuh-agent = {
    enable = true;
    manager.host = "192.168.10.168";
    package = inputs.wazuh.packages.${pkgs.system}.wazuh-agent;
  };

  # ── System State Version ──────────────────────────────────────────────
  system.stateVersion = "24.11";
  home-manager.users.fredrik.home.stateVersion = lib.mkDefault "24.11";
}
