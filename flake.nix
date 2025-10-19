{
  description = ''
    For questions just DM me on X: https://twitter.com/@m3tam3re
    There is also some NIXOS content on my YT channel: https://www.youtube.com/@m3tam3re

    One of the best ways to learn NIXOS is to read other peoples configurations. I have personally learned a lot from Gabriel Fontes configs:
    https://github.com/Misterio77/nix-starter-configs
    https://github.com/Misterio77/nix-config

    Please also check out the starter configs mentioned above.
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    sops-nix,
    nixpkgs-stable,
    hyprland,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};
    nixosConfigurations = {
      nixos-vm = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/nixos-vm];
      };
      serenity = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/serenity];
      };
      coruscant = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/coruscant
          sops-nix.nixosModules.sops
        ];
      };
      razorcrest = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/razorcrest];
      };
    };
    homeConfigurations = {
      "fredrik@nixos-vm" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/fredrik/nixos-vm.nix];
      };
      "kali@kali" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/fredrik/kali.nix];
      };
      "fredrik@coruscant" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home/fredrik/coruscant.nix
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
      "fredrik@razorcrest" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home/fredrik/razorcrest.nix
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
    };
    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      kube = pkgs.mkShell {
        name = "kube-dev-shell";

        packages = [
          (pkgs.python3.withPackages (python-pkgs: [
            python-pkgs.openshift
            python-pkgs.kubernetes
            python-pkgs.pyyaml
            python-pkgs.jmespath
          ]))
          pkgs.kubectl
          pkgs.k9s
          pkgs.ansible
          pkgs.kubernetes-helm
        ];

        shellHook = ''
          echo "🔧 Kubernetes dev shell ready for ${system}"
        '';
      };
    });
  };
}
