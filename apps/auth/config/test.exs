use Mix.Config

## Repo
config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "auth_#{Mix.env}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

## Comeonin
config :comeonin, :bcrypt_log_rounds, 4
