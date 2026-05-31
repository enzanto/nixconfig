{
  config,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];
  # ── Boot ──────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Platform ──────────────────────────────────────────────────────────
  nixpkgs.hostPlatform = "x86_64-linux";

  # ── Networking ────────────────────────────────────────────────────────
  networking.hostName = "nixos-vm";
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    networks = {
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

  # ── QEMU/VM settings ─────────────────────────────────────────────────
  virtualisation = {
    memorySize = 8192; # 8 GB RAM
    cores = 4;
    diskSize = 40960; # 40 GB disk
    graphics = true;
    resolution = {
      x = 1920;
      y = 1080;
    };
    qemu.options = [
      "-vga qxl"
      "-spice port=5999,disable-ticketing=on"
      "-device virtio-serial"
      "-chardev spicevmc,id=vdagent,name=vdagent"
      "-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
      "-netdev"
      "bridge,id=hostnet1,br=virbr1"
      "-device"
      "virtio-net-pci,netdev=hostnet1,mac=52:54:00:6e:a2:f7"
    ];
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
