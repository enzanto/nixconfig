# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "razorcrest"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  services = {
    blueman.enable = true;
    getty.autologinUser = "fredrik";
    jotta-cli.enable = true;
    openssh.enable = true;
    pcscd.enable = true; #needed for yubikey
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # Configure keymap in X11
    xserver.xkb = {
      layout = "no";
      variant = "";
    };
  };
  # Configure console keymap
  console.keyMap = "no";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.fredrik = {
  #   isNormalUser = true;
  #   description = "Fredrik Gjellestad";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   packages = with pkgs; [];
  # };
  programs.hyprland.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true; #for vscode server
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    nixd
    bicep
    pavucontrol
    kdePackages.konsole
    gnupg
    pinentry-qt
    yubikey-personalization
    yubikey-manager
    #  wget
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.jetbrains-mono
    font-awesome
  ];
  environment.variables = {
    XDG_PICTURES_DIR = "$HOME/Pictures";
  };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;
  xdg.portal.configPackages = [
    pkgs.gnome-session
  ];
  xdg.portal.extraPortals = [
    pkgs.kdePackages.xdg-desktop-portal-kde
    pkgs.xdg-desktop-portal-gtk
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
