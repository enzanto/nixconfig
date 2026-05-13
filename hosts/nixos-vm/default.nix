# QEMU VM - build and run with:
#   nix build .#nixosConfigurations.nixos-vm.config.system.build.vm
#   ./result/bin/run-nixos-vm-vm
{
  imports = [../common ./configuration.nix];
}
