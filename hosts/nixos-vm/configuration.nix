{
  config,
  pkgs,
  ...
}: {
  # ── Platform ──────────────────────────────────────────────────────────
  nixpkgs.hostPlatform = "x86_64-linux";

  # ── Disk ───────────────────────────────────────────────────────────────
  virtualisation.diskSize = 24576; # 24 GiB (lean trimmed closure; grows to virt-manager disk via growPartition/autoResize)

  # ── Boot ──────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.growPartition = true; # grow the image to the virt-manager disk on first boot

  # ── Filesystems (match the qemu-efi image layout) ─────────────────────
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };

  # ── Networking ────────────────────────────────────────────────────────
  networking.hostName = "nixos-vm";
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    networks = {
      # Primary NIC - DHCP (virt-manager default network / LAN)
      "05-eth0" = {
        matchConfig.Name = "eth0";
        networkConfig = {
          DHCP = "yes";
        };
      };
      # Second NIC (virbr1) - DHCP on isolated network
      "20-eth1" = {
        matchConfig.Name = "eth1";
        networkConfig = {
          DHCP = "yes";
        };
      };
      # Fallback for ens2 naming (different QEMU versions may use different names)
      "20-ens2" = {
        matchConfig.Name = "ens2";
        networkConfig = {
          DHCP = "yes";
        };
      };
    };
  };

  # ── Locale & Time ────────────────────────────────────────────────────
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";

  # ── Desktop: XFCE on X11 (reliable SPICE clipboard) ─────────────────
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Keyboard layout
  services.xserver.xkb.layout = "no";

  # ── Audio ─────────────────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # ── Guest integration ─────────────────────────────────────────────────
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # ── Services ──────────────────────────────────────────────────────────
  services.openssh.enable = true;
  services.postgresql.enable = true;

  # ── Docker (for Greenbone/OpenVAS containers) ─────────────────────────
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # ── OpenVPN ────────────────────────────────────────────────────────────
  services.openvpn.servers = {
    # HackTheBox VPN configuration
    # Place your HackTheBox .ovpn file at /etc/openvpn/hackthebox.ovpn
    hackthebox = {
      config = "config /etc/openvpn/hackthebox.ovpn";
      autoStart = false; # Don't auto-start, connect manually
    };
  };

  # ── Fish shell (needed for home-manager fish integration) ─────────────
  programs.fish.enable = true;

  # Enables wireshark
  users.extraGroups.wireshark.members = ["fredrik"];
  programs.wireshark.enable = true;
   # ── System packages ───────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    wget
    firefox
    spice-vdagent

    # VPN and networking
    openvpn
    wireguard-tools

    # Python
    python3
    python313Packages.pip

    # Docker and container tools
    docker-compose

    # OpenCL support for CPU-based acceleration (hashcat, etc.)
    ocl-icd        # OpenCL ICD loader (discovers available OpenCL devices)
    pocl           # Portable Computing Language (CPU-based OpenCL implementation)
  ];

  # ── Misc ──────────────────────────────────────────────────────────────
  system.stateVersion = "24.05";
}
