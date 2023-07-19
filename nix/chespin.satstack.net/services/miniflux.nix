{ config, pkgs, ... }:

{
  # https://github.com/bossley9/dataserver/blob/main/services/miniflux.nix
  postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    ensureDatabases = [ "miniflux" ];
    ensureUsers = [
      {
        name = "miniflux";
        ensurePermissions."DATABASE miniflux" = "ALL PRIVILEGES";
      }
    ];
    ensureUsers = [
      {
        name = "miniflux";
        ensurePermissions = {
          "DATABASE \"miniflux\"" = "ALL PRIVILEGES";
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  miniflux = {
    enable = true;
    adminCredentialsFile = "/etc/miniflux.env";
    config = {
      LISTEN_ADDR = "127.0.0.1:8031";
      BASE_URL = "https://chespin.satstack.net:4431/";
      METRICS_COLLECTOR = "1";
    }
  };
}