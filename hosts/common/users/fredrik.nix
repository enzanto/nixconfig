{

  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.fredrik = {
    isNormalUser = true;
    description = "Fredrik Gjellestad";
    initialHashedPassword = "$y$j9T$Gb4p4DxTaP21Rkag15wGo.$CfHfE2GMVkIzLU8Xfiuf0o6Cb2QVzOtWALNmljg8LX/";
    extraGroups = [
      "wheel"
      "networkmanager"
      # "docker" # to use docker without sudo
      #"libvirtd" #virtualization

    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINk7Lqwa1g2P4hZb7pHVX2nVe2MVRwqK7e3QmMqv8qbp"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1vAmhE8tfcXFFvqjVD81uhOQ3pVroIrLZdsmB3KgCs"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.fredrik = 
    import ../../../home/fredrik/${config.networking.hostName}.nix;
}
