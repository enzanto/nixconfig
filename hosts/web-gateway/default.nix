{modulesPath, ...}: {
  imports = [
    ../common
    ./configuration.nix
    ./routes
    "${modulesPath}/virtualisation/proxmox-image.nix"
  ];
}
