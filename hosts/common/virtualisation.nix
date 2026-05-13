{
  config,
  pkgs,
  inputs,
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
    virtio-win
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
       };
     };
     spiceUSBRedirection.enable = true;
   };

   # Configure QEMU bridge helper ACL
   environment.etc."qemu/bridge.conf".text = ''
     allow virbr0
     allow virbr1
     allow virbr2
     allow vmnett
   '';

   # Run QEMU as root to allow bridged networking access
   virtualisation.libvirtd.qemuRunAsRoot = true;
  services.spice-vdagentd.enable = true;
}
