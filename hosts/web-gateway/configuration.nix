{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Platform
  nixpkgs.hostPlatform = "x86_64-linux";

  # Hostname
  networking.hostName = lib.mkOverride 40 "web-gateway";
  networking.extraHosts = "127.0.0.1 ca.nerdiverset.no";

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
    cores = 2;
    memory = 4096;
    name = "web-gateway";
    net0 = "virtio,bridge=vmbr0,tag=10";
    bios = "ovmf";
    ostype = "l26";
  };
  virtualisation.diskSize = 16384;

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

  # Root CA cert for tiered mTLS access (kept for reference)
  environment.etc."caddy/root_ca.crt".source = ./root_ca.crt;

  # Full CA chain (root + intermediate) for client cert verification
  environment.etc."caddy/ca-chain.crt".source = ./ca-chain.crt;

  # Caddy with Coraza WAF + Cloudflare DNS
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/corazawaf/coraza-caddy/v2@v2.5.0"
        "github.com/caddy-dns/cloudflare@v0.2.4"
      ];
      hash = "sha256-rVGtlxygIQ6KZKGDh2Qq0DiL7oofwbMDQVadps+g/uE=";
    };
    openFirewall = true;

    globalConfig = ''
      order coraza_waf first
    '';
  };

  # Docker
  virtualisation.docker.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    age
    vim
    curl
    git
    step-cli
  ];

  # ── SOPS Secrets ─────────────────────────────────────────────────────
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = "/home/fredrik/.config/sops/age/keys.txt";

  sops.secrets.cloudflare_api_token = {
    owner = "caddy";
    group = "caddy";
    restartUnits = ["caddy.service"];
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [config.sops.secrets.cloudflare_api_token.path];
  systemd.services.caddy.after = ["sops-nix.service"];
  systemd.services.caddy.wants = ["sops-nix.service"];

  # System State Version
  system.stateVersion = "24.11";
}
