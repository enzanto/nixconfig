# QEMU VM - build the importable qcow2 image with:
#   nix build .#nixos-vm
#   # result/image.qcow2 -> import into virt-manager as UEFI VM
{
  imports = [../common ./configuration.nix];
}
