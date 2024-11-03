{

  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.fredrik = {
    isNormalUser = true;
    description = "Fredrik Gjellestad";
    initialHashedPassword = "$y$j9T$sk.hKa9B20J30k4Yg.cwo1$kaU2NS3riwrbyTCTSXEdVKihvbLQrLc8YJ1cmc.Ruc6";
    extraGroups = [
      "wheel"
      "networkmanager"
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
