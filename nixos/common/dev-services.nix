{ pkgs, ... }:
{

  virtualisation = {
    # docker = {
    # storageDriver = "zfs"; enable = true;
    # daemon.settings = { experimental = true; };
    # rootless = { enable = true; setSocketVariable = true; daemon.settings = { experimental = true; }; };
    # };

    # NixOS wiki claims Podman is not well supported for ZFS, let's test it
    podman = { enable = true; defaultNetwork.settings = { dns_enabled = true; }; };
    containers = {
      enable = true;
      storage.settings = { storage = { driver = "zfs"; }; };
    };
  };

  systemd.tmpfiles.rules = [
    "d /run/containers/storage 0776 root root - -"
  ];

  services.postgresql = {
    extensions = [ pkgs.postgresql15Packages.postgis ];
    enable = true;
    package = pkgs.postgresql_15;
    settings = {
      max_prepared_transactions = 3;
    };
    # ensureDatabases = [ "sm" ];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      host  all      sm          127.0.0.1/32    scram-sha-256
      host  all      sgis        127.0.0.1/32    scram-sha-256
      host  all      sm          192.168.1.0/24  scram-sha-256
      host  all      sgis        192.168.1.0/24  scram-sha-256
      host  all      sm          ::1/128         scram-sha-256
      host  all      sgis        ::1/128         scram-sha-256
      local all      sm                          scram-sha-256
      local all      sgis                        scram-sha-256

      host  all      test        127.0.0.1/32    scram-sha-256
      host  all      test        192.168.1.0/24  scram-sha-256
      host  all      test        ::1/128         scram-sha-256
      local all      test                        scram-sha-256

      host  all      airflow_user 127.0.0.1/32   scram-sha-256
      host  all      airflow_user 192.168.1.0/24 scram-sha-256
      host  all      airflow_user ::1/128        scram-sha-256
      local all      airflow_user                scram-sha-256

      local all      postgres                   trust
      local all      root                       trust
    '';
    initialScript = pkgs.writeText "init-sql-script" ''
      CREATE USER sm WITH SUPERUSER ENCRYPTED PASSWORD '1234';
      CREATE USER airflow_user WITH SUPERUSER ENCRYPTED PASSWORD '1234';
    '';
  };

}
