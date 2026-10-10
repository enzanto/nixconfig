{ ... }: {
  services.caddy.virtualHosts."nerdiverset.no" = {
    serverAliases = ["www.nerdiverset.no"];
    extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }

      coraza_waf {
        load_owasp_crs
        directives `
          SecRuleEngine On
          Include @coraza.conf-recommended
          Include @crs-setup.conf.example
          Include @owasp_crs/*.conf
        `
      }

      @internal {
        remote_ip 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 2a01:799:14aa:e00::/64
      }

      handle /ghost* {
        handle @internal {
          reverse_proxy https://10.1.1.150:443 {
            transport http {
              tls_insecure_skip_verify
            }
            header_up Host {http.request.host}
          }
        }
        handle {
          respond "Forbidden" 403
        }
      }

      reverse_proxy https://10.1.1.150:443 {
        transport http {
          tls_insecure_skip_verify
        }
        header_up Host {http.request.host}
      }
    '';
  };
}