{ ... }: {
  services.caddy.virtualHosts."audiobookshelf.nerdiverset.no" = {
    extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }

      reverse_proxy 10.1.1.150:80
    '';
  };
}