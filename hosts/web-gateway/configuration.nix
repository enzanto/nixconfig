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

  # Caddy with Coraza WAF + Cloudflare DNS
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/corazawaf/coraza-caddy/v2@v2.5.0"
        "github.com/caddy-dns/cloudflare@v0.2.4"
      ];
      hash = "sha256-qpLrJ4qwidQV3DHb1iRNXoUj9YzClT8wfd+NPxMMwzA=";
    };
    openFirewall = true;

    globalConfig = ''
      order coraza_waf first
    '';

    virtualHosts = {
      ":80" = {
        extraConfig = ''
          coraza_waf {
            load_owasp_crs
            directives `
              SecRuleEngine On
              Include @coraza.conf-recommended
              Include @crs-setup.conf.example
              Include @owasp_crs/*.conf
            `
          }
          respond "web-gateway — Caddy + Coraza"
        '';
      };
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    age
    vim
    curl
    git
  ];

  # Wazuh Agent
  services.wazuh-agent = {
    enable = true;
    manager.host = "192.168.10.168";
    package = inputs.wazuh.packages.${pkgs.system}.wazuh-agent;
  };

  # System State Version
  system.stateVersion = "24.11";
}
