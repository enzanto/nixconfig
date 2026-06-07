{modulesPath, ...}: {
  imports = [
    ./configuration.nix
    "${modulesPath}/virtualisation/proxmox-image.nix"
  ];
}
