{ ... }: {
  services.caddy.virtualHosts."openhab.nerdiverset.no" = {
    extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }

      @internal {
        remote_ip 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 2a01:799:14aa:e00::/64
      }

      handle {
        handle @internal {
          reverse_proxy 10.1.1.150:80
        }
        handle {
          respond "Forbidden" 403
        }
      }
    '';
  };
}