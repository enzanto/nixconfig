{
  networking.useNetworkd = true;
  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    netdevs = {
      "vlan3" = {
        netdevConfig = {
          Name = "enp5s0.3";
          Kind = "vlan";
        };
        vlanConfig = {
          Id = 3;
        };
      };

      "vmnett" = {
        netdevConfig = {
          Name = "vmnett";
          Kind = "bridge";
        };
      };
    };

    networks = {
      "enp5s0" = {
        matchConfig.Name = "enp5s0";
        networkConfig = {
          DHCP = "yes";
          VLAN = ["enp5s0.3"];
        };
      };

      "enp5s0.3" = {
        matchConfig.Name = "enp5s0.3";
        networkConfig = {
          Bridge = "vmnett";
        };
      };

      "vmnett" = {
        matchConfig.Name = "vmnett";
        networkConfig = {
          DHCP = "no"; # leave this unmanaged, router will handle DHCP
          Address = ["10.50.50.254/24"];
        };
        routes = [
          {
            Gateway = "0.0.0.0";
            Destination = "10.50.50.0/24";
            Table = 200;
          }
          {
            Destination = "0.0.0.0/0";
            Gateway = "10.50.50.1"; # your router on VLAN 2
            Table = 200;
          }
        ];
        routingPolicyRules = [
          {
            Priority = 10000;
            From = "10.50.50.0/24";
            Table = 200;
          }
        ];
      };
    };
  };
}
