{
  config,
  pkgs,
  ...
}: {
  programs.dconf.enable = true;

  boot.kernelParams = ["intel_iommu=on"];
  boot.kernelModules = [
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
    "vfio_virqfd"
  ];

  boot.extraModprobeConfig = ''
    options vfio-pci ids=2646:5013
  '';
  users.users.fredrik.extraGroups = ["libvirtd"];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    gtk3
    qemu_full
    virtiofsd
    libepoxy
    mesa
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  # # Network Configuration
  # systemd.network.enable = true;
  # # networking.useNetworkd = true;
  #
  # systemd.network = {
  #   netdevs = {
  #     "20-enp5s0.2" = {
  #       netdevConfig = {
  #         Kind = "vlan";
  #         Name = "enp5s0.2";
  #       };
  #       vlanConfig.Id = 2;
  #     };
  #     "20-tatooine" = {
  #       netdevConfig = {
  #         Kind = "bridge";
  #         Name = "tatooine";
  #       };
  #     };
  #   };
  #
  #   networks = {
  #     "30-enp5s0.2" = {
  #       matchConfig.Name = "enp5s0.2";
  #       networkConfig.Bridge = "tatooine";
  #       linkConfig.RequiredForOnline = "enslaved";
  #     };
  #
  #     "40-tatooine" = {
  #       matchConfig.Name = "tatooine";
  #       networkConfig.Address = ["192.168.10.200/24"];
  #       linkConfig.RequiredForOnline = "carrier";
  #     };
  #   };
  # };
}
