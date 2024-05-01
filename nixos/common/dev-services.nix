{ pkgs, ... }:
{

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  services.postgresql = {
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
      host  all      sm          127.0.0.1/32   scram-sha-256
      host  all      sm          ::1/128        scram-sha-256
      local all      sm                         scram-sha-256

      host  all      test        127.0.0.1/32   scram-sha-256
      host  all      test        ::1/128        scram-sha-256
      local all      test                       scram-sha-256

      host  all      airflow_user 127.0.0.1/32  scram-sha-256
      host  all      airflow_user ::1/128       scram-sha-256
      local all      airflow_user               scram-sha-256

      local all      postgres                   trust
      local all      root                       trust
    '';
    initialScript = pkgs.writeText "init-sql-script" ''
      CREATE USER sm WITH SUPERUSER ENCRYPTED PASSWORD '1234';
      CREATE USER airflow_user WITH SUPERUSER ENCRYPTED PASSWORD '1234';
    '';
  };

}
