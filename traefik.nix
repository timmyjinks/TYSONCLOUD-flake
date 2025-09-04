{ config, ... }:
let
  secrets = import ./secrets.nix;
in
{
  systemd.services.traefik.serviceConfig.EnvironmentFile = "/etc/nixos/secrets/cloudflare.env";
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      providers.docker = {
        endpoint = "unix:///var/run/docker.sock";
        exposedByDefault = false;
        network = "frontend";
        watch = true;
      };

      certificatesResovlers.cloudflare.acme = {
        email = "${secrets.email}";
        storage = "${config.services.traefik.dataDir}/acme.json";
        caServer = "https://acme-v02.api.letsencrypt.org/directory";
        keyType = "EC256";
        dnsChallenge = {
          provider =  "cloudflare";
          resolvers = [ "1.0.0.1:53" "8.8.8.8:53"];
        };
      };

      api.dashboard = true;
      api.insecure = true;
    };
  };
}
