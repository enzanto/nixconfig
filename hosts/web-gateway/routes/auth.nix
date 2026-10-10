{ ... }: {
  services.caddy.virtualHosts."auth.nerdiverset.no" = {
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

      reverse_proxy 127.0.0.1:9000
    '';
  };
}