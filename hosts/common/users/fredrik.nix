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
      "wireshark"
      "docker" # to use docker without sudo
      "render"
      "lp"
      "lpadmin"
      #"libvirtd" #virtualization
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINk7Lqwa1g2P4hZb7pHVX2nVe2MVRwqK7e3QmMqv8qbp"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1vAmhE8tfcXFFvqjVD81uhOQ3pVroIrLZdsmB3KgCs"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  systemd.tmpfiles.rules = [
    "d /home/fredrik/Downloads 1755 fredrik users 14d" #man pages to fine tune this to avoid accesses time to be considered
  ];

  home-manager.users.fredrik =
    let
      hostName = config.networking.hostName;
      hm_file = ../../../home/fredrik/${hostName}.nix;
    in
    if hostName == "" then
      abort "networking.hostName is empty — cannot resolve HM config at home/fredrik/<hostname>.nix. Either set networking.hostName or remove hostname-based HM import."
    else if builtins.pathExists hm_file then
      import hm_file
    else
      abort "HM config not found at ${hm_file}. Create home/fredrik/${hostName}.nix or fix the hostname.";
}
