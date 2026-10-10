{modulesPath, ...}: {
  imports = [
    ../common
    ./configuration.nix
    "${modulesPath}/virtualisation/proxmox-image.nix"
  ];
}
