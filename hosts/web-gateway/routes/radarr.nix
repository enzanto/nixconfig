{ ... }: {
  services.caddy.virtualHosts."radarr.nerdiverset.no" = {
    extraConfig = ''
      # Disable HTTP/3 to keep TLS client cert verification consistent
      header -Alt-Svc

      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        client_auth {
          mode request
          trusted_ca_cert_file /etc/caddy/ca-chain.crt
        }
      }

      @internal {
        remote_ip 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 2a01:799:14aa:e00::/64
      }

      # Matcher: Client cert detected if TLS subject is not empty
      @hasCert expression `{tls_client_subject} != ""`

      # Route 1: Valid client cert detected → bypass Authentik, go straight to radarr
      handle @hasCert {
        reverse_proxy 10.1.1.150:80
      }

      # Route 2: No cert or invalid cert → use Authentik SSO
      handle {
        route {
          reverse_proxy /outpost.goauthentik.io/* http://localhost:9000

          forward_auth http://localhost:9000 {
            uri /outpost.goauthentik.io/auth/caddy
            copy_headers Authorization
            trusted_proxies private_ranges
          }

          handle @internal {
            reverse_proxy 10.1.1.150:80
          }
          handle {
            respond "Forbidden" 403
          }
        }
      }
    '';
  };
}