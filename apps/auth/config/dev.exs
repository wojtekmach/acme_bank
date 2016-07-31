use Mix.Config

config :auth, Auth.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "auth_#{Mix.env}",
  hostname: "localhost"
